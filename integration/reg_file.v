module reg_file(a, b, E, pc, mem_addr, dmem_we, vmem_we, gpo,
clock, reset, alu_out, E_out, opcode, raddr1, raddr2, waddr, gpi, gpi_we, dmem_out, SW);

	output	[7:0]	a, b;
	output		E;
	reg		E;
	output 	[7:0]	pc, gpo;
	output	[15:0]	mem_addr;
	output		dmem_we, vmem_we;
	
	input		clock;
	input		reset;
	input	[7:0]	alu_out;
	input		E_out;
	input	[3:0]	opcode, raddr1, raddr2, waddr;
	input 	[7:0]	gpi, dmem_out;
	input 		gpi_we;
	input	[3:0]	SW;

	reg	[7:0]	register	[0:15];
	reg		F;
	reg	[7:0]	wdata;
	wire		normal_op;
	wire 		condjump_unsatisfied;

	always@(*)
		case(opcode)
			4'b1100: wdata = {raddr1, raddr2};	//LDI* (loading immediate value)
			4'b1101: wdata = dmem_out;		//DMR (data memory read), must be used always double times for 'synchronous' data memory 
			default: wdata = alu_out;
		endcase		

	assign normal_op = opcode[3:1]!=3'b111; 
// opcode의 상위 3개 bit가 모두 1만 아니면? normal_op가 1이다! ---> wdata의 값이 바뀌는 경우를 의미!
// alu의 동작 + 바로 위의 code! 

	always@(posedge clock)
		if(reset)
			begin
				register[0] <= 8'h00;
				register[1] <= 8'h00;
				register[2] <= 8'h00;
				register[3] <= 8'h00;
				register[4] <= 8'h00;
				register[5] <= 8'h00;
				register[6] <= 8'h00;
				register[7] <= 8'h00;
				register[8] <= 8'h00;
				register[9] <= 8'h00;
				register[10] <= 8'h00;
				register[11] <= 8'h00;
				register[12] <= 8'h00;
				register[13] <= 8'h00;
				register[14] <= 8'h00;
				register[15] <= 8'h00;
			end
		else 
			begin//easy understanding is more important rather than simple code 
				if(gpi_we)
					register[13] <= gpi;//R13 is used for keyboard input only
				if(normal_op && waddr==15)//for unconditional jumps (LDI $value 'R15' = JUI $value, MOV Rx    'R15' = JUD Rx)
				begin
					register[15] <= wdata;
					register[14] <= register[15] + 1;//save the return address, R14 is used for that purpose only
				end
				else if(condjump_unsatisfied)//for conditional jumps unsatisfied
					register[15] <= register[15] + 2;
				else
					register[15] <= register[15] + 1; // reg[15]가 평상시엔 프로그램 counter니까 매 clock마다 1씩 증가!
				if(normal_op && waddr!=13 && waddr!=14 && waddr!=15)
					register[waddr] <= wdata;
			
			end//each if statmemt from begin to end must have orthogornal (exclustive) condition (must not have intersection condition)

	assign a = register[raddr1];
	assign b = register[raddr2];//b is used for memory write, too.

	always@(posedge clock)
		if(reset)
			F <= 1'b0;
		else if(gpi_we)
			F <= 1'b1;
		else if(opcode==4'b1111&&waddr==4'b0001)//CLF* // clear flag이고 여기서 waddr은 sub opcode이다!!
			F <= 1'b0;

	always@(posedge clock)
		if(reset)
			E <= 1'b0;
		else if(opcode==4'b1111&&waddr==4'b0010)//CLE*
			E <= 1'b0;
		else
			E <= E_out;

	assign	condjump_unsatisfied = 	(opcode==4'b1110&&(
					(waddr==4'b0001&&!a==b)		||	//JEQ
					(waddr==4'b0010&&!a>b)		||	//JGT
					(waddr==4'b0100&&!F)		||	//JFS
					(waddr==4'b1000&&!E)			//JES
							   )	)? 1'b1: 1'b0;

	assign mem_addr = {register[11], register[10]};
	assign vmem_we 	= (opcode==4'b1111&&waddr==4'b0100)? 1'b1: 1'b0;//VMW (video memory write)
	assign dmem_we 	= (opcode==4'b1111&&waddr==4'b1000)? 1'b1: 1'b0;//DMW (data memory write)

	assign gpo 	= register[SW]; //외부로 빼내어서 LED로 동작을 확인하기 위해서 사용!
	assign pc 	= register[15];

endmodule
