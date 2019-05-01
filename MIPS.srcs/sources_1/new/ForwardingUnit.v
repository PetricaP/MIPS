`timescale 1ns / 1ps

module ForwardingUnit(readRegister1_1, readRegister2_1, RegWrite_2,
                      writeRegister_2, RegWrite_3, writeRegister_3,
                      ForwardA, ForwardB);
    input [4:0] readRegister1_1;
    input [4:0] readRegister2_1;
    input [4:0] writeRegister_2;
    input [4:0] writeRegister_3;
    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;
    input RegWrite_2;
    input RegWrite_3;
    
    initial
    begin
        ForwardA = 0;
        ForwardB = 0;
    end
    
    always@(readRegister1_1 or readRegister2_1
            or RegWrite_2 or writeRegister_2
            or RegWrite_3 or writeRegister_3)
    if(RegWrite_2)
    begin
        if(writeRegister_2 != 0 && writeRegister_2 == readRegister1_1)
            ForwardA <= 2'b10;
        else if(writeRegister_3 != 0 && writeRegister_3 == readRegister1_1)
            ForwardA <= 2'b01;
        else
            ForwardA <= 2'b00;

        if(writeRegister_3 != 0 && writeRegister_2 == readRegister2_1)
            ForwardB <= 2'b10;
        else if(writeRegister_3 != 0 && writeRegister_3 == readRegister2_1)
            ForwardB <= 2'b01;
        else
            ForwardB <= 2'b00;
    end
endmodule
