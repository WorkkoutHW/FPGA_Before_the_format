module alu(alu_out, E_out, a, b, E, opcode);
	input	[3:0] 	opcode;
	input	[7:0] 	a, b;
	input		E;
	output	[7:0]	alu_out;
	reg	[7:0]	alu_out;
	output		E_out;
	reg		E_out;

always@(*)
begin
	E_out = E;
	alu_out = 8'hxx;
	case(opcode)
		4'b0000: alu_out = a + 8'h01;			//INC*
		4'b0001: {E_out, alu_out} = a + b;		//ADD*
		4'b0010: {E_out, alu_out} = a - b;		//SUB (= a + ~b + 1'b1;)
		4'b0011: alu_out = a + 8'hff;			//DEC
		4'b0100: alu_out = a & b;			//AND*
		4'b0101: alu_out = a | b;			//IOR
		4'b0110: alu_out = a ^ b;			//XOR*
		4'b0111: alu_out = ~a;				//INV*
		4'b1000: {E_out, alu_out} = {a[0], E, a[7:1]};	//SHR*
		4'b1001: {E_out, alu_out} = {a[7], a[6:0], E};	//SHL*
		4'b1010: alu_out = a;				//MOV*
	endcase
end
endmodule