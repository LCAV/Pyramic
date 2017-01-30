-- Auxiliary DMA driver for Pyramic
-- Author: Corentin Ferry
-- Date: October 2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Output_Buffer_Driver is
generic
(
	TWO_CHANNELS_SAMPLE_WIDTH : natural := 32; -- L + R
	ONE_CHANNEL_SAMPLE_WIDTH : natural := 16 
	
);
port
(
-- Global signals
	clk         		  : IN std_logic;
	reset_n        	  : IN std_logic;

-- DMA : Avalon Memory Mapped Master
	DMA_Addr       	: OUT std_logic_vector (31 DOWNTO 0); -- this should be the same as in the spi dma
	DMA_ByteEnable	   : OUT std_logic_vector (3 DOWNTO 0);  -- 32 bits = 4 bytes
	--DMA_Ready         : IN std_logic;
	DMA_Read          : OUT std_logic;
	DMA_ReadDataValid : IN std_logic;
	DMA_Data          : IN std_logic_vector ((TWO_CHANNELS_SAMPLE_WIDTH -1) DOWNTO 0);
	DMA_WaitRequest   : IN std_logic;

-- Connection to audio source : Avalon Streaming Sink (L + R)
	STSink_In_L_Ready   : OUT std_logic; 
	STSink_In_L_Valid   : IN std_logic; 
	--STSink_In_L_Data    : IN std_logic_vector ((ONE_CHANNEL_SAMPLE_WIDTH -1) DOWNTO 0);
	STSink_In_L_Data    : IN std_logic_vector (21 DOWNTO 0);
	STSink_In_L_SOP       : IN std_logic;
	STSink_In_L_EOP       : IN std_logic;
	
	STSink_In_R_Ready   : OUT std_logic; 
	STSink_In_R_Valid   : IN std_logic; 
	--STSink_In_R_Data    : IN std_logic_vector ((ONE_CHANNEL_SAMPLE_WIDTH -1) DOWNTO 0);
	STSink_In_R_Data    : IN std_logic_vector (21 DOWNTO 0);
	STSink_In_R_SOP       : IN std_logic;
	STSink_In_R_EOP       : IN std_logic;
	

-- Configuration Slave (Avalon MM Slave)
	Cfg_Avalon_Address   : IN std_logic_vector(2 DOWNTO 0);
	Cfg_Avalon_Read      : IN std_logic;
	Cfg_Avalon_Write     : IN std_logic;
	Cfg_Avalon_ReadData  : OUT std_logic_vector(31 downto 0);
	Cfg_Avalon_WriteData : IN std_logic_vector(31 downto 0);
	
	
-- Avalon Streaming Sources (L + R)
	Out_L_Avalon_Data  : out std_logic_vector ((ONE_CHANNEL_SAMPLE_WIDTH -1) DOWNTO 0);
	Out_L_Avalon_Valid : OUT std_logic;
	Out_L_Avalon_Ready : in  std_logic;
  
  	Out_R_Avalon_Data  : out std_logic_vector ((ONE_CHANNEL_SAMPLE_WIDTH -1) DOWNTO 0);
	Out_R_Avalon_Valid : OUT std_logic;
	Out_R_Avalon_Ready : in  std_logic
);
end Output_Buffer_Driver;

architecture master of Output_Buffer_Driver is

-- finite state machines : 
type DMA_state is (s_idle, s_init_dma_read, s_wait_memory, s_read_memory, s_waitForClock);
type AvalonIn_State is (s_wait_avalon_in, s_read_avalon);

-- Left Avalon Sink
signal signal_holder_L : std_logic_vector((ONE_CHANNEL_SAMPLE_WIDTH - 1) DOWNTO 0);
signal stateAvalonLIn : AvalonIn_State;
signal LDataValid : std_logic;

-- Right Avalon Sink
signal signal_holder_R : std_logic_vector((ONE_CHANNEL_SAMPLE_WIDTH - 1) DOWNTO 0);
signal stateAvalonRIn : AvalonIn_State;
signal RDataValid : std_logic;

-- DMA
signal stateDMA: DMA_state;
signal SndAddr : unsigned(31 DOWNTO 0);
signal signal_holder_DMA : std_logic_vector((TWO_CHANNELS_SAMPLE_WIDTH -1) DOWNTO 0);
signal DataOK_DMA : std_logic;

-- Configuration Slave (constants for now)
signal base_read_addr : unsigned(31 downto 0) := to_unsigned(900 * 1024 * 1024, 32); -- 900 MiB = 900 * 1024 KiB = 900 * 1024 * 1024 B
signal sound_len : unsigned(31 downto 0) := to_unsigned(100 * 1024 * 1024, 32); -- 100 MiB
signal byteEnable : unsigned(3 downto 0) := "1111"; -- 32 bits are enabled ( L + R )
signal Use_Memory : std_logic := '1';

-- Clock divider
signal pulse: std_logic;
signal clockCounter : integer range 0 to 1000; -- counter to have dma periodic (read samples at 48 khz)

begin

read_DMA : process (reset_n,clk)
begin
	if reset_n = '0' then 
		-- reset everything here
		DMA_Addr <= (others => '0');
		DMA_ByteEnable <= (others => '0');
		DMA_Read <= '0';
		signal_holder_DMA <= (others => '0');
		DataOK_DMA <= '0';
	elsif rising_edge(clk) then
		if Use_Memory = '1' then

			
			case stateDMA is 
				when s_idle => -- don't do dma if not needed
					DMA_Read <= '0';
					DMA_Addr <= (others => '0');
					DMA_ByteEnable <= (others => '0');
					if SndAddr < base_read_addr then
						SndAddr <= base_read_addr;
					end if;
					stateDMA <= s_init_dma_read;
				-- DMA 
				when s_init_dma_read =>
					-- initialize dma transfer
					DMA_Addr <= std_logic_vector(SndAddr);
					DMA_ByteEnable <= std_logic_vector(byteEnable); 
					DMA_Read <= '1';
					stateDMA <= s_wait_memory;
					
				when s_wait_memory =>
					-- wait for data to come from memory -takes two cycles according
					-- to avalon master specs p. 29
					
					-- The read is pipelined with 2 wait cycles !! Obvisouly we can wait a bit
					-- if the codec is too slow
					DMA_Addr <= std_logic_vector(SndAddr);
					if DMA_WaitRequest = '0' then
						-- Data is there
						stateDMA <= s_read_memory;
						DMA_Read <= '0'; 
					end if;
				when s_read_memory =>
					-- this state waits for the data to be available on DMA
					-- i.e. readdatavalid is 1
					if DMA_ReadDataValid = '1' then -- I assert this, I think it's never set to 0
						DataOK_DMA <= '1';
						signal_holder_DMA <= DMA_Data;
						if SndAddr < base_read_addr + sound_len then -- usage d'un compteur
							SndAddr <= SndAddr + 4;
						else
							SndAddr <= base_read_addr;
						end if;
						stateDMA <= s_waitForClock;

					end if;
				-- Each read cycle should take 1000 cycles so we pass the samples at 48 kHz to the audio controller
				when s_waitForClock =>
					if pulse = '1' then
						stateDMA <= s_idle;
					end if;
				when others => null;
			end case;

		else
			DMA_Addr <= (others => '0');
			DMA_ByteEnable <= (others => '0');
			DMA_Read <= '0';
			DataOK_DMA <= '0';
			SndAddr <= base_read_addr;
		end if;
	end if;
end process;

genPulse : process(clk, reset_n)
begin
	if reset_n = '0' then
		clockCounter <= 0;
	elsif rising_edge(clk) then
		if Use_Memory = '1' then
			clockCounter <= clockCounter + 1;
			pulse <= '0';
			if clockCounter = 999 then	
				clockCounter <= 0;
				pulse <= '1';
			end if;
		else
			clockCounter <= 0;
		end if;
	end if;
end process;
-- These ones should get data at 48 kHz; whatever they do, the output will be at 48 kHz rate so there's no trouble
left_read_statem : process(reset_n, clk)
begin
	if reset_n = '0' then 
		STSink_In_L_Ready <= '0';
		signal_holder_L <= (others => '0');
		stateAvalonLIn <= s_wait_avalon_in;
		LDataValid <= '0';
	elsif rising_edge(clk) then
		if Use_Memory = '0' then
			case stateAvalonLIn is
				when s_wait_avalon_in =>
					LDataValid <= '0';
					if STSink_In_L_Valid = '1' then
						stateAvalonLIn <= s_read_avalon;
					end if;
				when s_read_avalon => 
					if STSink_In_L_Valid = '1' then
						STSink_In_L_Ready <= '1';
						signal_holder_L <= STSink_In_L_Data(21 DOWNTO 6);
						LDataValid <= '1';
					else
						-- transfer is finished ! Now we're not ready to accept data anymore.
						STSink_In_L_Ready <= '0';
						stateAvalonLIn <= s_wait_avalon_in;
						LDataValid <= '0';
					end if;
				when others => null;
			end case;
		else
			stateAvalonLIn <= s_wait_avalon_in;
			LDataValid <= '0';
			STSink_In_L_Ready <= '0';
			signal_holder_L <= (others => '0');
		end if;
	end if;
end process left_read_statem;

right_read_statem : process(reset_n, clk)
begin
	if reset_n = '0' then 
		STSink_In_R_Ready <= '0';
		signal_holder_R <= (others => '0');
		stateAvalonRIn <= s_wait_avalon_in;
		RDataValid <= '0';
	elsif rising_edge(clk) then
		if Use_Memory = '0' then
			case stateAvalonRIn is
				when s_wait_avalon_in =>
					RDataValid <= '0';
				-- there is 1 waiting cycle between valid and ready assertions
					if STSink_In_R_Valid = '1' then
						stateAvalonRIn <= s_read_avalon;
					end if;
				when s_read_avalon => 
					if STSink_In_R_Valid = '1' then
						STSink_In_R_Ready <= '1';
						signal_holder_R <= STSink_In_R_Data(21 DOWNTO 6);
						RDataValid <= '1';
					else
						-- transfer is finished ! Now we're not ready to accept data anymore.
						STSink_In_R_Ready <= '0';
						stateAvalonRIn <= s_wait_avalon_in;
						RDataValid <= '0';
					end if;
				when others => null;
			end case;
		else
			stateAvalonRIn <= s_wait_avalon_in;
			RDataValid <= '0';
			STSink_In_R_Ready <= '0';
			signal_holder_R <= (others => '0');
		end if;
	end if;
end process right_read_statem;

-- There is no FIFO ! If needed, we will add one. (there are already fifos in the audio controller before the codec)
OutputAvalonMaster: process(reset_n, clk) 
begin
	if reset_n = '0' then
		Out_L_Avalon_Valid <= '0';
		Out_L_Avalon_Data <= (others => '0');
		Out_R_Avalon_Valid <= '0';
		Out_R_Avalon_Data <= (others => '0');
	elsif rising_edge(clk) then
	
		if Use_memory = '0' then
			Out_L_Avalon_Data <= signal_holder_L;
			Out_R_Avalon_Valid <= LDataValid;
		else
			Out_L_Avalon_Data <= signal_holder_DMA(31 downto 16);
			Out_L_Avalon_Valid <= DataOK_DMA;
		end if;
		
		if Use_memory = '0' then
			Out_R_Avalon_Data <= signal_holder_R;
			Out_R_Avalon_Valid <= RDataValid;
		else
			Out_R_Avalon_Data <= signal_holder_DMA(15 downto 0);
			Out_R_Avalon_Valid <= DataOK_DMA;
		end if;
		
		
	end if;
end process OutputAvalonMaster;

configSlave : process(reset_n, clk)
begin
	if reset_n = '0' then
		 base_read_addr <= to_unsigned(900 * 1024 * 1024, 32);
		 sound_len <= to_unsigned(100 * 1024 * 1024, 32);
		 Use_Memory <= '0'; -- by default we use the Avalon Streaming (to avoid hearing grabage)
	elsif rising_edge(clk) then
		if Cfg_Avalon_Write = '1' then
			case Cfg_Avalon_Address is
				when "000" =>
					base_read_addr(31 downto 0) <= unsigned(Cfg_Avalon_WriteData);
				when "001" =>
					sound_len(31 downto 0) <= unsigned(Cfg_Avalon_WriteData);
				when "010" =>
					Use_Memory <= Cfg_Avalon_WriteData(0);
				when others => null;
			end case;
		elsif Cfg_Avalon_Read = '1' then
			Cfg_Avalon_ReadData(31 downto 0) <= (others => '0');
			case Cfg_Avalon_Address is
				when "000" =>
					Cfg_Avalon_ReadData(31 downto 0) <= std_logic_vector(base_read_addr(31 downto 0));
				when "001" =>
					Cfg_Avalon_ReadData(31 downto 0) <= std_logic_vector(sound_len(31 downto 0));
				when "010" =>
					Cfg_Avalon_ReadData(0) <= Use_Memory;
				when others => null;
			end case;
		end if;

	end if;

end process configSlave;

end architecture master;