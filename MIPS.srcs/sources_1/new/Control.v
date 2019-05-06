`timescale 1ns / 1ps

`define RTYPE   6'b000000	
`define ADDI	6'b001000
`define ANDI	6'b001100	
`define LW	  6'b100011
`define SW	  6'b101011
`define BEQ	 6'b000100
`define BNE	 6'b000101
`define JAL	 6'b000011
`define J	   6'b000010

`define RA_FUNCT 6'b001000

module Control(opcode, funct, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, BranchNot, WritetoRA, RegtoPC);
	input [5:0] opcode;
	input [5:0] funct;
	output reg RegDst;
	output reg Jump;
	output reg Branch;
	output reg MemRead;
	output reg MemtoReg;
	output reg [1:0] ALUOp;
	output reg MemWrite;
	output reg ALUSrc;
	output reg RegWrite;
	output reg BranchNot;
	output reg WritetoRA;
	output reg RegtoPC;
	
	always@(opcode or funct)
	case(opcode)
		`RTYPE  :
		case(funct)
			`RA_FUNCT: {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
						Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} = 
						13'b1_0_0_1_0_0_0_10_x_0_0_1;
			default  : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
						Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} = 
						13'b1_0_0_1_0_0_0_10_x_0_0_0;
		endcase
		`LW	 : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, 
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} = 
				   13'b0_1_1_1_1_0_0_00_x_0_0_0;
		`SW	 : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} =
				   13'bx_1_x_0_0_1_0_00_x_0_0_0;
		`BEQ	: {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} =
				   13'b0_0_0_0_0_0_1_01_0_0_0_0;
		`BNE	: {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} =
				   13'b0_0_0_0_0_0_1_01_1_0_0_0;
		`ADDI   : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} = 
				   13'b0_1_0_1_0_0_0_00_x_0_0_0;
		`ANDI   : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} = 
				   13'b0_1_0_1_0_0_0_11_x_0_0_0;
		`JAL	: {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} = 
				   13'b1_0_0_1_0_0_0_00_x_1_1_0;
		`J	  : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} =
				   13'b1_0_0_1_0_0_0_00_x_1_0_0;
		default : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				   Branch, ALUOp, BranchNot, Jump, WritetoRA, RegtoPC} =
				   13'b0_0_0_0_0_0_0_00_x_0_0_0;
	endcase
endmodule
