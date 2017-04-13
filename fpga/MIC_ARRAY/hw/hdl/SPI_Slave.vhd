-- Juan Azcarreta Master Thesis
-- SPI Slave Module VHDL Description
-- 17th February 2016
-- EPFL: LCAV & LAP collaboration

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_Slave is
    port(
        -- Global signals
        Clk          : in  std_logic;
        reset_n      : in  std_logic;
        -- Signals from controller
        AS_Addr      : in  std_logic_vector(2 downto 0);
        AS_Write     : in  std_logic;
        AS_Read      : in  std_logic;
        AS_WriteData : in  std_logic_vector(31 downto 0);
        AS_ReadData  : out std_logic_vector(31 downto 0);
        -- Interface with SPI_controller and DMA
        RegAddStart  : out std_logic_vector(31 downto 0);
        RegLgt       : out std_logic_vector(31 downto 0);
        Start        : out std_logic;
        Buffer1      : in  std_logic;
        Buffer2      : in  std_logic;
        DMA_Stop     : in  std_logic
    );
end SPI_Slave;

architecture slave of SPI_Slave is
    -- signals
    signal sig_BaseAddress : std_logic_vector(31 downto 0);
    signal sig_length      : std_logic_vector(31 downto 0);
    signal sig_Start       : std_logic;

begin
    -- processes
    registers : process(Clk, reset_n)
    begin
        if reset_n = '0' then
            sig_BaseAddress <= (others => '0');
            sig_length      <= (others => '0');
            AS_ReadData     <= (others => '0');
            sig_Start       <= '0';
        elsif rising_edge(Clk) then
            --Start_n         <=  '1';          -- Default value
            -- Write in the registers
            if AS_Write = '1' then
                case AS_Addr is
                    when "000"  => sig_BaseAddress <= AS_WriteData;  -- Assign starting memory address for DMA
                    when "001"  => sig_length      <= AS_WriteData;  -- Assign total number of samples to be sent by the DMA
                    when "010"  => sig_Start       <= AS_WriteData(0);  -- When asserted the proces starts running and it never stops till it is deasserdh (Otherwise the acquisition will be continuous)
                    when others => null;
                end case;
            -- Read from the registers
            elsif AS_Read = '1' then
                AS_ReadData <= (others => '0');
                case AS_Addr is
                    when "000"  => AS_ReadData    <= sig_BaseAddress;
                    when "001"  => AS_ReadData    <= sig_length;
                    when "010"  => AS_ReadData(0) <= sig_Start;  -- When asserted the proces starts running and it never stops till it is deasserted
                    when "011"  => AS_ReadData(0) <= Buffer1;  -- Should be high during first  half period of the acquisition
                    when "100"  => AS_ReadData(0) <= Buffer2;  -- Should be high during second half period of the acquisition
                    when "101"  => AS_ReadData(0) <= DMA_Stop;  -- indicates the DMA asserts the stop signal
                    when others => null;
                end case;
            end if;
        end if;
    end process registers;

    -- Set outputs
    RegAddStart <= sig_BaseAddress;
    RegLgt      <= sig_length;
    Start       <= sig_Start;
end slave;
