`timescale 1ns / 1ps

`define ALU_ADD 4'b0010
`define ALU_SUB 4'b0110
`define ALU_AND 4'b0000
`define ALU_OR  4'b0001
`define ALU_SLT 4'b0111
`define ALU_NOR 4'b1100

module ALUControl(Op, ControlBits, Code);
    input [1:0] Op;
    input [5:0] ControlBits;
    output reg [3:0] Code;
    
    always @(Op or ControlBits or Code)
    casex({Op, ControlBits}) 
        8'b00_xxxxxx:   Code = `ALU_ADD;
        8'b01_xxxxxx:   Code = `ALU_SUB;
        8'b11_xxxxxx:   Code = `ALU_AND;
        8'b10_100000:   Code = `ALU_ADD;
        8'b10_100010:   Code = `ALU_SUB;
        8'b10_100100:   Code = `ALU_AND;
        8'b10_100101:   Code = `ALU_OR;
        8'b10_101010:   Code = `ALU_SLT;
        default:        Code = 4'b1111; 
    endcase
endmodule
