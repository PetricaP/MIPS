`timescale 1ns / 1ps

module ForwardingUnit(readRegister1, readRegister2, RegWrite_2, writeRegister_2, RegWrite_3, writeRegister_3, ForwardA, ForwardB);
    input [4:0] readRegister1;
    input [4:0] readRegister2;
    input [4:0] writeRegister_2;
    input [4:0] writeRegister_3;
    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;
    input RegWrite_2;
    input RegWrite_3;
    
    always@(readRegister1 or readRegister2
            or RegWrite_2 or writeRegister_2
            or RegWrite_3 or writeRegister_3)
    if(RegWrite_2 && writeRegister_2 != 0)
    begin
        if(writeRegister_2 == readRegister1)
            ForwardA = 2'b10;
        else if(writeRegister_3 == readRegister1)
            ForwardA = 2'b01;
        else
            ForwardA = 2'b00;

        if(writeRegister_2 == readRegister2)
            ForwardB = 2'b10;
        else if(writeRegister_3 == readRegister2)
            ForwardB = 2'b01;
        else
            ForwardB = 2'b00;
    end
endmodule
