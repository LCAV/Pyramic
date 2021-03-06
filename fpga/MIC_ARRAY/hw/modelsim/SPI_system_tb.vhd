
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SPI_System;

entity SPI_System_tb is
end SPI_System_tb;


architecture test of SPI_System_tb is
    -- 10 MHz -> 100 ns period. Duty cycle = 1/2.
    constant CLK_PERIOD      : time := 20 ns;
    constant CLK_HIGH_PERIOD : time := 10 ns;
    constant CLK_LOW_PERIOD  : time := 10 ns;


    constant MISO_HIGH_PERIOD : time := 200 ns;
    constant MISO_LOW_PERIOD  : time := 400 ns;

    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '1';

    signal sim_finished : boolean := false;

    -- Interface with ADC
    signal busy_OR0 : std_logic            := '0';
    signal busy_OR1 : std_logic            := '0';
    signal busy_OR2 : std_logic            := '0';
    signal Reset0   : std_logic;
    signal Reset1   : std_logic;
    signal Reset2   : std_logic;
    signal CONVST0  : std_logic            := '1';
    signal CONVST2  : std_logic            := '1';
    signal CONVST1  : std_logic            := '1';
    signal CS0_n    : std_logic            := '1';
    signal CS1_n    : std_logic            := '1';
    signal CS2_n    : std_logic            := '1';
    signal SCLK0    : std_logic            := '0';  -- SCLK will be 12.5 MHz, enough to respect timings
    signal SCLK1    : std_logic            := '0';
    signal SCLK2    : std_logic            := '0';
    -- Interface with slave
    signal Start    : std_logic            := '0';
    signal Stop     : std_logic            := '0';
    -- Interface with DMA
    signal sel      : integer range 0 to 4;
    signal DataRd   : std_logic            := '0';
    signal aux      : integer range 0 to 5 := 0;

    -- DMA Control signals
    signal AM_Addr        : std_logic_vector (31 downto 0) := (others => '0');
    signal AM_ByteEnable  : std_logic_vector (3 downto 0)  := (others => '0');
    signal AM_BurstCount  : std_logic_vector (2 downto 0)  := (others => '0');
    signal AM_Write       : std_logic                      := '0';
    signal AM_DataWrite   : std_logic_vector (31 downto 0) := (others => '0');
    signal AM_WaitRequest : std_logic                      := '0';
-- SPI interface signals


-- Slave signals
    signal AcqAddress : std_logic_vector (31 downto 0) := (others => '0');
    signal AcqLength  : std_logic_vector (31 downto 0) := (others => '0');

    signal AS_Addr      : std_logic_vector (2 downto 0)  := (others => '0');
    signal AS_Write     : std_logic                      := '0';
    signal AS_Read      : std_logic                      := '0';
    signal AS_WriteData : std_logic_vector (31 downto 0) := (others => '0');
    signal AS_ReadData  : std_logic_vector (31 downto 0) := (others => '0');
    signal Debug        : std_logic;
    signal WaitRequest  : std_logic                      := '0';

    signal Source_Data_Right  : std_logic_vector(21 downto 0);
    signal Source_Data_Left   : std_logic_vector(21 downto 0);
    signal Source_Valid_Right : std_logic;
    signal Source_Valid_Left  : std_logic;
    signal Source_Ready_Right : std_logic := '1';
    signal Source_Ready_Left  : std_logic := '1';
    signal Source_sop_Left    : std_logic;
    signal Source_sop_Right   : std_logic;
    signal Source_eop_Left    : std_logic;
    signal Source_eop_Right   : std_logic;

    signal MISO_00 : std_logic;
    signal MISO_01 : std_logic;
    signal MISO_10 : std_logic;
    signal MISO_11 : std_logic;
    signal MISO_20 : std_logic;
    signal MISO_21 : std_logic;
begin
    clk_generation : process
    begin

        if not sim_finished then
            clk <= '1';
            wait for CLK_HIGH_PERIOD;
            clk <= '0';
            wait for CLK_LOW_PERIOD;
        else
            wait;
        end if;
    end process;


    MISO_generation : process
    begin

        if not sim_finished then
            MISO_00 <= '1';
            MISO_01 <= '1';
            MISO_10 <= '1';
            MISO_11 <= '1';
            MISO_20 <= '1';
            MISO_21 <= '1';


            wait for MISO_HIGH_PERIOD;

            MISO_00 <= '0';
            MISO_01 <= '0';
            MISO_10 <= '0';
            MISO_11 <= '0';
            MISO_20 <= '0';
            MISO_21 <= '0';
            wait for MISO_LOW_PERIOD;
        else
            wait;
        end if;
    end process;


    SPI_System_inst : entity SPI_System
    port map(clk     => clk,            -- to be 50 MHz
             reset_n => reset_n,
             Reset0  => Reset0,
             Reset1  => Reset1,
             Reset2  => Reset2,

             busy_OR0       => busy_OR0,
             busy_OR1       => busy_OR1,
             busy_OR2       => busy_OR2,
             MISO_00        => MISO_00,
             MISO_01        => MISO_01,
             MISO_10        => MISO_10,
             MISO_11        => MISO_11,
             MISO_20        => MISO_20,
             MISO_21        => MISO_21,
             CONVST0        => CONVST0,
             CONVST1        => CONVST1,
             CONVST2        => CONVST2,
             CS0_n          => CS0_n,
             CS1_n          => CS1_n,
             CS2_n          => CS2_n,
             SCLK0          => SCLK0,
             SCLK1          => SCLK1,
             SCLK2          => SCLK2,
             AM_Addr        => AM_Addr,
             AM_ByteEnable  => AM_ByteEnable,
             AM_BurstCount  => AM_BurstCount,
             AM_Write       => AM_Write,
             AM_DataWrite   => AM_DataWrite,
             AM_WaitRequest => AM_WaitRequest,

             -- Slave signals
             AS_Addr           => AS_Addr,
             AS_Write          => AS_Write,
             AS_Read           => AS_Read,
             AS_WriteData      => AS_WriteData,
             AS_ReadData       => AS_ReadData,
             -- Avalon ST source interface Left
             Source_Data_Left  => Source_Data_Left,
             Source_sop_Left   => Source_sop_Left,
             Source_eop_Left   => Source_eop_Left,
             Source_Valid_Left => Source_Valid_Left,
             Source_Ready_Left => Source_Ready_Left,

             -- Avalon ST source interface Right
             Source_Data_Right  => Source_Data_Right,
             Source_sop_Right   => Source_sop_Right,
             Source_eop_Right   => Source_eop_Right,
             Source_Valid_Right => Source_Valid_Right,
             Source_Ready_Right => Source_Ready_Right

    );



    busy_sig : process
    begin

        if not sim_finished then
            wait until rising_edge(CONVST0);
            wait for CLK_PERIOD;
            busy_OR0 <= '1';
            busy_OR1 <= '1';
            busy_OR2 <= '1';
            wait for 500*CLK_PERIOD;
            busy_OR0 <= '0';
            busy_OR1 <= '0';
            busy_OR2 <= '0';
        else
            wait;
        end if;
    end process;



    sim : process
        procedure perform_reset is
        begin
            wait until rising_edge(clk);
            reset_n  <= '0';
            wait for CLK_PERIOD;
            reset_n  <= '1';
            AS_Write <= '1';
            wait for 2*CLK_PERIOD;

            AS_WriteData <= x"0000FFFF";
            AS_Addr      <= "000";
            -- Write Length
            wait for 2*CLK_PERIOD;
            AS_WriteData <= x"00000600";

            AS_Addr        <= "001";
            wait for 2*CLK_PERIOD;
            AS_WriteData   <= x"00000001";
            AS_Addr        <= "010";
            wait for 2*CLK_PERIOD;
            AS_Write       <= '0';
            wait for CLK_PERIOD;
            AS_Read        <= '1';
            AS_Addr        <= "011";
            wait for 2448*CLK_PERIOD;
            AM_WaitRequest <= '1';
            wait for 4*CLK_PERIOD;
            AM_WaitRequest <= '0';



            --  wait until falling_edge(CS_n);

            --wait for 700*CLK_PERIOD;
            -- DataRd <= '1';
            -- wait for CLK_PERIOD;
            -- DataRd <='0';

            --  wait until rising_edge(Data_Available);
            -- sel <= sel-1;
            -- wait for CLK_PERIOD;
            -- sel <= sel-1;
            --  wait for CLK_PERIOD;
            -- sel <= sel-1;
            -- wait for 100 * CLK_PERIOD;
            -- DataRd <= '1';
            -- wait for CLK_PERIOD;
            -- DataRd <='0';

        end procedure perform_reset;



    begin
        perform_reset;
        wait;
    end process;
end architecture test;


