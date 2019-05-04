`timescale 1ns / 1ps

module HazardDetectionUnit(readRegister1, readRegister2, MemRead_1,
						   writeRegister_I_1, Branch, Branch_1, RegWrite_1,
						   MemtoReg_1, writeRegister_R_1, RegWrite_2,
						   writeRegister_2, MemtoReg_2, compareResult,
						   Jump,
						   PCWrite, IF_ID_Write, ControlSrc, IF_Flush);
	// readRegister1 and readRegister2 are values read directly
	// from the IF/ID registers
	
    input [4:0] readRegister1;
    input [4:0] readRegister2;
    input MemRead_1;
    input [4:0] writeRegister_I_1;
	input Branch;
	input Branch_1;
	input RegWrite_1;
	input MemtoReg_1;
	input [4:0] writeRegister_R_1;
	input RegWrite_2;
	input [4:0] writeRegister_2;
	input MemtoReg_2;
	input compareResult;
	input Jump;
    output reg PCWrite;
    output reg IF_ID_Write;
    output reg ControlSrc;
    output reg IF_Flush;

	initial
	begin
		PCWrite = 1;
		IF_ID_Write = 1;
		ControlSrc = 1;
		IF_Flush = 0;
	end
    
    always @(readRegister1 or readRegister2 or Branch
             or MemRead_1 or writeRegister_I_1
			 or Branch or RegWrite_1 or RegWrite_2
			 or MemtoReg_1 or MemtoReg_2 or Branch_1 or compareResult)
    begin
		// Bubble for BEQ when operand is calculated by RTYPE just before
        if((Branch && RegWrite_1 && (readRegister1 == writeRegister_I_1
								  || readRegister2 == writeRegister_I_1
							  	  || readRegister1 == writeRegister_R_1
								  || readRegister2 == writeRegister_R_1))
		// First bubble for BEQ when operand is calculated by LW just before
        || (Branch && RegWrite_1 && MemtoReg_1 && writeRegister_2 != 0
                                               && (readRegister1 == writeRegister_I_1
											    || readRegister2 == writeRegister_I_1))
		// Second bubble for BEQ when operand is calculated by LW just before
        || (Branch && RegWrite_2 && MemtoReg_2 && writeRegister_2 != 0
                                               && (readRegister1 == writeRegister_2
											    || readRegister2 == writeRegister_2)))
		begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ControlSrc = 1;
		end
        // Classic bubble logic for operand being calculated by lw just before
		// it is needed
		else if(MemRead_1 && writeRegister_I_1 != 0
                && (writeRegister_I_1 == readRegister1
                    || writeRegister_I_1 == readRegister2))
        begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ControlSrc = 0;
        end
        else
        begin
            // Invalidate previous instruction if we jump elsewhere
            // But still write PC
            if((Branch && !Branch_1 && compareResult))
                IF_Flush = 1;
            else
                if(!Jump)
                    IF_Flush = 0;
            IF_ID_Write = 1;
            PCWrite = 1;
            ControlSrc = 1;
        end
    end
    
    always @(Jump)
        if(Jump)
            IF_Flush = 1;
        else
            IF_Flush = 0;
endmodule
