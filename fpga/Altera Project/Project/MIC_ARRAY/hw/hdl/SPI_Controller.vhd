-- Juan Azcarreta Master Thesis
-- Modified by: Corentin Ferry (EPFL)
-- An FPGA based platform for many-channel audio acquisition
-- SPI Controller Module VHDL Description
-- 15th February 2016
-- EPFL: LCAV & LAP  

-- Notes (from AD7606 data sheet from Analog Device Page 7 to 9 Time Specifications):
-- Timing requirements t1: Max. time between busy high and convst high 40 ns (2 clk)
-- t4: Busy falling edge to to CS_n falling edge set up time (0)
-- t7: Minimum delay between reset low to convst high 25 ns (2clk)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY SPI_Controller IS
	 GENERIC (
			MICS_N : integer := 8;	-- Mics per array number
			ARRAY_N : integer := 6  -- Arrays number
			);
    PORT (
    -- System signals
    clk     			   :     in std_logic;  	-- clk will be 48 MHz, enough to respect timings  
    reset_n   			   :     in std_logic;
    -- Interface with ADC
	 reset					:		out std_logic;
    busy_OR0    		   :     in std_logic;
	 busy_OR1    		   :     in std_logic;
    busy_OR2    		   :     in std_logic;    
	 MISO_00    			:     in std_logic;
    MISO_01    		   :     in std_logic;
    MISO_10    			:     in std_logic;
    MISO_11    		   :     in std_logic;
    MISO_20    			:     in std_logic;
    MISO_21    		   :     in std_logic;
    CONVST0     			:     out std_logic;
    CONVST1     			:     out std_logic;
    CONVST2     			:     out std_logic;
    CS_n     				:     out std_logic;    
    SCLK    				:     out std_logic;		-- SCLK will be 12.5 MHz, enough to respect timings
    -- Interface with slave
    Start   				:     in std_logic;
    -- Interface with DMA
    Data        			:     out std_logic_vector(31 DOWNTO 0); 
    DataRd 					:	   in std_logic;
	 sel						:		IN std_logic_vector(2 DOWNTO 0);
	 array_vector			:		in std_logic_vector(2 DOWNTO 0);
	 Data_Available 	   :     out std_logic;							-- Wait till 32*48 data available (i.e. 1536)	
	 Stop						:		in std_logic
    );
END SPI_Controller;

ARCHITECTURE comp OF SPI_Controller IS

-- FPGA cock settings
constant CLK_PERIOD      : time := 20 ns;
constant SCLK_PERIOD 	 : integer := 4;		 -- Period scale factor between clk to SCLK
-- Channel Number and sample resolution
constant RESOLUTION 		 : integer := 16;		 --  Sample Depth of audio signals
constant CHANNELS 		 : integer := MICS_N; -- Number of ADC inputs 	
constant BURST_COUNT 	 : integer := 4;		 -- Length of the burst transfer

type MICS_Number is array(0 to (MICS_N*ARRAY_N)-1) of std_logic;

subtype bit_dim is std_logic_vector(RESOLUTION - 1 DOWNTO 0);
type bit_dim_vector is array(natural range <>) of bit_dim;
subtype mic_dim is bit_dim_vector(0 to MICS_N - 1);
type mic_dim_vector is array(natural range <>) of mic_dim;
subtype array_dim is mic_dim_vector(0 to ARRAY_N-1);

-- register_array: Register of (MICS_N*ARRAY_N) channels and RESOLUTION depth per chanel.
type register_array is array(0 to (MICS_N*ARRAY_N) - 1) of std_logic_vector(RESOLUTION - 1 DOWNTO 0);
type FIFO_size 	is array(0 to (MICS_N*ARRAY_N) - 1)	of std_logic_vector(2 DOWNTO 0);

-- SPI controller state machine definition
type state_transfer is (Idle, Waiting1,Waiting2,Waiting3,Waiting4, Wait_For_Conversion, Converting, Transmission, Read_State, Waiting5, Waiting6, Waiting7);
signal SPI_state : state_transfer;
		
-- System counter signals and variables
signal t2 :  integer range 0 to 5;   -- Control CONVST low pulse duration (Refer to Note 1 in the header of this file)
signal i :   integer range 0 to CHANNELS - 1;

-- Define FIFOs signals
signal wrreq : MICS_Number ; -- Write request
signal rdreq : MICS_Number ; -- Read request
signal usedw : FIFO_size;	  -- # of written words 
signal po 	  : register_array;	-- Serial in-Parallel out register
signal output : register_array;  -- Register array output from the FIFOs

-- Define signals for counters
signal CntBit 		  : integer range 0 to RESOLUTION - 1 ;	
signal CntChannel   : integer range 0 to MICS_N - 1;
signal sel_int		  : integer range 0 to BURST_COUNT;
signal array_number : integer range 0 to ARRAY_N - 1;

-- Frequency divider signals
signal SCLK_counter : integer range 0 to 5 ;
signal SCLK_sig 	  : std_logic ;
signal SCLK_falling : std_logic ;

-- Define signals to interface with AD760
signal CS_n_signal : std_logic;
signal busy_sig1   : std_logic;		-- 1st register for Busy signal
signal busy_sig2   : std_logic;		-- 2nd register for Busy signal
signal aux1			 : std_logic;		
signal aux2 		 : std_logic;	
signal CONVST	    : std_logic;

-- Declare FIFO1 component
component FIFO_Mic 
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END component;

begin
-- SCLK generator
 clk_prescaler: process (reset_n, clk) begin
        if (reset_n = '0')   then
            SCLK_sig <= '1';
            SCLK_counter <= 0;
       elsif rising_edge(clk) then
		 -- Generate SCLK just during acquisition (i.e. CS_n ='0')
				if CS_n_signal = '0' then
				-- Frequency divider (from 50 MHz to 12.5 MHz)
					if (SCLK_counter = SCLK_PERIOD/4) then
						SCLK_counter <= 0;
						if SCLK_sig = '1' then
						-- Generate simple clock 
							SCLK_sig <= '0';
							SCLK_falling <= '1';
						else
							SCLK_sig <='1';
						end if;
					else
						SCLK_falling <= '0';
						SCLK_counter <= SCLK_counter + 1;
					end if;
			  else
					SCLK_sig <= '1';
					SCLK_counter <= 0;
			  end if;
       end if;
    end process;	 
SCLK <= SCLK_sig;
CS_n <= CS_n_signal;

-- DFF to avoid metastability of asynchronous inpust (i.e., busy coming from ADC)
synchronization1: process (reset_n, clk) begin
			if (reset_n = '0')   then
				busy_sig1 <= '0';
				busy_sig2 <= '0';
			elsif rising_edge(clk) then  
				 busy_sig1 <= busy_OR1 and busy_OR2 and busy_or0;
				busy_sig2 <= busy_sig1;
			end if;
		end process;
		
-- Create FIFO for 48 mics
G1 : FOR i IN 0 TO 47 GENERATE 
FIFO_Mic_inst: FIFO_Mic 
	port map (
		clock		=>    clk,
		data		=>	 	po(i),		-- Input
		rdreq		=>		rdreq(i),	-- Read request
		wrreq		=>		wrreq(i),	-- Write request
		q			=>		output(i),	-- output
		usedw		=>		usedw(i)		-- used space from writing
		);	
END GENERATE G1;

-- SPI Controller state machine process
		state_machine : process (Clk, reset_n)
		begin		
			if reset_n = '0' then
			-- Reset the system to default values
					SPI_state        <= Idle;
					CONVST <= '1';	
					t2			   	  <=  0;
					po			 		  <= (others => (others => '0'));
					wrreq 			  <= (others => '0');
					rdreq 	  		  <=(others => '0');
					CntChannel	     <= CHANNELS - 1;
					CntBit	    	  <= RESOLUTION-1; 
					reset				  <= '0';
					CS_n_signal <= '1';
		
			elsif rising_edge(clk) then
			-- If Stop deasserted by DMA unit
				if Stop ='0' then
			-- SPI controller state machine
				case SPI_state is
					when Idle 		=>	
					-- If Start asserted by Slave unit
						if Start = '1'  then					
							SPI_state <= Waiting1;
							reset <= '0';							
						end if;	
						-- Waiting states to fill timing requirements of ADC regarding reset signal(60 ns high pulse width)
					when Waiting1 	=>	 SPI_state <= Waiting2; reset <= '1';
					when Waiting2 	=>	 SPI_state <= Waiting3; 
					when Waiting3 	=>	 SPI_state <= Waiting4; 
					when Waiting4 	=>	 SPI_state <= Waiting5; reset <= '0';
					when Waiting5 	=>	 SPI_state <= Waiting6; 
					when Waiting6 	=>	 SPI_state <= Waiting7; 

					when Waiting7 	=>	
						wrreq <= (others => '0'); 
						CONVST <= '0';
						if t2 < 4 then		-- Deassert and assert CONVST after 80 ns according ADC Datasheet (check Note 1 in the header of this file) 
							t2 <= t2 + 1;
						else 
							t2 <= 0;
							SPI_state <= Wait_For_Conversion;
							CONVST <= '1';
						
						end if;
					when Wait_For_Conversion =>
					-- Do no write in FIFO
						wrreq <= (others => '0'); 
						if busy_sig2 = '1' then
							-- When busy = '1' the conversion starts
							SPI_state <= Converting;
						end if;
						
					when Converting =>		
						-- Detect busy falling edge of busy to acknowledge the conversion has finished
						if busy_sig2 = '0'  then
						-- Start SPI Transmission
								CS_n_signal <= '0';
								SPI_state <= Transmission;	
						end if;		
						
					when Transmission =>
						if SCLK_falling = '1' then   -- Detect SCLK falling edge
							-- Serial In - Parallel out register
							   -- MISO00 - J4
								po(CntChannel)(15 downto 1) <= po(CntChannel)(14 downto 0);
								po(CntChannel)(0) <= MISO_00;
								-- MISO01 - J4
								po(8 + CntChannel)(15 downto 1) <= po(8 + CntChannel)(14 downto 0);
								po(8 + CntChannel)(0) <= MISO_01;
								-- MISO10 - J3
								po(16 + CntChannel)(15 downto 1) <= po(16 + CntChannel)(14 downto 0);
								po(16 + CntChannel)(0) <= MISO_10;
								-- MIS11 - J3
								po(24 + CntChannel)(15 downto 1) <= po(24 + CntChannel)(14 downto 0);
								po(24 + CntChannel)(0) <= MISO_11;
								-- MISO20 - J2
								po(32 + CntChannel)(15 downto 1) <= po(32 + CntChannel)(14 downto 0);
								po(32 + CntChannel)(0) <= MISO_20;
								-- MISO21 - J2
								po(40 + CntChannel)(15 downto 1) <= po(40 + CntChannel)(14 downto 0);
								po(40 + CntChannel)(0) <= MISO_21;
							if CntBit >0  then
								CntBit <= CntBit - 1;	
							else
							-- Span all the bits (16 per sample)
								CntBit <= RESOLUTION-1;
								if CntChannel > 0 then		
								-- Span all the channels (8 per ADC, i.e, per board)
									CntChannel <= CntChannel - 1;
								else	
								-- When finish stop writing, start again in next array
									SPI_state <= Wait_For_Conversion;
									wrreq <= (others => '1');
									CntChannel <= CHANNELS - 1;
									CS_n_signal <= '1';
								end if;
							end if;
						 end if;
						-- Read During Conversion. Start conversion after 3.28 us the conversion starts(to obtain a period of 48 kHz)
						-- To change the sampling frequency (up to 50 kHz), changethe conditions in the following if function:
						 if CntChannel = CHANNELS - 3 then
							if CntBit = 6 then
									CONVST <= '0';
							 elsif CntBit = 5 then
									CONVST <= '1';
							 end if;
						 end if;
						 
				  when others => null;
					end case;
				  
				 -- Check if there is data in all the FIFOS
				 FOR i IN 0 TO ARRAY_N*MICS_N - 1 LOOP
					if usedw(i)(2 DOWNTO 0) > "001" and array_number < ARRAY_N - 1  then
							Data_Available <= '1';
					-- If we reach last array we do not transfer more data
					else
							Data_Available <= '0';	
					end if;
 				 END LOOP;	
			
				-- DMA Read Request
				 if DataRd = '1' then
						rdreq <= (others => '1');
			    else
						rdreq <= (others => '0');
						-- Output multiplexer controlled by DM A(through sel_int signal). Send two samples each time (Interleaved)
						if sel_int > 0 then
								Data  <= output(8*array_number+ 2*sel_int-2) & output(8*array_number+ 2*sel_int-1);
						else
								Data <= (others => '0');
						end if;
				 end if;
	
			-- Stop acquisition (if Start = '0' in DMA) 
			elsif Stop = '1' then
						SPI_state <= idle;
						reset <= '0';
						CS_n_signal <= '1';
			end if;
		end if;
	  end process state_machine;
	  
-- Outputs of the system
sel_int		 <= to_integer(unsigned(sel));
array_number <= to_integer(unsigned(array_vector));

-- Outputs to the SPI Controller
CONVST0 <= CONVST;
CONVST1 <= CONVST;
CONVST2 <= CONVST;
end comp;