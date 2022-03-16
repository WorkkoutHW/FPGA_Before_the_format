`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:04:52 10/06/2021 
// Design Name: 
// Module Name:    cnt28bit 
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
module cnt28bit( input clk,
input rst,
output [1:0] leds);

reg [27:0] leds_r;
// assign leds[3:0] = leds_r[27:24];

assign leds[1] = leds_r[27] & leds_r[26];
assign leds[0] = leds_r[27] | leds_r[26];

// assign leds[3:0] = leds_r[27:24];

always@(posedge clk)
	if(rst) leds_r <= 0;
	else leds_r <= leds_r + 1;

endmodule

/* module decoder(Data, Code);

output [7:0] Data;
input [2:0] Code;
reg [7:0] Data;

always @ (Code)

 if (Code == 3'b000) Data = 8'b0000_0001; else
 if (Code == 3'b001) Data = 8'b0000_0010; else
 if (Code == 3'b010) Data = 8'b0000_0100; else
 if (Code == 3'b011) Data = 8'b0000_1000; else
 if (Code == 3'b100) Data = 8'b0001_0000; else
 if (Code == 3'b101) Data = 8'b0010_0000; else
 if (Code == 3'b110) Data = 8'b0100_0000; else
 if (Code == 3'b111) Data = 8'b1000_0000; else
	Data = 8'bx;

endmodule */