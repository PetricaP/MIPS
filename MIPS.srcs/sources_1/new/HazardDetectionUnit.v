`timescale 1ns / 1ps

module HazardDetectionUnit(readRegister1, readRegister2, MemRead_1,
						   writeRegister_I_1, Branch, RegWrite_1, MemtoReg_1,
						   PCWrite, IF_ID_Write, ControlSrc);
    input [4:0] readRegister1;
    input [4:0] readRegister2;
    input MemRead_1;
    input [4:0] writeRegister_I_1;
	input Branch;
	input RegWrite_1;
	input MemtoReg_1;
    output reg PCWrite;
    output reg IF_ID_Write;
    output reg ControlSrc;
    
    always @(readRegister1 or readRegister2 or MemRead_1 or writeRegister_I_1
			 or Branch)
    begin
		// Bubble for BEQ when operand is calculated by RTYPE just before
        if(Branch && RegWrite_1 && (readRegister1 == writeRegister_I_1
								  || readRegister2 == writeRegister_I_1
							  	  || readRegister1 == writeRegister_R_1
								  || readRegister2 == writeRegister_R_1))
		// First bubble for BEQ when operand is calculated by LW just before
        if(Branch && RegWrite_1 && MemtoReg_1 && (readRegister1 == writeRegister_I_1
											   || readRegister2 == writeRegister_I_1))
		// Second bubble for BEQ when operand is calculated by LW just before
        if(Branch && RegWrite_2 && MemtoReg_2 && (readRegister1 == writeRegister_2
											   || readRegister2 == writeRegister_2))
		begin
            PCWrite = 0;
            IF_ID_Write = 0;
		end
		// Classic bubble logic for operand being calculated by lw just before
		// it is needed
		else if(MemRead_1 && (writeRegister_I_1 == readRegister1
					  || writeRegister_I_1 == readRegister2))
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
