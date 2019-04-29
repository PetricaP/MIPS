`timescale 1ns / 1ps

module InstructionMemory(address, dataOut);
    input [31:0] address;
    output [31:0] dataOut;
    
    reg [31:0] memory[0:5];
    
    initial
        $readmemh("program.mem", memory, 0, 5);

    assign dataOut = memory[address >> 2];
endmodule
