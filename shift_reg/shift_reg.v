`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:18:01 10/19/2021 
// Design Name: 
// Module Name:    shift_reg 
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
module shift_reg(E, D, C, B, A, clock, reset);

output D,C,B,A;
input E;
input clock, reset;
reg D,C,B,A;

wire clk;
reg [26:0] leds_r;

always @ (posedge clock)
leds_r <= leds_r + 1;

assign clk = leds_r[25];

always @ (posedge clk)
if(reset == 1'b1) begin D<=0; C<=0; B<=0; A<=0; end
else begin D<=E; C<=D; B<=C; A<=B; end

endmodule
