-- Juan Azcarreta Master Thesis
-- SPI Streaming Module 
-- 25th June 2016
-- EPFL: LCAV & LAP collaboration 
-- Status: Need some adjustmenst in line 86-90 (state s_beamformer)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Beamformer_Adder is

	generic
	(
		DATA_WIDTH : natural := 32
	);

	port
	(
		clk		 : in std_logic;
		reset_n	 : in std_logic;
		-- Inputs
		FIR_data   : in  std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
		FIR_Valid  : in std_logic;
		FIR_Ready  : out  std_logic;
		FIR_sop	 : in std_logic;
		FIR_eop	 : in std_logic;
		FIR_channel : in std_logic_vector(5 DOWNTO 0);
				
		-- Outputs
		Audio_data	 : out std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
		Audio_Valid  : out  std_logic;
		Audio_Ready  : in  std_logic
	);

end entity;

architecture rtl of Beamformer_Adder is
	-- Mixer state machine definition
type FIR_Acq_state is (s_waiting, s_acquire, s_beamformer);
signal FIR_Acq : FIR_Acq_state;

type	FIR_Signals is array(47 DOWNTO 0) of std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
signal FIR_Output : FIR_Signals;
signal tmp1			: signed((DATA_WIDTH - 1) + 24 DOWNTO 0);
signal tmp2			: signed((DATA_WIDTH - 1) + 24 DOWNTO 0);



begin

state_machine :	process (reset_n,clk)
begin
		if reset_n = '0' then
			FIR_Ready <= '1';
			Audio_Valid <= '0';
			tmp1 <= (others => '0');
			tmp2 <= (others => '0');
		elsif (rising_edge(clk)) then
			
			case FIR_Acq is 
				when s_waiting =>
					Audio_Valid <= '0';
					FIR_Ready <= '1';
					if FIR_sop = '1' and FIR_Valid = '1' then
						Fir_acq <= s_acquire; 
						-- Get First channel
						FIR_Output(to_integer(unsigned(FIR_channel)))((DATA_WIDTH - 1)  DOWNTO 0) <= FIR_data;
					end if;

				when s_acquire =>
					if (FIR_eop = '0') then
						-- Get the rest of channels (up to 48)
						FIR_Output(to_integer(unsigned(FIR_channel)))((DATA_WIDTH - 1)  DOWNTO 0) <= FIR_data;
					else
						-- When finish go to create beamformer
						FIR_Acq <= s_beamformer;
						FIR_Ready <= '0';
					end if;
				when s_beamformer => 
				-- Now we are reading just one of the channels but the final objective is to add all the channels and output them through hte codec 
					if Audio_Ready = '1' then
						Audio_Valid <= '1';
						-- The following line outputs the channel 2 audio data filtered:
						Audio_Data <= FIR_Output(2)((DATA_WIDTH - 1)  DOWNTO 0);	
						--for i in 0 to 23 loop
						--	tmp1 <= (tmp1 + signed(FIR_Output(i)((DATA_WIDTH - 1)  DOWNTO 0)))/24;	-- We split the channels in two because quartus does not allow division with large arrays of bits
						--end loop;
						--for i in 24 to 47 loop
						--	tmp2 <= (tmp2 + signed(FIR_Output(i)((DATA_WIDTH - 1)  DOWNTO 0)))/24;	
						--end loop;
						FIR_Ready <= '1';
						FIR_Acq <= s_waiting;
					end if;
					
				when others => null;
				
			end case;			
		end if;
	end process;

--Audio_Data <= std_logic_vector((tmp1 + tmp2)/2)((DATA_WIDTH - 1) DOWNTO 0);	
end rtl;