`timescale 1ns / 1ps

module HazardDetectionUnit(readRegister1, readRegister2, MemRead_1, writeRegister_I_1, PCWrite, IF_ID_Write, ControlSrc);
    input [4:0] readRegister1;
    input [4:0] readRegister2;
    input MemRead_1;
    input [4:0] writeRegister_I_1;
    output reg PCWrite;
    output reg IF_ID_Write;
    output reg ControlSrc;
    
    always @(readRegister1 or readRegister2 or MemRead_1 or writeRegister_I_1)
    begin
        if(writeRegister_I_1 == readRegister1 || writeRegister_I_1 == readRegister2)
        begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ControlSrc = 0;
        end
        else
        begin
            PCWrite = 1;
            IF_ID_Write = 1;
            ControlSrc = 1;
        end
    end
endmodule
