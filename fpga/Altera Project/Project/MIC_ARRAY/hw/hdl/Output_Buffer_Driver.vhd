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
	SAMPLE_WIDTH : natural := 32 -- L + R
);
port
(
-- Global signals
	clk         		  : IN std_logic;
	reset_n        	  : IN std_logic;

-- DMA : Avalon Memory Mapped Master
	DMA_Addr       	: OUT std_logic_vector (31 DOWNTO 0); -- this should be the same as in the spi dma
	DMA_ByteEnable	   : OUT std_logic_vector (3 DOWNTO 0);  -- 32 bits = 4 bytes
	DMA_Ready         : IN std_logic;
	DMA_Read          : OUT std_logic;
	DMA_Valid         : IN std_logic;
	DMA_Data          : IN std_logic_vector ((SAMPLE_WIDTH -1) DOWNTO 0);
	DMA_WaitRequest   : IN std_logic;

-- Connection to audio source : Avalon Streaming Sink
	In_Avalon_Ready   : OUT std_logic; 
	In_Avalon_Valid   : IN std_logic; 
	In_Avalon_Data    : IN std_logic_vector ((SAMPLE_WIDTH -1) DOWNTO 0);

-- Memory Management
	Use_Memory        : IN std_logic; -- Flag indicating whether to use the memory or the Streaming Sink
	Is_LeftRight      : IN std_logic; -- Left or right ?
	--Data_Length       : IN std_logic_vector (24 DOWNTO 0); -- if we set the cap to 128 MB, then 24 bits should be enough to specify the data length IN BYTES
	--Data_Valid        : IN std_logic; -- Flag indicating whether there is valid data in the buffer and we can start reading from it
	
-- Signals for Avalon Streaming Source (typically connected to the codec, but can be connected elsewhere)
-- Avalon ST source interface
	Out_Avalon_Data  : out std_logic_vector ((SAMPLE_WIDTH -1) DOWNTO 0);
	Out_Avalon_Valid : OUT std_logic;
	Out_Avalon_Ready : in  std_logic
  
);
end Output_Buffer_Driver;

architecture master of Output_Buffer_Driver is

-- finite state machine : 
type state_type is (s_idle, s_wait_avalon_in, s_read_avalon, s_init_dma_read, s_wait_memory, s_read_memory);
signal stateM: state_type;

type state_stream_type is (s_wait, s_transmit1, s_transmit2, s_transmit3);
signal StateMStream: state_type;

signal SndAddr : unsigned(31 DOWNTO 0);
signal signal_holder : std_logic_vector((SAMPLE_WIDTH - 1) DOWNTO 0);

-- We will determine more precisely these later on
constant base_read_addr : unsigned := "00001101011010010011101001000000"; --225000000; -- 900 MiB --rendre programmable 
constant sound_len : unsigned      := "00000001011111010111100001000000"; --25000000; -- 100 MiB
constant be_left : unsigned := "1100";
constant be_right : unsigned := "0011";

begin

state_machine : process (reset_n,clk)
begin
	if reset_n = '1' then 
		-- reset everything here
		DMA_Addr <= (others => '0');
		DMA_ByteEnable <= (others => '0');
		In_Avalon_Ready <= '0';
		DMA_Read <= '0';
	elsif rising_edge(clk) then	
		case stateM is 
			-- insert states here for reading data from the beamformer
			when s_idle =>
				-- choose whether we read from 
				if Use_Memory = '1' then
					stateM <= s_init_dma_read;
				else
					--stateM <= s_wait_avalon_in;
					stateM <= s_init_dma_read;
				end if;
			when s_wait_avalon_in =>
				-- let's wait for the axuiliary avalon interface to be ready...
				In_Avalon_Ready <= '1';
				if In_Avalon_Valid = '1' then
					stateM <= s_read_avalon;
				end if;
			when s_read_avalon => 
				-- we pass the data to the codec without buffering it in a first step.
				-- If samples are dropped, then we will consider buffering them up.
				if In_Avalon_Valid = '1' then
					signal_holder <= In_Avalon_Data;
				else
					-- transfer is finished ! Now we're not ready to accept data anymore.
					In_Avalon_Ready <= '0';
					stateM <= s_idle;
				end if;
			-- DMA : we read !
			when s_init_dma_read =>
				-- initialize dma transfer
				DMA_Addr <= std_logic_vector(SndAddr);
				if Is_LeftRight = '1' then
					DMA_ByteEnable <= std_logic_vector(be_left); 
				else
					DMA_ByteEnable <= std_logic_vector(be_right);
				end if;
				DMA_Read <= '1';
				stateM <= s_wait_memory;
				-- TBI
			when s_wait_memory =>
				-- wait for data to come from memory -takes two cycles according
				-- to avalon master specs p. 29
				DMA_Read <= '0'; -- prevent reading from DMA for the next cycles
				-- The read is pipelined with 2 wait cycles !! Obvisouly we can wait a bit
				-- if the codec is too slow
				DMA_Addr <= std_logic_vector(SndAddr);
				if DMA_ready = '1' then
					if DMA_WaitRequest = '0' then
						-- Data is there
						stateM <= s_read_memory;
					end if;
				end if;				
			when s_read_memory =>
				-- We only read from memory whenever DMA and the codec are ready.
				If DMA_WaitRequest = '0' then
					if DMA_Valid = '1' then -- I assert this, I think it's never set to 0
						signal_holder <= DMA_Data;
						if SndAddr < base_read_addr + sound_len then
							SndAddr <= SndAddr + 1;
						else
							SndAddr <= base_read_addr;
						end if;
						stateM <= s_idle;
					end if;
				end if;
			when others => null;
		end case;

	end if;
end process;

-- There is no FIFO ! If needed, we will add one. 
OutputAvalonMaster: process(reset_n, clk) 
begin
	if reset_n = '1' then
		Out_Avalon_Valid <= '0';
		Out_Avalon_Data <= (others => '0');
	elsif rising_edge(clk) then
		if Out_Avalon_Ready = '1' then
			Out_Avalon_Data <= signal_holder;
			Out_Avalon_Valid <= '1';
		end if;
	end if;
end process OutputAvalonMaster;

end architecture master;