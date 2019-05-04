`timescale 1ns / 1ps

`define ALU_ADD 4'b0010
`define ALU_SUB 4'b0110
`define ALU_AND 4'b0000
`define ALU_OR  4'b0001
`define ALU_SLT 4'b0111
`define ALU_NOR 4'b1100

module ALU(ALUCode, ALUControlBits, operand1, operand2, ALUOut, Zero);
    input [3:0] ALUCode;
    input [5:0] ALUControlBits;
    input [31:0] operand1;
    input [31:0] operand2;
    
    output reg [31:0] ALUOut;
    output Zero;

    always @(operand1 or operand2 or ALUCode)
    casex(ALUCode)
        `ALU_AND:    ALUOut = operand1 & operand2;
        `ALU_OR :    ALUOut = operand1 | operand2;
        `ALU_ADD:    ALUOut = operand1 + operand2;
        `ALU_SUB:    ALUOut = operand1 - operand2;
        `ALU_SLT:    ALUOut = operand1 < operand2;
        `ALU_NOR:    ALUOut = ~(operand1 | operand2);
        default:    ALUOut = 0;
    endcase
    
    assign Zero = (operand1 == operand2);
endmodule
