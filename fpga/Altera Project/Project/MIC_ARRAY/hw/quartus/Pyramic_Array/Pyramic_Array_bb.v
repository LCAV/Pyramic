
module Pyramic_Array (
	audio_0_external_interface_BCLK,
	audio_0_external_interface_DACDAT,
	audio_0_external_interface_DACLRCK,
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	clk_clk,
	hps_0_ddr_mem_a,
	hps_0_ddr_mem_ba,
	hps_0_ddr_mem_ck,
	hps_0_ddr_mem_ck_n,
	hps_0_ddr_mem_cke,
	hps_0_ddr_mem_cs_n,
	hps_0_ddr_mem_ras_n,
	hps_0_ddr_mem_cas_n,
	hps_0_ddr_mem_we_n,
	hps_0_ddr_mem_reset_n,
	hps_0_ddr_mem_dq,
	hps_0_ddr_mem_dqs,
	hps_0_ddr_mem_dqs_n,
	hps_0_ddr_mem_odt,
	hps_0_ddr_mem_dm,
	hps_0_ddr_oct_rzqin,
	hps_0_io_hps_io_emac1_inst_TX_CLK,
	hps_0_io_hps_io_emac1_inst_TXD0,
	hps_0_io_hps_io_emac1_inst_TXD1,
	hps_0_io_hps_io_emac1_inst_TXD2,
	hps_0_io_hps_io_emac1_inst_TXD3,
	hps_0_io_hps_io_emac1_inst_RXD0,
	hps_0_io_hps_io_emac1_inst_MDIO,
	hps_0_io_hps_io_emac1_inst_MDC,
	hps_0_io_hps_io_emac1_inst_RX_CTL,
	hps_0_io_hps_io_emac1_inst_TX_CTL,
	hps_0_io_hps_io_emac1_inst_RX_CLK,
	hps_0_io_hps_io_emac1_inst_RXD1,
	hps_0_io_hps_io_emac1_inst_RXD2,
	hps_0_io_hps_io_emac1_inst_RXD3,
	hps_0_io_hps_io_sdio_inst_CMD,
	hps_0_io_hps_io_sdio_inst_D0,
	hps_0_io_hps_io_sdio_inst_D1,
	hps_0_io_hps_io_sdio_inst_CLK,
	hps_0_io_hps_io_sdio_inst_D2,
	hps_0_io_hps_io_sdio_inst_D3,
	hps_0_io_hps_io_uart0_inst_RX,
	hps_0_io_hps_io_uart0_inst_TX,
	hps_0_io_hps_io_gpio_inst_GPIO35,
	hps_0_io_hps_io_gpio_inst_GPIO53,
	hps_0_io_hps_io_gpio_inst_GPIO54,
	reset_reset_n,
	spi_system_0_spi_interface_convst0,
	spi_system_0_spi_interface_convst1,
	spi_system_0_spi_interface_convst2,
	spi_system_0_spi_interface_cs0_n,
	spi_system_0_spi_interface_cs1_n,
	spi_system_0_spi_interface_cs2_n,
	spi_system_0_spi_interface_miso_00,
	spi_system_0_spi_interface_miso_01,
	spi_system_0_spi_interface_miso_10,
	spi_system_0_spi_interface_miso_11,
	spi_system_0_spi_interface_miso_20,
	spi_system_0_spi_interface_miso_21,
	spi_system_0_spi_interface_reset0,
	spi_system_0_spi_interface_reset1,
	spi_system_0_spi_interface_reset2,
	spi_system_0_spi_interface_sclk0,
	spi_system_0_spi_interface_sclk1,
	spi_system_0_spi_interface_sclk2,
	spi_system_0_spi_interface_busy_or0,
	spi_system_0_spi_interface_busy_or1,
	spi_system_0_spi_interface_busy_or2,
	audio_pll_0_audio_clk_clk);	

	input		audio_0_external_interface_BCLK;
	output		audio_0_external_interface_DACDAT;
	input		audio_0_external_interface_DACLRCK;
	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	input		clk_clk;
	output	[14:0]	hps_0_ddr_mem_a;
	output	[2:0]	hps_0_ddr_mem_ba;
	output		hps_0_ddr_mem_ck;
	output		hps_0_ddr_mem_ck_n;
	output		hps_0_ddr_mem_cke;
	output		hps_0_ddr_mem_cs_n;
	output		hps_0_ddr_mem_ras_n;
	output		hps_0_ddr_mem_cas_n;
	output		hps_0_ddr_mem_we_n;
	output		hps_0_ddr_mem_reset_n;
	inout	[31:0]	hps_0_ddr_mem_dq;
	inout	[3:0]	hps_0_ddr_mem_dqs;
	inout	[3:0]	hps_0_ddr_mem_dqs_n;
	output		hps_0_ddr_mem_odt;
	output	[3:0]	hps_0_ddr_mem_dm;
	input		hps_0_ddr_oct_rzqin;
	output		hps_0_io_hps_io_emac1_inst_TX_CLK;
	output		hps_0_io_hps_io_emac1_inst_TXD0;
	output		hps_0_io_hps_io_emac1_inst_TXD1;
	output		hps_0_io_hps_io_emac1_inst_TXD2;
	output		hps_0_io_hps_io_emac1_inst_TXD3;
	input		hps_0_io_hps_io_emac1_inst_RXD0;
	inout		hps_0_io_hps_io_emac1_inst_MDIO;
	output		hps_0_io_hps_io_emac1_inst_MDC;
	input		hps_0_io_hps_io_emac1_inst_RX_CTL;
	output		hps_0_io_hps_io_emac1_inst_TX_CTL;
	input		hps_0_io_hps_io_emac1_inst_RX_CLK;
	input		hps_0_io_hps_io_emac1_inst_RXD1;
	input		hps_0_io_hps_io_emac1_inst_RXD2;
	input		hps_0_io_hps_io_emac1_inst_RXD3;
	inout		hps_0_io_hps_io_sdio_inst_CMD;
	inout		hps_0_io_hps_io_sdio_inst_D0;
	inout		hps_0_io_hps_io_sdio_inst_D1;
	output		hps_0_io_hps_io_sdio_inst_CLK;
	inout		hps_0_io_hps_io_sdio_inst_D2;
	inout		hps_0_io_hps_io_sdio_inst_D3;
	input		hps_0_io_hps_io_uart0_inst_RX;
	output		hps_0_io_hps_io_uart0_inst_TX;
	inout		hps_0_io_hps_io_gpio_inst_GPIO35;
	inout		hps_0_io_hps_io_gpio_inst_GPIO53;
	inout		hps_0_io_hps_io_gpio_inst_GPIO54;
	input		reset_reset_n;
	output		spi_system_0_spi_interface_convst0;
	output		spi_system_0_spi_interface_convst1;
	output		spi_system_0_spi_interface_convst2;
	output		spi_system_0_spi_interface_cs0_n;
	output		spi_system_0_spi_interface_cs1_n;
	output		spi_system_0_spi_interface_cs2_n;
	input		spi_system_0_spi_interface_miso_00;
	input		spi_system_0_spi_interface_miso_01;
	input		spi_system_0_spi_interface_miso_10;
	input		spi_system_0_spi_interface_miso_11;
	input		spi_system_0_spi_interface_miso_20;
	input		spi_system_0_spi_interface_miso_21;
	output		spi_system_0_spi_interface_reset0;
	output		spi_system_0_spi_interface_reset1;
	output		spi_system_0_spi_interface_reset2;
	output		spi_system_0_spi_interface_sclk0;
	output		spi_system_0_spi_interface_sclk1;
	output		spi_system_0_spi_interface_sclk2;
	input		spi_system_0_spi_interface_busy_or0;
	input		spi_system_0_spi_interface_busy_or1;
	input		spi_system_0_spi_interface_busy_or2;
	output		audio_pll_0_audio_clk_clk;
endmodule
