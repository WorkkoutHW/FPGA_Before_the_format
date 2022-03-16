module top(CLK_50M, RESET, PS2D, PS2C, VGA_R, VGA_G, VGA_B, VGA_HSYNC, VGA_VSYNC, GPO, SW); 

	input 			CLK_50M;
	input			RESET;
	input 			PS2D, PS2C;
	output [3:0] 	VGA_R;
	output [3:0] 	VGA_G;
	output [3:0] 	VGA_B;
	output 			VGA_HSYNC;
	output 			VGA_VSYNC;

	wire	[15:0]	mem_addr;
	wire				got_code_tick;
	wire	[7:0]		dout;
	wire		vmem_we;
	output	[7:0]	GPO;
	wire	[7:0]	b;
	input 	[3:0]	SW;

ps2_rx ps2_rx(
				.clk(CLK_50M),
				.reset(RESET),
				.ps2d(PS2D),
				.ps2c(PS2C),
				.got_code_tick(got_code_tick),
    			.dout(dout)
		);

vga vga(
			.CLK_50M(CLK_50M),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HSYNC(VGA_HSYNC),
			.VGA_VSYNC(VGA_VSYNC),
			.mem_addr({mem_addr[12:8], mem_addr[6:0]}),
			.mem_we(vmem_we),
			.mem_data(b)
		);

cpu cpu(
	.mem_addr(mem_addr),
	.dmem_we(),
	.vmem_we(vmem_we),
	.gpo(GPO),
	.b(b),
	.clock(CLK_50M),
	.reset(RESET),
	.gpi(dout),
	.gpi_we(got_code_tick),
	.dmem_out(8'hff),
	.SW(SW)
);

endmodule