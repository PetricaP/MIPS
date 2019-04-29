`timescale 1ns / 1ps

module RegisterFile(clk, ra, rb, write, rc, di, do1, do2);
    input clk;
    input [4:0] ra;
    input [4:0] rb;
    input write;
    input [4:0] rc;
    input [31:0] di;
    output [31:0] do1;
    output [31:0] do2;
    
    reg [31:0] registers[0:31];
    
    integer i;
    initial
        for(i = 0; i < 32; i = i + 1)
            registers[i] = 0;
    
    always@(posedge clk)
    if(write == 1)
        registers[rc] = di;
    
    assign do1 = registers[ra];
    assign do2 = registers[rb];
endmodule
