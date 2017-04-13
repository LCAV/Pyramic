-- Juan Azcarreta Master Thesis
-- SPI DMA Module VHDL Description
-- 17th February 2016
-- EPFL: LCAV & LAP collaboration
-- Modified-By: C. Ferry
-- Changed the stop condition : CntBurst shall be equal to 1 (4 - 3 - 2 - 1) otherwise
-- it does 4 - 3 - 2 - 1 - 0 (and the 3 was in reality skipped so we missed a sample)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SPI_DMA is
    generic(
        ARRAY_N : integer := 6          -- Arrays number
    );
    port(
        -- Global signals
        clk            : in  std_logic;
        reset_n        : in  std_logic;
        -- DMA Control signals
        AM_Addr        : out std_logic_vector(31 downto 0);
        AM_ByteEnable  : out std_logic_vector(3 downto 0);
        AM_BurstCount  : out std_logic_vector(2 downto 0);
        AM_Write       : out std_logic;
        AM_DataWrite   : out std_logic_vector(31 downto 0);
        AM_WaitRequest : in  std_logic;
        -- SPI interface signals
        Data           : in  std_logic_vector(31 downto 0);
        Data_Available : in  std_logic;
        sel            : out std_logic_vector(2 downto 0);
        DataRd         : out std_logic;
        array_vector   : out std_logic_vector(2 downto 0);

        -- Slave signals
        RegAddStart     : in  std_logic_vector(31 downto 0);
        RegLgt          : in  std_logic_vector(31 downto 0);
        Start           : in  std_logic;
        Stop            : out std_logic;
        Buffer1         : out std_logic;
        Buffer2         : out std_logic;
        -- Avalon ST interface
        Streaming_Ready : in  std_logic;
        Streaming_Valid : out std_logic;
        Streaming_Data  : out std_logic_vector(31 downto 0)
    );
end SPI_DMA;

architecture master of SPI_DMA is
    -- StateM machine
    type state_type is (s_idle, s_waitdata, s_writedata, s_loaddata, s_waitdata2, s_waitdata3, s_waitdata4);
    signal StateM : state_type;

    -- counters
    signal CntAdd       : unsigned(31 downto 0);
    signal CntLgt       : unsigned(31 downto 0);
    signal CntBurst     : unsigned(2 downto 0);
    signal Stop_sig     : std_logic;
    signal array_number : unsigned(2 downto 0);

    -- constants
    constant BURST_COUNT : unsigned := "100";
begin
    -- processes

    dma : process(Clk, reset_n)
    begin
        -- reset everything
        if reset_n = '0' then
            StateM          <= s_idle;
            DataRd          <= '0';
            AM_Write        <= '0';
            AM_ByteEnable   <= (others => '0');
            AM_Addr         <= (others => '0');
            AM_BurstCount   <= (others => '0');
            CntLgt          <= (others => '0');
            CntAdd          <= (others => '0');
            CntBurst        <= (others => '0');
            Stop_sig        <= '0';
            array_number    <= (others => '0');
            Buffer1         <= '0';
            Streaming_Valid <= '0';

        elsif rising_edge(Clk) then
            case StateM is
                when s_idle =>          -- Wait command Start from Slave
                    -- Reset everything at the beginning
                    DataRd          <= '0';
                    Stop_sig        <= '0';
                    AM_Write        <= '0';
                    AM_ByteEnable   <= (others => '0');
                    AM_Addr         <= (others => '0');
                    AM_BurstCount   <= (others => '0');
                    DataRd          <= '0';
                    array_number    <= (others => '0');
                    Streaming_Valid <= '0';
                    Buffer2         <= '0';
                    if Start = '1' then  -- Asserted by slave
                        -- Load from Slave
                        CntLgt  <= unsigned(RegLgt);  -- Length of data to store
                        CntAdd  <= unsigned(RegAddStart);  -- Destination address
                        StateM  <= s_waitdata;
                        Buffer1 <= '1';  -- Indicates first half of the acqusition is happening
                    else
                        Buffer1 <= '0';
                    end if;

                when s_waitdata =>
                    Streaming_Valid <= '0';
                    if Data_Available = '1' then  -- Data available equal to '1' when usedw > 2 in SPI_Controller, i.e, 2 or more conversions have been done
                        StateM <= s_waitdata2;
                        DataRd <= '1';  -- Assert flag the data in SPI_controller output registe with all the microphones samples
                    end if;

                when s_waitdata2 =>
                    Streaming_Valid <= '0';
                    DataRd          <= '0';  -- Deassert flag to load the data
                    StateM          <= s_waitdata3;
                    CntBurst        <= BURST_COUNT;

                when s_waitdata3 =>
                    -- Intermediate state
                    if AM_WaitRequest = '0' then
                        StateM <= s_waitdata4;
                    end if;

                when s_waitdata4 => StateM <= s_loaddata;

                when s_loaddata =>
                    -- Load DMA parameters to start a writing transfer: Byte Enable, Address Write and Burst Count
                    AM_Write      <= '1';
                    AM_Addr       <= std_logic_vector(CntAdd);
                    AM_ByteEnable <= "1111";
                    AM_BurstCount <= "100";  -- Burst of 4
                    if AM_WaitRequest = '0' then
                        -- Start BURST to send data to the DDR3 controller
                        StateM <= s_writedata;
                    --CntBurst <= BURST_COUNT - 1; -- CF: I removed this so that the second data will be written
                    end if;

                when s_writedata =>
                    AM_BurstCount <= "000";
                    if AM_WaitRequest = '0' then
                        -- Start Avalon ST interface
                        Streaming_Valid <= '1';
                        -- Control burst transfer
                        if CntBurst = 1 then           -- Stop burst transfer
                            AM_Write      <= '0';
                            AM_ByteEnable <= "0000";
                            -- Stop burst
                            if cntLgt > 1 then
                                -- Update length and address counter after sending eight samples
                                CntLgt <= CntLgt - 8;  -- Where 8 is equal to the number of microphones per board
                                CntAdd <= CntAdd + 16;  --Each sample occupies 2 bytes, we need to jump 16 byss each time after sending 8 smples
                                -- Transfer next 8 microphones array
                                if array_number < ARRAY_N - 1 then
                                    array_number <= array_number + 1;  -- Change array
                                    StateM       <= s_waitdata2;  -- Repeat process
                                else
                                    array_number <= (others => '0');  -- Reset boards array vector
                                    StateM       <= s_waitdata;  -- Wait for more data
                                end if;
                                -- Change buffer when half of the acquisition is done
                                if to_integer(CntLgt) < to_integer(unsigned(RegLgt)) / 2 then
                                    -- Flip bufferes
                                    Buffer2 <= '1';
                                    Buffer1 <= '0';
                                end if;
                            else
                                -- Go to idle state
                                if (Start = '0') then
                                    StateM   <= s_idle;
                                    Stop_sig <= '1';
                                else
                                    -- Otherwise (if Start no deasserted by the Slave perform continuous acquisition)
                                    CntLgt  <= unsigned(RegLgt);  -- Length of data to store
                                    CntAdd  <= unsigned(RegAddStart);  -- Destination address
                                    StateM  <= s_waitdata;
                                    Buffer1 <= '1';
                                    Buffer2 <= '0';

                                end if;
                            end if;
                        else            -- Continue burst transfer
                            CntBurst <= CntBurst - 1;
                        end if;
                    else
                        -- Interrupt Avalon ST interface
                        Streaming_Valid <= '0';
                    end if;

                when others => null;

            end case;
        end if;
    end process dma;

    -- -- Write data to memory
    AM_DataWrite                 <= Data;
    Streaming_Data(15 downto 0)  <= Data(31 downto 16);
    Streaming_Data(31 downto 16) <= Data(15 downto 0);

    -- Send signals to SPI controller
    sel          <= std_logic_vector(CntBurst);
    array_vector <= std_logic_vector(array_number);
    Stop         <= Stop_sig;

end master;
