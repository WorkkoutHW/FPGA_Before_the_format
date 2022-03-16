`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:23 10/09/2021 
// Design Name: 
// Module Name:    D_reg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module D_reg(Data_in, Data_out, clock, reset);
	output [3:0] Data_out;
	input  [3:0] Data_in;
	input 		 reset;
	input			 clock;
	
	reg [3:0] Data_out;
	wire		 clk;
	reg [26:0] leds_r;
	
	always @ (posedge clock)
		leds_r <= leds_r + 1;
		assign clk = leds_r[26];
		
	always @ (posedge clk)
		if (reset == 1'b1) Data_out <= 4'b0000;
		else Data_out <= Data_in;

endmodule
