-- Juan Azcarreta Master Thesis
-- SPI Complete Module
-- 20th February 2016
-- EPFL: LCAV & LAP collaboration

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
library altera_mf;
use altera_mf.all;

entity SPI_System is
    port(
        -- Global signals
        clk     : in std_logic;
        reset_n : in std_logic;

        -- INTERFACE with DMA
        AM_Addr        : out std_logic_vector(31 downto 0);
        AM_BurstCount  : out std_logic_vector(2 downto 0);
        AM_Write       : out std_logic;
        AM_DataWrite   : out std_logic_vector(31 downto 0);
        AM_ByteEnable  : out std_logic_vector(3 downto 0);
        AM_WaitRequest : in  std_logic;

        -- INTERFACE with ADC
        Reset0       : out std_logic;
        Reset1       : out std_logic;
        Reset2       : out std_logic;
        busy_OR0     : in  std_logic;
        busy_OR1     : in  std_logic;
        busy_OR2     : in  std_logic;
        MISO_00      : in  std_logic;
        MISO_01      : in  std_logic;
        MISO_10      : in  std_logic;
        MISO_11      : in  std_logic;
        MISO_20      : in  std_logic;
        MISO_21      : in  std_logic;
        CONVST0      : out std_logic;
        CONVST1      : out std_logic;
        CONVST2      : out std_logic;
        CS0_n        : out std_logic;
        CS1_n        : out std_logic;
        CS2_n        : out std_logic;
        SCLK0        : out std_logic;   -- SCLK will be 12.5 MHz
        SCLK1        : out std_logic;  -- SCLK will be 12.5 MHz, enough to respect timings
        SCLK2        : out std_logic;  -- SCLK will be 12.5 MHz, enough to respect timings
        -- INTERFACE with Slave Registers
        AS_Addr      : in  std_logic_vector(2 downto 0);
        AS_Write     : in  std_logic;
        AS_Read      : in  std_logic;
        AS_ReadData  : out std_logic_vector(31 downto 0);
        AS_WriteData : in  std_logic_vector(31 downto 0);

        -- Avalon ST source interface Left
        Source_Data_Left  : out std_logic_vector(21 downto 0);
        Source_sop_Left   : out std_logic;
        Source_eop_Left   : out std_logic;
        Source_Valid_Left : out std_logic;
        Source_Ready_Left : in  std_logic;

        -- Avalon ST source interface Right
        Source_Data_Right  : out std_logic_vector(21 downto 0);
        Source_sop_Right   : out std_logic;
        Source_eop_Right   : out std_logic;
        Source_Valid_Right : out std_logic;
        Source_Ready_Right : in  std_logic
    );
end SPI_System;

architecture project of SPI_System is
    signal Data_Available, Buffer1, Buffer2, Circular : std_logic;
    signal DataRd, Start, Stop                        : std_logic;
    signal Data, RegAddStart, RegLgt                  : std_logic_vector(31 downto 0);
    signal sel                                        : std_logic_vector(2 downto 0);
    signal array_vector                               : std_logic_vector(2 downto 0);
    signal CS_n                                       : std_logic;
    signal SCLK                                       : std_logic;
    signal reset                                      : std_logic;
    signal busy                                       : std_logic;
    signal Streaming_Valid, Streaming_Ready           : std_logic;
    signal Streaming_Data                             : std_logic_vector(31 downto 0);

begin
    Controller : entity work.SPI_Controller
    port map(
        clk      => clk,
        reset_n  => reset_n,
        -- Interaction with ADC Module
        busy_OR0 => busy_OR0,
        busy_OR1 => busy_OR1,
        busy_OR2 => busy_OR2,
        MISO_00  => MISO_00,
        MISO_01  => MISO_01,
        MISO_10  => MISO_10,
        MISO_11  => MISO_11,
        MISO_20  => MISO_20,
        MISO_21  => MISO_21,
        CONVST0  => CONVST0,
        CONVST1  => CONVST1,
        CONVST2  => CONVST2,

        -- Interaction with DMA
        CS_n           => CS_n,
        SCLK           => SCLK,
        -- Interaction with Slave Registers
        reset          => reset,
        Start          => Start,
        -- Interface with DMA
        Data           => Data,
        DataRd         => DataRd,
        sel            => sel,
        array_vector   => array_vector,
        Data_Available => Data_Available,
        Stop           => Stop
    );

    DMA : entity work.SPI_DMA
    port map(
        clk             => clk,
        reset_n         => reset_n,
        AM_Addr         => AM_Addr,
        AM_ByteEnable   => AM_ByteEnable,
        AM_BurstCount   => AM_BurstCount,
        AM_Write        => AM_Write,
        AM_DataWrite    => AM_DataWrite,
        AM_WaitRequest  => AM_WaitRequest,
        Data            => Data,
        Data_Available  => Data_Available,
        DataRd          => DataRd,
        sel             => sel,
        array_vector    => array_vector,
        RegAddStart     => RegAddStart,
        RegLgt          => RegLgt,
        Start           => Start,
        Stop            => Stop,
        Buffer1         => Buffer1,
        Buffer2         => Buffer2,
        Streaming_Data  => Streaming_Data,
        Streaming_Valid => Streaming_Valid,
        Streaming_Ready => Streaming_Ready
    );

    Slave : entity work.SPI_Slave
    port map(
        clk          => clk,
        reset_n      => reset_n,
        AS_Addr      => AS_Addr,
        AS_Write     => AS_Write,
        AS_Read      => AS_Read,
        AS_WriteData => AS_WriteData,
        AS_ReadData  => AS_ReadData,
        Start        => Start,
        RegAddStart  => RegAddStart,
        RegLgt       => RegLgt,
        Buffer1      => Buffer1,
        Buffer2      => Buffer2,
        DMA_Stop     => Stop
    );

    Streaming : entity work.SPI_Streaming
    port map(
        -- Global signals
        clk             => clk,
        reset_n         => reset_n,
        -- DMA Control signals
        Streaming_Data  => Streaming_Data,
        Streaming_Valid => Streaming_Valid,
        Streaming_Ready => Streaming_Ready,

        -- Avalon ST source interface
        Source_Data_Left  => Source_Data_Left,
        Source_sop_Left   => Source_sop_Left,
        Source_eop_Left   => Source_eop_Left,
        Source_Valid_Left => Source_Valid_Left,
        Source_Ready_Left => Source_Ready_Left,

        -- Avalon ST source interface
        Source_Data_Right  => Source_Data_Right,
        Source_sop_Right   => Source_sop_Right,
        Source_eop_Right   => Source_eop_Right,
        Source_Valid_Right => Source_Valid_Right,
        Source_Ready_Right => Source_Ready_Right
    );

    -- SCLK
    SCLK0  <= SCLK;
    SCLK1  <= SCLK;
    SCLK2  <= SCLK;
    -- CS
    CS0_n  <= CS_n;
    CS1_n  <= CS_n;
    CS2_n  <= CS_n;
    -- Reset
    Reset0 <= reset;
    Reset1 <= reset;
    Reset2 <= reset;

end architecture project;
