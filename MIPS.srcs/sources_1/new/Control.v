`timescale 1ns / 1ps

`define RTYPE   6'b000000    
`define ADDI    6'b001000    
`define LW      6'b100011
`define SW      6'b101011
`define BEQ     6'b000100

module Control(opcode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
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
    
    always@(opcode)
    case(opcode)
        `RTYPE  : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b1_0_0_1_0_0_0_10;
        `LW     : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_1_1_1_1_0_0_00;
        `SW     : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'bx_1_x_0_0_1_0_00;
        `BEQ    : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'bx_0_x_0_0_0_1_01;
        `ADDI   : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_1_0_1_0_0_0_00;
        default : {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_0_0_0_0_0_0_00;
    endcase
endmodule
