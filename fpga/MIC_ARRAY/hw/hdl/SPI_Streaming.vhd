-- Juan Azcarreta Master Thesis
-- SPI Streaming Module
-- 17th June 2016
-- EPFL: LCAV & LAP collaboration

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_Streaming is
    generic(
        MICS_N  : integer := 8;         -- Mics per array number
        ARRAY_N : integer := 6          -- Arrays number
    );
    port(
        -- Global signals
        clk             : in  std_logic;
        reset_n         : in  std_logic;
        -- DMA Control signals
        Streaming_Data  : in  std_logic_vector(31 downto 0);
        Streaming_Valid : in  std_logic;
        Streaming_Ready : out std_logic;

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
end SPI_Streaming;

architecture streaming of SPI_Streaming is
    -- StateM machine
    type state_type is (s_wait, s_transmit1, s_transmit2, s_transmit3);
    signal StateM : state_type;

    signal wrempty : std_logic;
    signal wrfull  : std_logic;
    signal wrusedw : std_logic_vector(5 downto 0);
    signal q       : std_logic_vector(15 downto 0);
    signal channel : integer range 0 to 47;
    signal rdreq   : std_logic;

    signal Source_sop   : std_logic;
    signal Source_eop   : std_logic;
    signal Source_Valid : std_logic;
    signal Source_Ready : std_logic;
    signal Source_Data  : std_logic_vector(21 downto 0);

begin
    -- Create FIFO component
    FIFO_Streaming_inst : entity work.FIFO_Streaming
    port map(
        data    => Streaming_Data,
        rdclk   => clk,
        rdreq   => rdreq,
        wrclk   => clk,
        wrreq   => Streaming_Valid,
        q       => q,
        wrempty => wrempty,
        wrfull  => wrfull,
        wrusedw => wrusedw
    );

    -- processes
    streaming : process(clk, reset_n)
    begin
        if reset_n = '0' then
            channel      <= 0;
            Source_eop   <= '0';
            Source_sop   <= '0';
            Source_Data  <= (others => '0');
            Source_Valid <= '0';

        elsif rising_edge(clk) then
            case StateM is
                when s_wait =>
                    Source_eop <= '0';
                    if to_integer(unsigned(wrusedw)) >= 24 and Source_Ready = '1' then
                        StateM <= s_transmit1;

                        rdreq <= '1';
                    end if;
                when s_transmit1 =>
                    StateM <= s_transmit2;

                when s_transmit2 =>
                    -- Transmit first packet

                    Source_Valid <= '1';
                    Source_sop   <= '1';
                    -- Transmit first packet and assert Source_sop as handshake with the FIR filter
                    Source_Data  <= q & std_logic_vector(to_unsigned(channel, 6));
                    StateM       <= s_transmit3;

                when s_transmit3 =>
                    Source_sop <= '0';
                    if Source_Ready = '1' then
                        -- Indicate valid data
                        if channel < ((MICS_N * ARRAY_N) - 2) then
                            rdreq        <= '1';
                            channel      <= channel + 1;
                            -- FIR filters IP ask to join the output signal and the # of channel in the same array
                            Source_Data  <= q & std_logic_vector(to_unsigned(channel, 6));
                            rdreq        <= '1';
                            Source_Valid <= '1';

                        elsif channel = ((MICS_N * ARRAY_N) - 2) then
                            -- Transmit last packet
                            -- Along with the las packet we need to asert Source_eop soginal
                            Source_Data  <= q & std_logic_vector(to_unsigned(channel, 6));
                            -- Transmission finish! We tell by asserting Source_eop
                            Source_eop   <= '1';
                            channel      <= channel + 1;
                            Source_Valid <= '1';

                        else
                            Source_eop   <= '0';
                            channel      <= 0;
                            Source_Valid <= '0';
                            rdreq        <= '0';
                            StateM       <= s_wait;
                        end if;
                    else
                        Source_Valid <= '0';
                        rdreq        <= '0';

                    end if;
                when others => null;

            end case;
        end if;
    end process streaming;

    -- Transmit streaming interface signals
    Streaming_Ready <= not (wrfull);  -- When FIFOs are not full the system is ready

    Source_sop_Left  <= Source_sop;
    Source_sop_Right <= Source_sop;

    Source_eop_Right <= Source_eop;
    Source_eop_Left  <= Source_eop;

    Source_Data_Left  <= Source_Data;
    Source_Data_Right <= Source_Data;

    Source_Valid_Left  <= Source_Valid;
    Source_Valid_Right <= Source_Valid;

    Source_Ready <= Source_Ready_Left and Source_Ready_Right;  -- Both right and left sources need to be ready at the send time to synchronize transmissions


end streaming;
