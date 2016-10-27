-- Auxiliary DMA driver for Pyramic
-- Author: Corentin Ferry
-- Date: October 2016


-- Use twice this module to get stereo sound!


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Output_Buffer_Driver is
generic
(
	SAMPLE_WIDTH : natural := 32
);
port
(
-- Global signals
	clk         		  : IN std_logic;
	reset_n        	  : IN std_logic;

-- DMA : Avalon Memory Master
	DMA_Addr       	: OUT std_logic_vector (31 DOWNTO 0); -- this should be the same as in the spi dma
	DMA_ByteEnable	   : OUT std_logic_vector (3 DOWNTO 0);  
	DMA_Ready         : IN std_logic;
	DMA_Valid         : IN std_logic;
	DMA_Data          : IN std_logic_vector ((SAMPLE_WIDTH -1) DOWNTO 0);

-- Connection to audio source : Avalon Streaming Sink
	In_Avalon_Ready   : OUT std_logic; 
	In_Avalon_Valid   : IN std_logic; 
	In_Avalon_Data    : IN std_logic_vector ((SAMPLE_WIDTH -1) DOWNTO 0);

-- Memory Management
	Use_Memory        : IN std_logic; -- Flag indicating whether to use the memory or the Streaming Sink
	Data_Length       : IN std_logic_vector (24 DOWNTO 0); -- if we set the cap to 128 MB, then 24 bits should be enough to specify the data length IN BYTES
	Data_Valid        : IN std_logic; -- Flag indicating whether there is valid data in the buffer and we can start reading from it
	
	
-- Signals for Avalon Streaming Source (typically connected to the codec, but can be connected elsewhere)
	Out_Avalon_Ready : IN std_logic; 
	Out_Avalon_Valid : OUT std_logic;
	Out_Avalon_Data  : OUT std_logic_vector ((SAMPLE_WIDTH -1) DOWNTO 0); -- a single word for the avalon streaming interface
);
end Output_Buffer_Driver

architecture master of Output_Buffer_Driver is

-- finite state machine : 
type state_type is (s_idle, s_wait_avalon_in, s_read_avalon, s_init_dma_read, s_wait_memory, s_read_memory);
signal stateM: state_type;

signal signal_holder : signed((SAMPLE_WIDTH - 1) DOWNTO 0);

begin

state_machine : process (reset_n,clk)
begin
	if reset_n = '1' then 
		-- reset everything here
		
	elsif rising_edge(clk) then	
		case stateM is 
			-- insert states here for reading data from the beamformer
			when s_idle =>
				-- choose whether we read from 
				if Use_Memory = '1' then
					stateM = s_init_dma_read;
				else
					stateM = s_wait_avalon_in;
				end if
			when s_wait_avalon_in =>
				-- let's wait for the axuiliary avalon interface to be ready...
				In_Avalon_Ready <= '1'
				if In_Avalon_Valid = '1' then
					stateM = s_read_avalon;
				end if
			when s_read_avalon => 
				-- we pass the data to the codec without buffering it in a first step.
				-- If samples are dropped, then we will consider buffering them up.
				if In_Avalon_Valid = '1' then
					signal_holder <= In_Avalon_Data;
				else
					-- transfer is finished ! Now we're not ready to accept data anymore.
					In_Avalon_Ready <= '0';
					stateM <= s_idle;
				end if
			-- DMA : we read !
			when s_init_dma_read =>
				-- initialize dma transfer
				-- TBI
			when s_wait_memory =>
				-- wait for data to come from memory -hey, it takes several cycles !
				if DMA_ready = '1' then
					stateM = s_read_memory;
				end if
			when s_read_memory =>
				-- read from memory !! we're missing a logic vector input for that, right ?
				if Out_Avalon_Ready = '1' then
					if 
					
				end if
				
			when others => null
		end case;
		if Out_Avalon_Ready = '1' then
			Out_Avalon_Data <= signal_holder;
		end if;
	end if;
end process;

end master