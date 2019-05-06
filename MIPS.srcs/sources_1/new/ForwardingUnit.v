`timescale 1ns / 1ps

module ForwardingUnit(readRegister1_1, readRegister2_1, RegWrite_2,
                      writeRegister_2, RegWrite_3, writeRegister_3, MemtoReg_2,
                      readRegister1, readRegister2, Branch, MemtoReg_3, MemWrite_3,
                      ALUSrc_1, ALUSrc_2, RegtoPC, MemWrite_2, readRegister2_2, MemWrite_1,
                      ForwardA, ForwardB, ForwardCA, ForwardCB, ForwardMB, ForwardRB);
    
    input [4:0] readRegister1_1;
    input [4:0] readRegister2_1;
    input [4:0] writeRegister_2;
    input [4:0] writeRegister_3;
  
    input RegWrite_3;
    input RegWrite_2;
     
    input Branch;
    input MemtoReg_3;
    input [4:0] readRegister1;
    input [4:0] readRegister2;
    
    input ALUSrc_1;
    input ALUSrc_2;
    input RegtoPC;
    input MemWrite_2;
    input [4:0] readRegister2_2;
    input MemWrite_3;    
    input MemWrite_1;
    
    input MemtoReg_2;

    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;
    
    output reg [1:0] ForwardCA;
    output reg [1:0] ForwardCB;
    
    output reg [1:0] ForwardMB;
    output reg [1:0] ForwardRB;
    
    initial
    begin
        ForwardA = 0;
        ForwardB = 0;
        ForwardCA = 0;
        ForwardCB = 0;
        ForwardMB = 0;
        ForwardRB = 0;
    end
    
    always@(MemWrite_2 or readRegister2_2 or writeRegister_3)
    if(MemWrite_2 && writeRegister_3 != 0
       && readRegister2_2 == writeRegister_3)
        if(MemtoReg_3 == 1)
            ForwardMB = 2'b10;
        else
            ForwardMB = 2'b01;
    else
        ForwardMB = 0;
    
    always@(readRegister1_1 or readRegister2_1
            or RegWrite_2 or writeRegister_2
            or RegWrite_3 or writeRegister_3 or ALUSrc_2)
    begin
        if(RegWrite_2 && writeRegister_2 != 0 && writeRegister_2 == readRegister1_1)
            ForwardA <= 2'b10;
        else if(RegWrite_3 && !RegWrite_2 && writeRegister_3 != 0 && writeRegister_3 == readRegister1_1)
            ForwardA <= 2'b01;
        else
            ForwardA <= 2'b00;

        if(RegWrite_2 && writeRegister_2 != 0 && writeRegister_2 == readRegister2_1
            && !ALUSrc_1)
            ForwardB <= 2'b10;
        else if(RegWrite_3 && !ALUSrc_1 && writeRegister_3 != 0 && writeRegister_3 == readRegister2_1 && !MemWrite_1)
            ForwardB <= 2'b01;
        else
            ForwardB <= 2'b00;
    end
    
    always@(Branch or RegtoPC or RegWrite_2 or readRegister1 or writeRegister_2
            or readRegister1 or MemtoReg_3)
    begin
        if((Branch == 1 || RegtoPC == 1) && RegWrite_2 == 1 && readRegister1 == writeRegister_2)
            ForwardCA <= 2'b10;
        else if((Branch == 1 || RegtoPC == 1) && MemtoReg_3 == 1 && RegWrite_3 == 1 
                && readRegister1 == writeRegister_3)
            ForwardCA <= 2'b01;
        else
            ForwardCA <= 2'b00;
           
        if(Branch == 1 && RegWrite_2 == 1 && readRegister2 == writeRegister_2
           && !ALUSrc_2)
            ForwardCB <= 2'b10;
        else if(Branch == 1 && MemtoReg_3 == 1 && RegWrite_3 == 1 
                && readRegister2 == writeRegister_3)
            ForwardCB <= 2'b01;
        else
            ForwardCB <= 2'b00;
    end
    
    always@(MemtoReg_3 or MemWrite_1 or MemtoReg_2 or readRegister2_1 or writeRegister_3 or RegWrite_3 or MemtoReg_2 or RegWrite_2)
    if(RegWrite_2 && !MemtoReg_2 && MemWrite_1 && writeRegister_2 != 0 && readRegister2_1 == writeRegister_2)
        ForwardRB <= 2'b10;
    else if(RegWrite_3 && !MemtoReg_3 && MemWrite_1 && writeRegister_3 != 0 && readRegister2_1 == writeRegister_3)
        ForwardRB <= 2'b11;
    else if(RegWrite_3 && MemtoReg_3 && MemWrite_1 && writeRegister_3 != 0 && readRegister2_1 == writeRegister_3)
        ForwardRB <= 1;
    else
        ForwardRB <= 0;
    
endmodule
