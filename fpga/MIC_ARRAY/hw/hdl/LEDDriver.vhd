-- LED Ring Driver Slave interface
-- Authors: G. Bonnet, C. Ferry
-- Date: Nov. 2016 - Jan. 2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the LED ring driver. 

entity LEDDriver is

	port 
	(
		-- clock and reset
		clk : in std_logic;
		nReset : in std_logic;

		-- avalon
		Address : in std_logic_vector(5 DOWNTO 0);
		ChipSelect : in std_logic;
		
		-- write signals. In a first attempt, we can expect the whole data to be written
		Write_Enable : in std_logic;
		Write_Data : in std_logic_vector(31 DOWNTO 0);
		
		-- read...
		Read_Enable : in std_logic;
		Read_Data : out std_logic_vector(31 DOWNTO 0);
		
		-- led output
		LEDOut : inout std_logic
			
	);

end entity LEDDriver;

architecture master of LEDDriver is
	--type LEDMem is array (383 downto 0) of std_logic;
	signal LEDValues : std_logic_vector(1439 downto 0);
	signal currentBitNum : natural range 0 to 1440;
	signal waitcount : natural range 0 to 1250;
	
	type send_state is (start, send, up_0, down_0, up_1, down_1, decrease_bit, reset);
	signal status : send_state;
	
	signal flag_startsend : std_logic;
	
	-- Nominal timings for the leds : 
	-- 0 : 0.35us high + 0.8us low
	-- 1 : 0.7us high + 0.6us low
	-- reset : 50 us low

	-- Clk is 48 MHz, clock divider factor is 2 thus at 24 MHz :
	-- 1 clock cycle : 0.041 us
	-- 0 : 9 clock cycles + 20 clock cycles = 0.375 + 0.83us = 1.205us
	-- 1 : 18 clock cycles + 15 clock cycles = 0.75 + 0.625us = 1.375us
	-- 50 us = 1200 clock cycles

	constant cycles1up : natural := 18;
	constant cycles1dn : natural := 15;
	constant cycles0up : natural := 9;
	constant cycles0dn : natural := 20;
	constant cyclesRdn : natural := 1200;
	
	
	-- feedback output...
	signal busy : std_logic;
	
	-- clock divider
	signal count : natural range 0 to 1; -- factor is amplitude of this range
	signal enable_out : std_logic;

	
begin

	-- Transmit the RGB values to the LED board, one by one
	-- One LED consumes 24 bits of data, then passes all the remaining bits
	-- to the following ones.
	transmit : process(clk, nReset, enable_out, flag_startsend)
	begin
		if nReset = '0' then
			currentBitNum <= 1439;
			waitcount <= 0;
			status <= reset;
			LEDOut <= '0';
		-- this is the critical part for the choice of the frequency
		elsif rising_edge(clk) then
			if enable_out = '1' then
				case status is
					when start =>
						if flag_startsend = '1' then
							status <= send;
						end if;
					when send =>
						waitcount <= 0;
						if currentBitNum = 1440 then
							status <= reset;
							currentBitNum <= 1439;
						elsif LEDValues(currentBitNum) = '0' then -- we send a 0
							status <= up_0; --0 high
						else
							status <= up_1; --1 high
						end if;
					
					when up_0 =>
						LEDOut <= '1';
						waitcount <= waitcount + 1;
						if waitcount = cycles0up then
							status <= down_0;
							waitcount <= 0;
						end if;
					
					when down_0 =>
						LEDOut <= '0';
						waitcount <= waitcount + 1;
						if waitcount = cycles0dn then
							status <= decrease_bit;
							waitcount <= 0;
						end if;
					
					when up_1 =>
						LEDOut <= '1';
						waitcount <= waitcount + 1;
						if waitcount = cycles1up then
							status <= down_1;
							waitcount <= 0;
						end if;
						
					when down_1 =>
						LEDOut <= '0';
						waitcount <= waitcount + 1;
						if waitcount = cycles1dn then
							status <= decrease_bit;
							waitcount <= 0;
						end if;
					
					when decrease_bit =>
						if currentBitNum = 0 then
							currentBitNum <= 1440;
							status <= start;
						else
							currentBitNum <= currentBitNum - 1;
							status <= send;
						end if;
						
					when reset =>
						LEDOut <= '0';
						waitcount <= waitcount + 1;
						if waitcount = cyclesRdn then
							status <= send;
							waitcount <= 0;
						end if;
				end case;
			end if;
		end if;
	end process transmit;
	
	-- Receive information from the SoC and store it into our register
	receive : process(clk, nReset)
	begin
		if nReset = '0' then
			for i in 1 to 15 loop
				LEDValues(1439 DOWNTO 0) <= (others => '0');
				flag_startsend <= '1';
			end loop;
		elsif rising_edge(clk) then
			if Write_Enable = '1' then
				case Address is
					when "000000" =>
							  LEDValues(1439 DOWNTO 1416) <= Write_Data(23 downto 0);
					when "000001" =>
							  LEDValues(1415 DOWNTO 1392) <= Write_Data(23 downto 0);
					when "000010" =>
							  LEDValues(1391 DOWNTO 1368) <= Write_Data(23 downto 0);
					when "000011" =>
							  LEDValues(1367 DOWNTO 1344) <= Write_Data(23 downto 0);
					when "000100" =>
							  LEDValues(1343 DOWNTO 1320) <= Write_Data(23 downto 0);
					when "000101" =>
							  LEDValues(1319 DOWNTO 1296) <= Write_Data(23 downto 0);
					when "000110" =>
							  LEDValues(1295 DOWNTO 1272) <= Write_Data(23 downto 0);
					when "000111" =>
							  LEDValues(1271 DOWNTO 1248) <= Write_Data(23 downto 0);
					when "001000" =>
							  LEDValues(1247 DOWNTO 1224) <= Write_Data(23 downto 0);
					when "001001" =>
							  LEDValues(1223 DOWNTO 1200) <= Write_Data(23 downto 0);
					when "001010" =>
							  LEDValues(1199 DOWNTO 1176) <= Write_Data(23 downto 0);
					when "001011" =>
							  LEDValues(1175 DOWNTO 1152) <= Write_Data(23 downto 0);
					when "001100" =>
							  LEDValues(1151 DOWNTO 1128) <= Write_Data(23 downto 0);
					when "001101" =>
							  LEDValues(1127 DOWNTO 1104) <= Write_Data(23 downto 0);
					when "001110" =>
							  LEDValues(1103 DOWNTO 1080) <= Write_Data(23 downto 0);
					when "001111" =>
							  LEDValues(1079 DOWNTO 1056) <= Write_Data(23 downto 0);
					when "010000" =>
							  LEDValues(1055 DOWNTO 1032) <= Write_Data(23 downto 0);
					when "010001" =>
							  LEDValues(1031 DOWNTO 1008) <= Write_Data(23 downto 0);
					when "010010" =>
							  LEDValues(1007 DOWNTO 984) <= Write_Data(23 downto 0);
					when "010011" =>
							  LEDValues(983 DOWNTO 960) <= Write_Data(23 downto 0);
					when "010100" =>
							  LEDValues(959 DOWNTO 936) <= Write_Data(23 downto 0);
					when "010101" =>
							  LEDValues(935 DOWNTO 912) <= Write_Data(23 downto 0);
					when "010110" =>
							  LEDValues(911 DOWNTO 888) <= Write_Data(23 downto 0);
					when "010111" =>
							  LEDValues(887 DOWNTO 864) <= Write_Data(23 downto 0);
					when "011000" =>
							  LEDValues(863 DOWNTO 840) <= Write_Data(23 downto 0);
					when "011001" =>
							  LEDValues(839 DOWNTO 816) <= Write_Data(23 downto 0);
					when "011010" =>
							  LEDValues(815 DOWNTO 792) <= Write_Data(23 downto 0);
					when "011011" =>
							  LEDValues(791 DOWNTO 768) <= Write_Data(23 downto 0);
					when "011100" =>
							  LEDValues(767 DOWNTO 744) <= Write_Data(23 downto 0);
					when "011101" =>
							  LEDValues(743 DOWNTO 720) <= Write_Data(23 downto 0);
					when "011110" =>
							  LEDValues(719 DOWNTO 696) <= Write_Data(23 downto 0);
					when "011111" =>
							  LEDValues(695 DOWNTO 672) <= Write_Data(23 downto 0);
					when "100000" =>
							  LEDValues(671 DOWNTO 648) <= Write_Data(23 downto 0);
					when "100001" =>
							  LEDValues(647 DOWNTO 624) <= Write_Data(23 downto 0);
					when "100010" =>
							  LEDValues(623 DOWNTO 600) <= Write_Data(23 downto 0);
					when "100011" =>
							  LEDValues(599 DOWNTO 576) <= Write_Data(23 downto 0);
					when "100100" =>
							  LEDValues(575 DOWNTO 552) <= Write_Data(23 downto 0);
					when "100101" =>
							  LEDValues(551 DOWNTO 528) <= Write_Data(23 downto 0);
					when "100110" =>
							  LEDValues(527 DOWNTO 504) <= Write_Data(23 downto 0);
					when "100111" =>
							  LEDValues(503 DOWNTO 480) <= Write_Data(23 downto 0);
					when "101000" =>
							  LEDValues(479 DOWNTO 456) <= Write_Data(23 downto 0);
					when "101001" =>
							  LEDValues(455 DOWNTO 432) <= Write_Data(23 downto 0);
					when "101010" =>
							  LEDValues(431 DOWNTO 408) <= Write_Data(23 downto 0);
					when "101011" =>
							  LEDValues(407 DOWNTO 384) <= Write_Data(23 downto 0);
					when "101100" =>
							  LEDValues(383 DOWNTO 360) <= Write_Data(23 downto 0);
					when "101101" =>
							  LEDValues(359 DOWNTO 336) <= Write_Data(23 downto 0);
					when "101110" =>
							  LEDValues(335 DOWNTO 312) <= Write_Data(23 downto 0);
					when "101111" =>
							  LEDValues(311 DOWNTO 288) <= Write_Data(23 downto 0);
					when "110000" =>
							  LEDValues(287 DOWNTO 264) <= Write_Data(23 downto 0);
					when "110001" =>
							  LEDValues(263 DOWNTO 240) <= Write_Data(23 downto 0);
					when "110010" =>
							  LEDValues(239 DOWNTO 216) <= Write_Data(23 downto 0);
					when "110011" =>
							  LEDValues(215 DOWNTO 192) <= Write_Data(23 downto 0);
					when "110100" =>
							  LEDValues(191 DOWNTO 168) <= Write_Data(23 downto 0);
					when "110101" =>
							  LEDValues(167 DOWNTO 144) <= Write_Data(23 downto 0);
					when "110110" =>
							  LEDValues(143 DOWNTO 120) <= Write_Data(23 downto 0);
					when "110111" =>
							  LEDValues(119 DOWNTO 96) <= Write_Data(23 downto 0);
					when "111000" =>
							  LEDValues(95 DOWNTO 72) <= Write_Data(23 downto 0);
					when "111001" =>
							  LEDValues(71 DOWNTO 48) <= Write_Data(23 downto 0);
					when "111010" =>
							  LEDValues(47 DOWNTO 24) <= Write_Data(23 downto 0);
					when "111011" =>
							  LEDValues(23 DOWNTO 0) <= Write_Data(23 downto 0);
					when others =>
					
				end case;
				flag_startsend <= '1';
			elsif flag_startsend = '1' and not(status = start) then
				flag_startsend <= '0';
			end if;
		end if;
	end process receive;
	
	
	-- just give the user a little bit of feedback on what's happening there...
	feedback : process(clk)
	begin
		-- Addresses 0 to 15 are the LED values
		if rising_edge(clk) then
			if Read_Enable = '1' then
				case Address is
					when "000000" =>
							  Read_Data(23 downto 0) <= LEDValues(1439 DOWNTO 1416);
					when "000001" =>
							  Read_Data(23 downto 0) <= LEDValues(1415 DOWNTO 1392);
					when "000010" =>
							  Read_Data(23 downto 0) <= LEDValues(1391 DOWNTO 1368);
					when "000011" =>
							  Read_Data(23 downto 0) <= LEDValues(1367 DOWNTO 1344);
					when "000100" =>
							  Read_Data(23 downto 0) <= LEDValues(1343 DOWNTO 1320);
					when "000101" =>
							  Read_Data(23 downto 0) <= LEDValues(1319 DOWNTO 1296);
					when "000110" =>
							  Read_Data(23 downto 0) <= LEDValues(1295 DOWNTO 1272);
					when "000111" =>
							  Read_Data(23 downto 0) <= LEDValues(1271 DOWNTO 1248);
					when "001000" =>
							  Read_Data(23 downto 0) <= LEDValues(1247 DOWNTO 1224);
					when "001001" =>
							  Read_Data(23 downto 0) <= LEDValues(1223 DOWNTO 1200);
					when "001010" =>
							  Read_Data(23 downto 0) <= LEDValues(1199 DOWNTO 1176);
					when "001011" =>
							  Read_Data(23 downto 0) <= LEDValues(1175 DOWNTO 1152);
					when "001100" =>
							  Read_Data(23 downto 0) <= LEDValues(1151 DOWNTO 1128);
					when "001101" =>
							  Read_Data(23 downto 0) <= LEDValues(1127 DOWNTO 1104);
					when "001110" =>
							  Read_Data(23 downto 0) <= LEDValues(1103 DOWNTO 1080);
					when "001111" =>
							  Read_Data(23 downto 0) <= LEDValues(1079 DOWNTO 1056);
					when "010000" =>
							  Read_Data(23 downto 0) <= LEDValues(1055 DOWNTO 1032);
					when "010001" =>
							  Read_Data(23 downto 0) <= LEDValues(1031 DOWNTO 1008);
					when "010010" =>
							  Read_Data(23 downto 0) <= LEDValues(1007 DOWNTO 984);
					when "010011" =>
							  Read_Data(23 downto 0) <= LEDValues(983 DOWNTO 960);
					when "010100" =>
							  Read_Data(23 downto 0) <= LEDValues(959 DOWNTO 936);
					when "010101" =>
							  Read_Data(23 downto 0) <= LEDValues(935 DOWNTO 912);
					when "010110" =>
							  Read_Data(23 downto 0) <= LEDValues(839 DOWNTO 816);
					when "011010" =>
							  Read_Data(23 downto 0) <= LEDValues(815 DOWNTO 792);
					when "011011" =>
							  Read_Data(23 downto 0) <= LEDValues(791 DOWNTO 768);
					when "011100" =>
							  Read_Data(23 downto 0) <= LEDValues(767 DOWNTO 744);
					when "011101" =>
							  Read_Data(23 downto 0) <= LEDValues(743 DOWNTO 720);
					when "011110" =>
							  Read_Data(23 downto 0) <= LEDValues(719 DOWNTO 696);
					when "011111" =>
							  Read_Data(23 downto 0) <= LEDValues(695 DOWNTO 672);
					when "100000" =>
							  Read_Data(23 downto 0) <= LEDValues(671 DOWNTO 648);
					when "100001" =>
							  Read_Data(23 downto 0) <= LEDValues(647 DOWNTO 624);
					when "100010" =>
							  Read_Data(23 downto 0) <= LEDValues(623 DOWNTO 600);
					when "100011" =>
							  Read_Data(23 downto 0) <= LEDValues(599 DOWNTO 576);
					when "100100" =>
							  Read_Data(23 downto 0) <= LEDValues(575 DOWNTO 552);
					when "100101" =>
							  Read_Data(23 downto 0) <= LEDValues(551 DOWNTO 528);
					when "100110" =>
							  Read_Data(23 downto 0) <= LEDValues(527 DOWNTO 504);
					when "100111" =>
							  Read_Data(23 downto 0) <= LEDValues(503 DOWNTO 480);
					when "101000" =>
							  Read_Data(23 downto 0) <= LEDValues(479 DOWNTO 456);
					when "101001" =>
							  Read_Data(23 downto 0) <= LEDValues(455 DOWNTO 432);
					when "101010" =>
							  Read_Data(23 downto 0) <= LEDValues(431 DOWNTO 408);
					when "101011" =>
							  Read_Data(23 downto 0) <= LEDValues(407 DOWNTO 384);
					when "101100" =>
							  Read_Data(23 downto 0) <= LEDValues(383 DOWNTO 360);
					when "101101" =>
							  Read_Data(23 downto 0) <= LEDValues(359 DOWNTO 336);
					when "101110" =>
							  Read_Data(23 downto 0) <= LEDValues(335 DOWNTO 312);
					when "101111" =>
							  Read_Data(23 downto 0) <= LEDValues(311 DOWNTO 288);
					when "110000" =>
							  Read_Data(23 downto 0) <= LEDValues(287 DOWNTO 264);
					when "110001" =>
							  Read_Data(23 downto 0) <= LEDValues(263 DOWNTO 240);
					when "110010" =>
							  Read_Data(23 downto 0) <= LEDValues(239 DOWNTO 216);
					when "110011" =>
							  Read_Data(23 downto 0) <= LEDValues(215 DOWNTO 192);
					when "110100" =>
							  Read_Data(23 downto 0) <= LEDValues(191 DOWNTO 168);
					when "110101" =>
							  Read_Data(23 downto 0) <= LEDValues(167 DOWNTO 144);
					when "110110" =>
							  Read_Data(23 downto 0) <= LEDValues(143 DOWNTO 120);
					when "110111" =>
							  Read_Data(23 downto 0) <= LEDValues(119 DOWNTO 96);
					when "111000" =>
							  Read_Data(23 downto 0) <= LEDValues(95 DOWNTO 72);
					when "111001" =>
							  Read_Data(23 downto 0) <= LEDValues(71 DOWNTO 48);
					when "111010" =>
							  Read_Data(23 downto 0) <= LEDValues(47 DOWNTO 24);
					when "111011" =>
							  Read_Data(23 downto 0) <= LEDValues(23 DOWNTO 0);
					when others =>				
				end case;
				Read_Data(31 downto 24) <= (others => '0');
			end if;
		end if;
	end process feedback;
	

	clockDivide : process(clk)
	begin
		if rising_edge(clk) then
			if count = 1 then
				enable_out <= '0';
				count <= 0;
			else
				count <= count + 1;
				enable_out <= '1';
			end if;
		end if;
	end process clockDivide;

end;
