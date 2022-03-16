`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:15:39 11/08/2021 
// Design Name: 
// Module Name:    vga 
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
`timescale 1ns / 1ps

module vga(CLK_50M, VGA_R, VGA_G, VGA_B, VGA_HSYNC, VGA_VSYNC);

	input CLK_50M;
	output [3:0] VGA_R;
	output [3:0] VGA_G;
	output [3:0] VGA_B;
	output VGA_HSYNC;
	output VGA_VSYNC;

	reg clk_25m;
	wire clk;
	assign clk = clk_25m;

	reg [9:0] hcount;
	reg [9:0] vcount;

	reg [3:0] vga_r_out;
	reg [3:0] vga_g_out;
	reg [3:0] vga_b_out;
	reg vga_hsync_out;
	reg vga_vsync_out;

	assign VGA_R = vga_r_out;
	assign VGA_G = vga_g_out;
	assign VGA_B = vga_b_out;
	assign VGA_HSYNC = vga_hsync_out;
	assign VGA_VSYNC = vga_vsync_out;

	parameter H_ACTIVE_PIXEL_LIMIT = 639;
	parameter H_FPORCH_PIXEL_LIMIT = 656; // 640+16
	parameter H_SYNC_PIXEL_LIMIT   = 752; // 640+16+96
	parameter H_BPORCH_PIXEL_LIMIT = 799; // 640+16+96+48

	parameter V_ACTIVE_LINE_LIMIT = 479;
	parameter V_FPORCH_LINE_LIMIT = 490; // 480+10
	parameter V_SYNC_LINE_LIMIT   = 492; // 480+10+2
	parameter V_BPORCH_LINE_LIMIT = 519; // 480+10+2+28

always @(posedge CLK_50M)
begin
	clk_25m <= clk_25m + 1;
end

always @(posedge clk)
	if (hcount < H_BPORCH_PIXEL_LIMIT)
		hcount <= hcount + 1;
	else
		begin
			hcount <= 0;
			if (vcount < V_BPORCH_LINE_LIMIT)
			   	vcount <= vcount + 1;
			else 
				vcount <= 0;
		end

always @(posedge clk)
	if (hcount <= H_ACTIVE_PIXEL_LIMIT &&
		vcount <= V_ACTIVE_LINE_LIMIT) // active video region
		begin
			vga_r_out <= hcount[9:6];
			vga_g_out <= hcount[9:6];
			vga_b_out <= hcount[9:6];
		end
	else if(hcount > H_ACTIVE_PIXEL_LIMIT ||
			vcount > V_ACTIVE_LINE_LIMIT) // blank region
		begin
			vga_r_out <= 4'b0000;
			vga_g_out <= 4'b0000;
			vga_b_out <= 4'b0000;
		end

always @(posedge clk)
	case (hcount)
		H_FPORCH_PIXEL_LIMIT: // sync pulse
			vga_hsync_out <= 1'b0; // 해당 signal의 역할 : Monitor의 AD board에게 다음 주사를 시키도록 명령하는 것!
		H_SYNC_PIXEL_LIMIT: // back porch
			vga_hsync_out <= 1'b1;
	endcase

always @(posedge clk)
	case (vcount)
		V_FPORCH_LINE_LIMIT: // sync pulse
			vga_vsync_out <= 1'b0;
		V_SYNC_LINE_LIMIT: // back porch
			vga_vsync_out <= 1'b1;
	endcase

endmodule
