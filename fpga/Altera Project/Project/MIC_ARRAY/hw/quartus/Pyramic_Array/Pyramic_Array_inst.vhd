	component Pyramic_Array is
		port (
			audio_0_external_interface_ADCDAT                : in    std_logic                     := 'X';             -- ADCDAT
			audio_0_external_interface_ADCLRCK               : in    std_logic                     := 'X';             -- ADCLRCK
			audio_0_external_interface_BCLK                  : in    std_logic                     := 'X';             -- BCLK
			audio_0_external_interface_DACDAT                : out   std_logic;                                        -- DACDAT
			audio_0_external_interface_DACLRCK               : in    std_logic                     := 'X';             -- DACLRCK
			audio_and_video_config_0_external_interface_SDAT : inout std_logic                     := 'X';             -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic;                                        -- SCLK
			clk_clk                                          : in    std_logic                     := 'X';             -- clk
			hps_0_ddr_mem_a                                  : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_0_ddr_mem_ba                                 : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_0_ddr_mem_ck                                 : out   std_logic;                                        -- mem_ck
			hps_0_ddr_mem_ck_n                               : out   std_logic;                                        -- mem_ck_n
			hps_0_ddr_mem_cke                                : out   std_logic;                                        -- mem_cke
			hps_0_ddr_mem_cs_n                               : out   std_logic;                                        -- mem_cs_n
			hps_0_ddr_mem_ras_n                              : out   std_logic;                                        -- mem_ras_n
			hps_0_ddr_mem_cas_n                              : out   std_logic;                                        -- mem_cas_n
			hps_0_ddr_mem_we_n                               : out   std_logic;                                        -- mem_we_n
			hps_0_ddr_mem_reset_n                            : out   std_logic;                                        -- mem_reset_n
			hps_0_ddr_mem_dq                                 : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_0_ddr_mem_dqs                                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_0_ddr_mem_dqs_n                              : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_0_ddr_mem_odt                                : out   std_logic;                                        -- mem_odt
			hps_0_ddr_mem_dm                                 : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_0_ddr_oct_rzqin                              : in    std_logic                     := 'X';             -- oct_rzqin
			hps_0_io_hps_io_emac1_inst_TX_CLK                : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_io_hps_io_emac1_inst_TXD0                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_io_hps_io_emac1_inst_TXD1                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_io_hps_io_emac1_inst_TXD2                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_io_hps_io_emac1_inst_TXD3                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_io_hps_io_emac1_inst_RXD0                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_io_hps_io_emac1_inst_MDIO                  : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_io_hps_io_emac1_inst_MDC                   : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_io_hps_io_emac1_inst_RX_CTL                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_io_hps_io_emac1_inst_TX_CTL                : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_io_hps_io_emac1_inst_RX_CLK                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_io_hps_io_emac1_inst_RXD1                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_io_hps_io_emac1_inst_RXD2                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_io_hps_io_emac1_inst_RXD3                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_io_hps_io_sdio_inst_CMD                    : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK                    : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_io_hps_io_uart0_inst_RX                    : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_io_hps_io_uart0_inst_TX                    : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_io_hps_io_gpio_inst_GPIO35                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_io_hps_io_gpio_inst_GPIO53                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_io_hps_io_gpio_inst_GPIO54                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			output_switcher_0_source_select_new_signal       : in    std_logic                     := 'X';             -- new_signal
			output_switcher_0_source_select_new_signal_1     : in    std_logic                     := 'X';             -- new_signal_1
			output_switcher_1_source_select_new_signal       : in    std_logic                     := 'X';             -- new_signal
			output_switcher_1_source_select_new_signal_1     : in    std_logic                     := 'X';             -- new_signal_1
			pll_0_sdram_clk                                  : out   std_logic;                                        -- clk
			reset_reset_n                                    : in    std_logic                     := 'X';             -- reset_n
			spi_system_0_spi_interface_convst0               : out   std_logic;                                        -- convst0
			spi_system_0_spi_interface_convst1               : out   std_logic;                                        -- convst1
			spi_system_0_spi_interface_convst2               : out   std_logic;                                        -- convst2
			spi_system_0_spi_interface_cs0_n                 : out   std_logic;                                        -- cs0_n
			spi_system_0_spi_interface_cs1_n                 : out   std_logic;                                        -- cs1_n
			spi_system_0_spi_interface_cs2_n                 : out   std_logic;                                        -- cs2_n
			spi_system_0_spi_interface_miso_00               : in    std_logic                     := 'X';             -- miso_00
			spi_system_0_spi_interface_miso_01               : in    std_logic                     := 'X';             -- miso_01
			spi_system_0_spi_interface_miso_10               : in    std_logic                     := 'X';             -- miso_10
			spi_system_0_spi_interface_miso_11               : in    std_logic                     := 'X';             -- miso_11
			spi_system_0_spi_interface_miso_20               : in    std_logic                     := 'X';             -- miso_20
			spi_system_0_spi_interface_miso_21               : in    std_logic                     := 'X';             -- miso_21
			spi_system_0_spi_interface_reset0                : out   std_logic;                                        -- reset0
			spi_system_0_spi_interface_reset1                : out   std_logic;                                        -- reset1
			spi_system_0_spi_interface_reset2                : out   std_logic;                                        -- reset2
			spi_system_0_spi_interface_sclk0                 : out   std_logic;                                        -- sclk0
			spi_system_0_spi_interface_sclk1                 : out   std_logic;                                        -- sclk1
			spi_system_0_spi_interface_sclk2                 : out   std_logic;                                        -- sclk2
			spi_system_0_spi_interface_busy_or0              : in    std_logic                     := 'X';             -- busy_or0
			spi_system_0_spi_interface_busy_or1              : in    std_logic                     := 'X';             -- busy_or1
			spi_system_0_spi_interface_busy_or2              : in    std_logic                     := 'X'              -- busy_or2
		);
	end component Pyramic_Array;

	u0 : component Pyramic_Array
		port map (
			audio_0_external_interface_ADCDAT                => CONNECTED_TO_audio_0_external_interface_ADCDAT,                --                  audio_0_external_interface.ADCDAT
			audio_0_external_interface_ADCLRCK               => CONNECTED_TO_audio_0_external_interface_ADCLRCK,               --                                            .ADCLRCK
			audio_0_external_interface_BCLK                  => CONNECTED_TO_audio_0_external_interface_BCLK,                  --                                            .BCLK
			audio_0_external_interface_DACDAT                => CONNECTED_TO_audio_0_external_interface_DACDAT,                --                                            .DACDAT
			audio_0_external_interface_DACLRCK               => CONNECTED_TO_audio_0_external_interface_DACLRCK,               --                                            .DACLRCK
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK, --                                            .SCLK
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			hps_0_ddr_mem_a                                  => CONNECTED_TO_hps_0_ddr_mem_a,                                  --                                   hps_0_ddr.mem_a
			hps_0_ddr_mem_ba                                 => CONNECTED_TO_hps_0_ddr_mem_ba,                                 --                                            .mem_ba
			hps_0_ddr_mem_ck                                 => CONNECTED_TO_hps_0_ddr_mem_ck,                                 --                                            .mem_ck
			hps_0_ddr_mem_ck_n                               => CONNECTED_TO_hps_0_ddr_mem_ck_n,                               --                                            .mem_ck_n
			hps_0_ddr_mem_cke                                => CONNECTED_TO_hps_0_ddr_mem_cke,                                --                                            .mem_cke
			hps_0_ddr_mem_cs_n                               => CONNECTED_TO_hps_0_ddr_mem_cs_n,                               --                                            .mem_cs_n
			hps_0_ddr_mem_ras_n                              => CONNECTED_TO_hps_0_ddr_mem_ras_n,                              --                                            .mem_ras_n
			hps_0_ddr_mem_cas_n                              => CONNECTED_TO_hps_0_ddr_mem_cas_n,                              --                                            .mem_cas_n
			hps_0_ddr_mem_we_n                               => CONNECTED_TO_hps_0_ddr_mem_we_n,                               --                                            .mem_we_n
			hps_0_ddr_mem_reset_n                            => CONNECTED_TO_hps_0_ddr_mem_reset_n,                            --                                            .mem_reset_n
			hps_0_ddr_mem_dq                                 => CONNECTED_TO_hps_0_ddr_mem_dq,                                 --                                            .mem_dq
			hps_0_ddr_mem_dqs                                => CONNECTED_TO_hps_0_ddr_mem_dqs,                                --                                            .mem_dqs
			hps_0_ddr_mem_dqs_n                              => CONNECTED_TO_hps_0_ddr_mem_dqs_n,                              --                                            .mem_dqs_n
			hps_0_ddr_mem_odt                                => CONNECTED_TO_hps_0_ddr_mem_odt,                                --                                            .mem_odt
			hps_0_ddr_mem_dm                                 => CONNECTED_TO_hps_0_ddr_mem_dm,                                 --                                            .mem_dm
			hps_0_ddr_oct_rzqin                              => CONNECTED_TO_hps_0_ddr_oct_rzqin,                              --                                            .oct_rzqin
			hps_0_io_hps_io_emac1_inst_TX_CLK                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TX_CLK,                --                                    hps_0_io.hps_io_emac1_inst_TX_CLK
			hps_0_io_hps_io_emac1_inst_TXD0                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD0,                  --                                            .hps_io_emac1_inst_TXD0
			hps_0_io_hps_io_emac1_inst_TXD1                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD1,                  --                                            .hps_io_emac1_inst_TXD1
			hps_0_io_hps_io_emac1_inst_TXD2                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD2,                  --                                            .hps_io_emac1_inst_TXD2
			hps_0_io_hps_io_emac1_inst_TXD3                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD3,                  --                                            .hps_io_emac1_inst_TXD3
			hps_0_io_hps_io_emac1_inst_RXD0                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD0,                  --                                            .hps_io_emac1_inst_RXD0
			hps_0_io_hps_io_emac1_inst_MDIO                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_MDIO,                  --                                            .hps_io_emac1_inst_MDIO
			hps_0_io_hps_io_emac1_inst_MDC                   => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_MDC,                   --                                            .hps_io_emac1_inst_MDC
			hps_0_io_hps_io_emac1_inst_RX_CTL                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RX_CTL,                --                                            .hps_io_emac1_inst_RX_CTL
			hps_0_io_hps_io_emac1_inst_TX_CTL                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TX_CTL,                --                                            .hps_io_emac1_inst_TX_CTL
			hps_0_io_hps_io_emac1_inst_RX_CLK                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RX_CLK,                --                                            .hps_io_emac1_inst_RX_CLK
			hps_0_io_hps_io_emac1_inst_RXD1                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD1,                  --                                            .hps_io_emac1_inst_RXD1
			hps_0_io_hps_io_emac1_inst_RXD2                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD2,                  --                                            .hps_io_emac1_inst_RXD2
			hps_0_io_hps_io_emac1_inst_RXD3                  => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD3,                  --                                            .hps_io_emac1_inst_RXD3
			hps_0_io_hps_io_sdio_inst_CMD                    => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_CMD,                    --                                            .hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0                     => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D0,                     --                                            .hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1                     => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D1,                     --                                            .hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK                    => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_CLK,                    --                                            .hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2                     => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D2,                     --                                            .hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3                     => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D3,                     --                                            .hps_io_sdio_inst_D3
			hps_0_io_hps_io_uart0_inst_RX                    => CONNECTED_TO_hps_0_io_hps_io_uart0_inst_RX,                    --                                            .hps_io_uart0_inst_RX
			hps_0_io_hps_io_uart0_inst_TX                    => CONNECTED_TO_hps_0_io_hps_io_uart0_inst_TX,                    --                                            .hps_io_uart0_inst_TX
			hps_0_io_hps_io_gpio_inst_GPIO35                 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO35,                 --                                            .hps_io_gpio_inst_GPIO35
			hps_0_io_hps_io_gpio_inst_GPIO53                 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO53,                 --                                            .hps_io_gpio_inst_GPIO53
			hps_0_io_hps_io_gpio_inst_GPIO54                 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO54,                 --                                            .hps_io_gpio_inst_GPIO54
			output_switcher_0_source_select_new_signal       => CONNECTED_TO_output_switcher_0_source_select_new_signal,       --             output_switcher_0_source_select.new_signal
			output_switcher_0_source_select_new_signal_1     => CONNECTED_TO_output_switcher_0_source_select_new_signal_1,     --                                            .new_signal_1
			output_switcher_1_source_select_new_signal       => CONNECTED_TO_output_switcher_1_source_select_new_signal,       --             output_switcher_1_source_select.new_signal
			output_switcher_1_source_select_new_signal_1     => CONNECTED_TO_output_switcher_1_source_select_new_signal_1,     --                                            .new_signal_1
			pll_0_sdram_clk                                  => CONNECTED_TO_pll_0_sdram_clk,                                  --                                 pll_0_sdram.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			spi_system_0_spi_interface_convst0               => CONNECTED_TO_spi_system_0_spi_interface_convst0,               --                  spi_system_0_spi_interface.convst0
			spi_system_0_spi_interface_convst1               => CONNECTED_TO_spi_system_0_spi_interface_convst1,               --                                            .convst1
			spi_system_0_spi_interface_convst2               => CONNECTED_TO_spi_system_0_spi_interface_convst2,               --                                            .convst2
			spi_system_0_spi_interface_cs0_n                 => CONNECTED_TO_spi_system_0_spi_interface_cs0_n,                 --                                            .cs0_n
			spi_system_0_spi_interface_cs1_n                 => CONNECTED_TO_spi_system_0_spi_interface_cs1_n,                 --                                            .cs1_n
			spi_system_0_spi_interface_cs2_n                 => CONNECTED_TO_spi_system_0_spi_interface_cs2_n,                 --                                            .cs2_n
			spi_system_0_spi_interface_miso_00               => CONNECTED_TO_spi_system_0_spi_interface_miso_00,               --                                            .miso_00
			spi_system_0_spi_interface_miso_01               => CONNECTED_TO_spi_system_0_spi_interface_miso_01,               --                                            .miso_01
			spi_system_0_spi_interface_miso_10               => CONNECTED_TO_spi_system_0_spi_interface_miso_10,               --                                            .miso_10
			spi_system_0_spi_interface_miso_11               => CONNECTED_TO_spi_system_0_spi_interface_miso_11,               --                                            .miso_11
			spi_system_0_spi_interface_miso_20               => CONNECTED_TO_spi_system_0_spi_interface_miso_20,               --                                            .miso_20
			spi_system_0_spi_interface_miso_21               => CONNECTED_TO_spi_system_0_spi_interface_miso_21,               --                                            .miso_21
			spi_system_0_spi_interface_reset0                => CONNECTED_TO_spi_system_0_spi_interface_reset0,                --                                            .reset0
			spi_system_0_spi_interface_reset1                => CONNECTED_TO_spi_system_0_spi_interface_reset1,                --                                            .reset1
			spi_system_0_spi_interface_reset2                => CONNECTED_TO_spi_system_0_spi_interface_reset2,                --                                            .reset2
			spi_system_0_spi_interface_sclk0                 => CONNECTED_TO_spi_system_0_spi_interface_sclk0,                 --                                            .sclk0
			spi_system_0_spi_interface_sclk1                 => CONNECTED_TO_spi_system_0_spi_interface_sclk1,                 --                                            .sclk1
			spi_system_0_spi_interface_sclk2                 => CONNECTED_TO_spi_system_0_spi_interface_sclk2,                 --                                            .sclk2
			spi_system_0_spi_interface_busy_or0              => CONNECTED_TO_spi_system_0_spi_interface_busy_or0,              --                                            .busy_or0
			spi_system_0_spi_interface_busy_or1              => CONNECTED_TO_spi_system_0_spi_interface_busy_or1,              --                                            .busy_or1
			spi_system_0_spi_interface_busy_or2              => CONNECTED_TO_spi_system_0_spi_interface_busy_or2               --                                            .busy_or2
		);

