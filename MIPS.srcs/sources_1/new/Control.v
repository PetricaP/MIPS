`timescale 1ns / 1ps

`define RTYPE   6'b000000    
`define ADDI    6'b001000
`define ANDI    6'b001100    
`define LW      6'b100011
`define SW      6'b101011
`define BEQ     6'b000100
`define BNE     6'b000101

module Control(opcode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, BranchNot);
    input [5:0] opcode;
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
    
    always@(opcode)
    case(opcode)
        `RTYPE  : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b1_0_0_1_0_0_0_10_x;
        `LW     : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b0_1_1_1_1_0_0_00_x;
        `SW     : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'bx_1_x_0_0_1_0_00_x;
        `BEQ    : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b0_0_0_0_0_0_1_01_0;
        `BNE    : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b0_0_0_0_0_0_1_01_1;
        `ADDI   : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b0_1_0_1_0_0_0_00_x;
        `ANDI   : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b0_1_0_1_0_0_0_11_x;
        default : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, BranchNot} <= 10'b0_0_0_0_0_0_0_00_x;
    endcase
endmodule
