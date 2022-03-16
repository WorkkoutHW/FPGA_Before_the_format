module cpu(mem_addr, dmem_we, vmem_we, gpo, b, clock, reset, gpi_we, dmem_out,gpi, SW);
//module cpu(gpo, clock, reset);

	input		clock;
	input		reset;
	input	[7:0]	gpi;
//	wire		gpi_we = 1'b0;
	input		gpi_we;
//	wire	[7:0]	dmem_out = 8'h00;
	input	[7:0]	dmem_out;
//	wire 	[7:0]	dmem_out=8'h00;

//	wire	[15:0]	mem_addr;
	output	[15:0]	mem_addr;
//	wire		dmem_we;
	output		dmem_we;
//	wire		vmem_we;
	output		vmem_we;
	output 	[7:0]	gpo;
//  	wire 	[7:0]	b; 
	output 	[7:0]	b; 

	input	[3:0]	SW;

	wire 	[7:0]	alu_out;
	wire 		E_out;
   	wire  	[7:0]	a;
   	wire  		E;
	wire 	[7:0]	pc;
	wire 	[3:0]	opcode;
	wire	[3:0]	raddr1;
	wire	[3:0]	raddr2;
	wire	[3:0]	waddr;

alu alu(
				.alu_out(alu_out), 
				.E_out(E_out),
				.a(a),
				.b(b),
				.E(E),
				.opcode(opcode)
			);
reg_file reg_file(
				.a(a),
				.b(b),
				.E(E),
				.pc(pc),
				.mem_addr(mem_addr),
				.dmem_we(dmem_we),
				.vmem_we(vmem_we),
				.gpo(gpo),
				.clock(clock),
				.reset(reset),
				.alu_out(alu_out),
				.E_out(E_out),
				.opcode(opcode),
				.raddr1(raddr1),
				.raddr2(raddr2),
				.waddr(waddr),
				.gpi(gpi),
				.gpi_we(gpi_we),
				.dmem_out(dmem_out),
				.SW(SW)
			);

prog_mem prog_mem(
				.addr(pc),
				.dout({opcode, raddr1, raddr2, waddr})
			);
endmodule
