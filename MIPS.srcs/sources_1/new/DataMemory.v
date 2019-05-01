`timescale 1ns / 1ps

module DataMemory(address, writeData, read, write, dataOut);
    input [31:0] address;
    input [31:0] writeData;
    input read;
    input write;
    output reg [31:0] dataOut;
    
    reg [31:0] memory[0:255];
    
    initial
        $readmemh("data.mem", memory, 0, 5);
    
    always @(address or posedge read)
        if(read)
            dataOut <= memory[address >> 2];
        
    always @(address or posedge write)
        if(write)
            memory[address >> 2] <= writeData;
endmodule
