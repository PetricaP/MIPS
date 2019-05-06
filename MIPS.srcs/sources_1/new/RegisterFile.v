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
    
    reg [31:0] registers[0:30];
    
    initial
        $readmemh("registers.mem", registers);
    
    always@(negedge clk)
    if(write == 1 && rc != 0)
        registers[rc - 1] = di;
    
    assign do1 = (ra == 0) ? 0 : registers[ra - 1];
    assign do2 = (rb == 0) ? 0 : registers[rb - 1];
endmodule
