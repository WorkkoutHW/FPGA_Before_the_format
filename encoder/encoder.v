`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:00:57 10/09/2021 
// Design Name: 
// Module Name:    encoder 
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
module encoder( Data, Code);
	input [3:0]Data;
	output [1:0]Code;
	reg [1:0]Code;
	
	always @ (*)
	casex(Data)
	4'b0001: Code = 2'b00; 
	4'b001x: Code = 2'b01; 
	4'b01xx: Code = 2'b10; 
	4'b1xxx: Code = 2'b11; 
	default: Code = 2'bx;
	endcase
	
endmodule
