// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS
// IN THIS FILE.

/******************************************************************************
 *                                                                            *
 * This module reads and writes data to the Audio chip on Altera's DE2        *
 *  Development and Education Board. The audio chip must be in master mode    *
 *  and the digital format must be left justified.                            *
 *                                                                            *
 ******************************************************************************/

module Pyramic_Array_audio_controller (
	// Inputs
	clk,
	reset,
	
	from_adc_left_channel_ready,
	from_adc_right_channel_ready,

	to_dac_left_channel_data,
	to_dac_left_channel_valid,
	to_dac_right_channel_data,
	to_dac_right_channel_valid,

	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACLRCK,

	// Bidirectionals

	// Outputs
	from_adc_left_channel_data,
	from_adc_left_channel_valid,
	from_adc_right_channel_data,
	from_adc_right_channel_valid,

	to_dac_left_channel_ready,
	to_dac_right_channel_ready,

	AUD_DACDAT
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;

input						from_adc_left_channel_ready;
input						from_adc_right_channel_ready;

input			[DW: 0]	to_dac_left_channel_data;
input						to_dac_left_channel_valid;
input			[DW: 0]	to_dac_right_channel_data;
input						to_dac_right_channel_valid;

input						AUD_ADCDAT;
input						AUD_ADCLRCK;
input						AUD_BCLK;
input						AUD_DACLRCK;

// Bidirectionals

// Outputs
output		[DW: 0]	from_adc_left_channel_data;
output					from_adc_left_channel_valid;
output		[DW: 0]	from_adc_right_channel_data;
output					from_adc_right_channel_valid;

output					to_dac_left_channel_ready;
output					to_dac_right_channel_ready;

output					AUD_DACDAT;

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/

localparam DW						= 15;
localparam BIT_COUNTER_INIT	= 5'd15;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire						bclk_rising_edge;
wire						bclk_falling_edge;

wire						adc_lrclk_rising_edge;
wire						adc_lrclk_falling_edge;

wire			[ 7: 0]	left_channel_read_available;
wire			[ 7: 0]	right_channel_read_available;
wire						dac_lrclk_rising_edge;
wire						dac_lrclk_falling_edge;

wire			[ 7: 0]	left_channel_write_space;
wire			[ 7: 0]	right_channel_write_space;

// Internal Registers
reg						done_adc_channel_sync;
reg						done_dac_channel_sync;

// State Machine Registers


/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

// Output Registers

// Internal Registers
always @(posedge clk)
begin
	if (reset == 1'b1)
		done_adc_channel_sync <= 1'b0;
	else if (adc_lrclk_rising_edge == 1'b1)
		done_adc_channel_sync <= 1'b1;
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		done_dac_channel_sync <= 1'b0;
	else if (dac_lrclk_falling_edge == 1'b1)
		done_dac_channel_sync <= 1'b1;
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments
assign from_adc_left_channel_valid	= (|(left_channel_read_available));
assign from_adc_right_channel_valid	= (|(right_channel_read_available));

assign to_dac_left_channel_ready		= (|(left_channel_write_space));
assign to_dac_right_channel_ready	= (|(right_channel_write_space));

// Internal Assignments

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

altera_up_clock_edge Bit_Clock_Edges (
	// Inputs
	.clk				(clk),
	.reset			(reset),
	
	.test_clk		(AUD_BCLK),
	
	// Bidirectionals

	// Outputs
	.rising_edge	(bclk_rising_edge),
	.falling_edge	(bclk_falling_edge)
);

altera_up_clock_edge ADC_Left_Right_Clock_Edges (
	// Inputs
	.clk				(clk),
	.reset			(reset),
	
	.test_clk		(AUD_ADCLRCK),
	
	// Bidirectionals

	// Outputs
	.rising_edge	(adc_lrclk_rising_edge),
	.falling_edge	(adc_lrclk_falling_edge)
);

altera_up_clock_edge DAC_Left_Right_Clock_Edges (
	// Inputs
	.clk				(clk),
	.reset			(reset),
	
	.test_clk		(AUD_DACLRCK),
	
	// Bidirectionals

	// Outputs
	.rising_edge	(dac_lrclk_rising_edge),
	.falling_edge	(dac_lrclk_falling_edge)
);

altera_up_audio_in_deserializer Audio_In_Deserializer (
	// Inputs
	.clk									(clk),
	.reset								(reset),
	
	.bit_clk_rising_edge				(bclk_rising_edge),
	.bit_clk_falling_edge			(bclk_falling_edge),
	.left_right_clk_rising_edge	(adc_lrclk_rising_edge),
	.left_right_clk_falling_edge	(adc_lrclk_falling_edge),

	.done_channel_sync				(done_adc_channel_sync),

	.serial_audio_in_data			(AUD_ADCDAT),

	.read_left_audio_data_en		(from_adc_left_channel_valid & from_adc_left_channel_ready),
	.read_right_audio_data_en		(from_adc_right_channel_valid & from_adc_right_channel_ready),

	// Bidirectionals

	// Outputs
	.left_audio_fifo_read_space	(left_channel_read_available),
	.right_audio_fifo_read_space	(right_channel_read_available),

	.left_channel_data				(from_adc_left_channel_data),
	.right_channel_data				(from_adc_right_channel_data)
);
defparam
	Audio_In_Deserializer.DW 					= DW,
	Audio_In_Deserializer.BIT_COUNTER_INIT = BIT_COUNTER_INIT;

altera_up_audio_out_serializer Audio_Out_Serializer (
	// Inputs
	.clk										(clk),
	.reset									(reset),
	
	.bit_clk_rising_edge					(bclk_rising_edge),
	.bit_clk_falling_edge				(bclk_falling_edge),
	.left_right_clk_rising_edge		(done_dac_channel_sync & dac_lrclk_rising_edge),
	.left_right_clk_falling_edge		(done_dac_channel_sync & dac_lrclk_falling_edge),
	
	.left_channel_data					(to_dac_left_channel_data),
	.left_channel_data_en				(to_dac_left_channel_valid & to_dac_left_channel_ready),

	.right_channel_data					(to_dac_right_channel_data),
	.right_channel_data_en				(to_dac_right_channel_valid & to_dac_right_channel_ready),
	
	// Bidirectionals

	// Outputs
	.left_channel_fifo_write_space	(left_channel_write_space),
	.right_channel_fifo_write_space	(right_channel_write_space),

	.serial_audio_out_data				(AUD_DACDAT)
);
defparam
	Audio_Out_Serializer.DW = DW;

endmodule

