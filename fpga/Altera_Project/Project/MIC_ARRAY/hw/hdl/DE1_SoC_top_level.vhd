-- #############################################################################
-- DE1_SoC_top_level.vhd
--
-- BOARD         : DE1-SoC from Terasic
-- Author        : Sahand Kashani-Akhavan from Terasic documentation
-- Revision      : 1.2
-- Creation date : 04/02/2015
--
-- Syntax Rule : GROUP_NAME_N[bit]
--
-- GROUP  : specify a particular interface (ex: SDR_)
-- NAME   : signal name (ex: CONFIG, D, ...)
-- bit    : signal index
-- _N     : to specify an active-low signal
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;

entity DE1_SoC_top_level is
    port(
        -- ADC
        ADC_CS_n         : out   std_logic;
        ADC_DIN          : out   std_logic;
        ADC_DOUT         : in    std_logic;
        ADC_SCLK         : out   std_logic;

        -- Audio
        AUD_ADCDAT       : in    std_logic;
        AUD_ADCLRCK      : inout std_logic;
        AUD_BCLK         : inout std_logic;
        AUD_DACDAT       : out   std_logic;
        AUD_DACLRCK      : inout std_logic;
        AUD_XCK          : out   std_logic;

        -- CLOCK
        CLOCK_50         : in    std_logic;
--      CLOCK2_50        : in    std_logic;
--      CLOCK3_50        : in    std_logic;
--      CLOCK4_50        : in    std_logic;

        -- SDRAM
--      DRAM_ADDR        : out   std_logic_vector(12 downto 0);
--      DRAM_BA          : out   std_logic_vector(1 downto 0);
--      DRAM_CAS_N       : out   std_logic; 
--      DRAM_CKE         : out   std_logic;
--      DRAM_CLK         : out   std_logic;
--      DRAM_CS_N        : out   std_logic;
--      DRAM_DQ          : inout std_logic_vector(15 downto 0);
--      DRAM_LDQM        : out   std_logic;
--      DRAM_RAS_N       : out   std_logic;
--      DRAM_UDQM        : out   std_logic;
--      DRAM_WE_N        : out   std_logic;

        -- I2C for Audio and Video-In
        FPGA_I2C_SCLK    : out   std_logic;
        FPGA_I2C_SDAT    : inout std_logic;

        -- SEG7
--        HEX0_N           : out   std_logic_vector(6 downto 0);
--        HEX1_N           : out   std_logic_vector(6 downto 0);
--        HEX2_N           : out   std_logic_vector(6 downto 0);
--        HEX3_N           : out   std_logic_vector(6 downto 0);
--        HEX4_N           : out   std_logic_vector(6 downto 0);
--        HEX5_N           : out   std_logic_vector(6 downto 0);

        -- IR
--        IRDA_RXD         : in    std_logic;
--        IRDA_TXD         : out   std_logic;

        -- KEY_n
        KEY_N            : in    std_logic_vector(3 downto 0);

        -- LED
        LEDR             : out   std_logic_vector(9 downto 0);

        -- PS2
--        PS2_CLK          : inout std_logic;
--        PS2_CLK2         : inout std_logic;
--        PS2_DAT          : inout std_logic;
--        PS2_DAT2         : inout std_logic;

        -- SW
			SW               : in    std_logic_vector(9 downto 0);

        -- Video-In
--        TD_CLK27         : inout std_logic;
--        TD_DATA          : out   std_logic_vector(7 downto 0);
--        TD_HS            : out   std_logic;
--        TD_RESET_N       : out   std_logic;
--        TD_VS            : out   std_logic;

--        -- VGA
--        VGA_B            : out   std_logic_vector(7 downto 0);
--        VGA_BLANK_N      : out   std_logic;
--        VGA_CLK          : out   std_logic;
--        VGA_G            : out   std_logic_vector(7 downto 0);
--        VGA_HS           : out   std_logic;
--        VGA_R            : out   std_logic_vector(7 downto 0);
--        VGA_SYNC_N       : out   std_logic;
--        VGA_VS           : out   std_logic;

        -- GPIO_0
         GPIO_0           : inout std_logic_vector(35 downto 0);

        -- GPIO_1
--        GPIO_1           : inout std_logic_vector(35 downto 0);

        -- HPS
        HPS_CONV_USB_N   : inout std_logic;
        HPS_DDR3_ADDR    : out   std_logic_vector(14 downto 0);
        HPS_DDR3_BA      : out   std_logic_vector(2 downto 0);
        HPS_DDR3_CAS_N   : out   std_logic;
        HPS_DDR3_CK_N    : out   std_logic;
        HPS_DDR3_CK_P    : out   std_logic;
        HPS_DDR3_CKE     : out   std_logic;
        HPS_DDR3_CS_N    : out   std_logic;
        HPS_DDR3_DM      : out   std_logic_vector(3 downto 0);
        HPS_DDR3_DQ      : inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N   : inout std_logic_vector(3 downto 0);
        HPS_DDR3_DQS_P   : inout std_logic_vector(3 downto 0);
        HPS_DDR3_ODT     : out   std_logic;
        HPS_DDR3_RAS_N   : out   std_logic;
        HPS_DDR3_RESET_N : out   std_logic;
        HPS_DDR3_RZQ     : in    std_logic;
        HPS_DDR3_WE_N    : out   std_logic;
        HPS_ENET_GTX_CLK : out   std_logic;
        HPS_ENET_INT_N   : inout std_logic;
        HPS_ENET_MDC     : out   std_logic;
        HPS_ENET_MDIO    : inout std_logic;
        HPS_ENET_RX_CLK  : in    std_logic;
        HPS_ENET_RX_DATA : in    std_logic_vector(3 downto 0);
        HPS_ENET_RX_DV   : in    std_logic;
        HPS_ENET_TX_DATA : out   std_logic_vector(3 downto 0);
        HPS_ENET_TX_EN   : out   std_logic;
--        HPS_FLASH_DATA   : inout std_logic_vector(3 downto 0);
--        HPS_FLASH_DCLK   : out   std_logic;
--        HPS_FLASH_NCSO   : out   std_logic;
        HPS_GPIO         : inout std_logic_vector(1 downto 0);
        HPS_GSENSOR_INT  : inout std_logic;
        HPS_I2C_CONTROL  : inout std_logic;
        HPS_I2C1_SCLK    : inout std_logic;
        HPS_I2C1_SDAT    : inout std_logic;
        HPS_I2C2_SCLK    : inout std_logic;
        HPS_I2C2_SDAT    : inout std_logic;
        HPS_KEY_N        : inout std_logic;
        HPS_LED          : inout std_logic;
        HPS_SD_CLK       : out   std_logic;
        HPS_SD_CMD       : inout std_logic;
        HPS_SD_DATA      : inout std_logic_vector(3 downto 0);
--        HPS_SPIM_CLK     : out   std_logic;
--        HPS_SPIM_MISO    : in    std_logic;
--        HPS_SPIM_MOSI    : out   std_logic;
--        HPS_SPIM_SS      : inout std_logic;
        HPS_UART_RX      : in    std_logic;
        HPS_UART_TX      : out   std_logic
--        HPS_USB_CLKOUT   : in    std_logic;
--        HPS_USB_DATA     : inout std_logic_vector(7 downto 0);
--        HPS_USB_DIR      : in    std_logic;
--        HPS_USB_NXT      : in    std_logic;
--        HPS_USB_STP      : out   std_logic
    );
end entity DE1_SoC_top_level;

architecture rtl of DE1_SoC_top_level is

component Pyramic_Array is
port (
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
			spi_system_0_spi_interface_busy_or2              : in    std_logic                     := 'X';             -- busy_or2
			audio_pll_0_audio_clk_clk                        : out   std_logic                                         -- clk
		);
	end component Pyramic_Array;


begin

u0 : component Pyramic_Array
		port map (
			clk_clk => CLOCK_50,
			reset_reset_n => '1',				-- Reset
			hps_0_ddr_mem_a => HPS_DDR3_ADDR,
			hps_0_ddr_mem_ba => HPS_DDR3_BA,
			hps_0_ddr_mem_ck => HPS_DDR3_CK_P,
			hps_0_ddr_mem_ck_n => HPS_DDR3_CK_N,
			hps_0_ddr_mem_cke => HPS_DDR3_CKE,
			hps_0_ddr_mem_cs_n => HPS_DDR3_CS_N,
			hps_0_ddr_mem_ras_n => HPS_DDR3_RAS_N,
			hps_0_ddr_mem_cas_n => HPS_DDR3_CAS_N,
			hps_0_ddr_mem_we_n => HPS_DDR3_WE_N,
			hps_0_ddr_mem_reset_n => HPS_DDR3_RESET_N,
			hps_0_ddr_mem_dq => HPS_DDR3_DQ,
			hps_0_ddr_mem_dqs => HPS_DDR3_DQS_P,
			hps_0_ddr_mem_dqs_n => HPS_DDR3_DQS_N,
			hps_0_ddr_mem_odt => HPS_DDR3_ODT,
			hps_0_ddr_mem_dm => HPS_DDR3_DM,
			hps_0_ddr_oct_rzqin => HPS_DDR3_RZQ,
			hps_0_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,
			hps_0_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,
			hps_0_io_hps_io_emac1_inst_TXD0 => HPS_ENET_TX_DATA(0),
			hps_0_io_hps_io_emac1_inst_TXD1 => HPS_ENET_TX_DATA(1),
			hps_0_io_hps_io_emac1_inst_TXD2 => HPS_ENET_TX_DATA(2),
			hps_0_io_hps_io_emac1_inst_TXD3 => HPS_ENET_TX_DATA(3),
			hps_0_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,
			hps_0_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,
			hps_0_io_hps_io_emac1_inst_RXD0 => HPS_ENET_RX_DATA(0),
			hps_0_io_hps_io_emac1_inst_RXD1 => HPS_ENET_RX_DATA(1),
			hps_0_io_hps_io_emac1_inst_RXD2 => HPS_ENET_RX_DATA(2),
			hps_0_io_hps_io_emac1_inst_RXD3 => HPS_ENET_RX_DATA(3),
			hps_0_io_hps_io_emac1_inst_MDIO => HPS_ENET_MDIO,
			hps_0_io_hps_io_emac1_inst_MDC => HPS_ENET_MDC,
			hps_0_io_hps_io_sdio_inst_CLK => HPS_SD_CLK,
			hps_0_io_hps_io_sdio_inst_CMD => HPS_SD_CMD,
			hps_0_io_hps_io_sdio_inst_D0 => HPS_SD_DATA(0),
			hps_0_io_hps_io_sdio_inst_D1 => HPS_SD_DATA(1),
			hps_0_io_hps_io_sdio_inst_D2 => HPS_SD_DATA(2),
			hps_0_io_hps_io_sdio_inst_D3 => HPS_SD_DATA(3),
			hps_0_io_hps_io_uart0_inst_RX => HPS_UART_RX,
			hps_0_io_hps_io_uart0_inst_TX => HPS_UART_TX,
			hps_0_io_hps_io_gpio_inst_GPIO35 => HPS_ENET_INT_N,
			hps_0_io_hps_io_gpio_inst_GPIO53 => HPS_LED,
			hps_0_io_hps_io_gpio_inst_GPIO54 => HPS_KEY_N,
			
			-- Audio
        audio_0_external_interface_BCLK							=>	AUD_BCLK,
        audio_0_external_interface_DACDAT							=> AUD_DACDAT,
        audio_0_external_interface_DACLRCK						=> AUD_DACLRCK,
        audio_pll_0_audio_clk_clk 										=> AUD_XCK,
		  audio_and_video_config_0_external_interface_SCLK		=> FPGA_I2C_SCLK,
        audio_and_video_config_0_external_interface_SDAT		=> FPGA_I2C_SDAT,
		   -- Busy signal
			spi_system_0_spi_interface_busy_or0            	     => GPIO_0(8),
  			spi_system_0_spi_interface_busy_or1            	     => GPIO_0(16),
  			spi_system_0_spi_interface_busy_or2            	     => GPIO_0(23),					  
			-- SCLK signal
  			spi_system_0_spi_interface_sclk0           			  => GPIO_0(11),
  			spi_system_0_spi_interface_sclk2           			  => GPIO_0(25),
  			spi_system_0_spi_interface_sclk1           			  => GPIO_0(18),
			-- CONVST signal  
			spi_system_0_spi_interface_convst0                  => GPIO_0(13),
			spi_system_0_spi_interface_convst1                  => GPIO_0(20),
			spi_system_0_spi_interface_convst2                  => GPIO_0(27),
			-- MISO signals
			spi_system_0_spi_interface_miso_00           		 => GPIO_0(14), 
			spi_system_0_spi_interface_miso_01                => GPIO_0(15),
		   spi_system_0_spi_interface_miso_10                => GPIO_0(21),
		   spi_system_0_spi_interface_miso_11              	 => GPIO_0(22),
			spi_system_0_spi_interface_miso_20                => GPIO_0(28),
			spi_system_0_spi_interface_miso_21                 => GPIO_0(29),
			-- CS_N signal
			spi_system_0_spi_interface_cs0_n      			 	  => GPIO_0(10),
			spi_system_0_spi_interface_cs1_n      			 	  => GPIO_0(17),
			spi_system_0_spi_interface_cs2_n      			 	  => GPIO_0(24),
			-- Reset signal
			spi_system_0_spi_interface_reset0			 			  => GPIO_0(12),
			spi_system_0_spi_interface_reset1			 			  => GPIO_0(19),
			spi_system_0_spi_interface_reset2			 			  => GPIO_0(26)
		  
		);

end;
