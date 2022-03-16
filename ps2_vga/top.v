module top(CLK_50M, RESET, PS2D, PS2C, VGA_R, VGA_G, VGA_B, VGA_HSYNC, VGA_VSYNC); 

	input 			CLK_50M;
	input			RESET;
	input 			PS2D, PS2C;
	output [3:0] 	VGA_R;
	output [3:0] 	VGA_G;
	output [3:0] 	VGA_B;
	output 			VGA_HSYNC;
	output 			VGA_VSYNC;

	reg	[12:0]	mem_addr;
	wire				got_code_tick;
	wire	[7:0]		dout;

ps2_rx ps2_rx(
				.clk(CLK_50M),
				.reset(RESET),
				.ps2d(PS2D),
				.ps2c(PS2C),
				.got_code_tick(got_code_tick),
    			.dout(dout)
		);

always@(posedge CLK_50M)
	if(RESET)
   		mem_addr <= 0;
	else if(got_code_tick)
		mem_addr <= mem_addr + 1;

vga vga(
			.CLK_50M(CLK_50M),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HSYNC(VGA_HSYNC),
			.VGA_VSYNC(VGA_VSYNC),
			.mem_addr(mem_addr),
			.mem_we(got_code_tick),
			.mem_data(dout)
		);

endmodule