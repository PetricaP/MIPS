`timescale 1ns / 1ps

`define ALU_ADD 4'b0010
`define ALU_SUB 4'b0110
`define ALU_AND 4'b0000
`define ALU_OR  4'b0001
`define ALU_SLT 4'b0111
`define ALU_NOR 4'b1100

module mips(res, clk);
    input res;
    input clk;
    
    // Instruction memory and PC
    reg [31:0] PC;
    wire [31:0] instructionMemoryOut;
    
    InstructionMemory IRMem(PC, instructionMemoryOut);
    
    // Control signals
    wire PCSrc;
    wire RegDst;
    wire [1:0] ALUOp;
    wire Jump;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    
    wire BranchNot;
    
    // First pipeline stage registers
    reg [31:0] PCPlus4_0;
    reg [31:0] instructionRegister_0;
    
    // Second pipeline stage registers
    reg MemRead_1;
    reg MemWrite_1;
    reg MemtoReg_1;
    reg Branch_1;
    reg RegDst_1;
    reg [1:0] ALUOp_1;
    reg ALUSrc_1;
    reg [31:0] PCPlus4_1;
    reg [31:0] readData1_1;
    reg [31:0] readData2_1;
    reg [31:0] imm32_1;
    reg [4:0] writeRegister_R_1;
    reg [4:0] writeRegister_I_1;
    reg [4:0] readRegister1_1;
    reg [4:0] readRegister2_1;
    reg RegWrite_1;
    
    reg PCSrc_1;
    
    // Third pipeline stage registers
    reg [4:0] writeRegister_2;
    reg MemRead_2;
    reg MemWrite_2;
    reg MemtoReg_2;
    reg RegWrite_2;
    reg [31:0] readData2_2;
    reg Branch_2;
    reg [31:0] ALUOut_2;
    reg Zero_2;
    
    reg IF_Flush_1;
    
    // Fourth pipeline stage registers
    reg [4:0] writeRegister_3;
    reg RegWrite_3;
    reg MemtoReg_3;
    reg [31:0] memoryReadData_3;
    reg [31:0] ALUOut_3;
    
    // Forwarding wires
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

	// Forwarding wires for compare operation
	wire [1:0] ForwardCA;
	wire [1:0] ForwardCB;
	
	// Wires for Branching
	wire [31:0] compareOperand1;
	wire [31:0] compareOperand2;
	wire compareResult;
    
    // Hazard detection wires
    wire PCWrite;
    wire IF_ID_Write;
    wire ControlSrc;
    wire IF_Flush;

    // Useful instruction wires
    wire [5:0] opcode;
    wire [4:0] readRegister1;
    wire [4:0] readRegister2;
    wire [4:0] writeRegister_I;
    wire [4:0] writeRegister_R;
    wire [15:0] imm16;
    wire [5:0] shamt;
    
    assign opcode = instructionRegister_0[31:26];
    assign imm16 = instructionRegister_0[15:0];
    assign shamt = instructionRegister_0[5:0];
    assign writeRegister_I = instructionRegister_0[20:16];
    assign writeRegister_R = instructionRegister_0[15:11];  
    
    // Initial read registers
    wire [4:0] initialReadRegister1;
    wire [4:0] initialReadRegister2;
    
    assign initialReadRegister1 = instructionRegister_0[25:21];
    assign initialReadRegister2 = instructionRegister_0[20:16];
    
    // If there is a pipeline stall set readRegisters to $zero and $zero
    assign readRegister1 = (ControlSrc) ? initialReadRegister1 : 5'b00000; // $zero
    assign readRegister2 = (ControlSrc) ? initialReadRegister2 : 5'b00000; // $zero
    
    // Control module
    Control control(opcode, RegDst, Jump, Branch, MemRead, MemtoReg,
                    ALUOp, MemWrite, ALUSrc, RegWrite, BranchNot);
    
    // Register values
    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;
    
    RegisterFile regFile(clk, readRegister1, readRegister2, RegWrite_3,
                         writeRegister_3, writeData, readData1, readData2);
    
    assign writeData = (MemtoReg_3) ? memoryReadData_3 : ALUOut_3;
    
    // Model Address ALU
    wire [31:0] addressALUOut;
    
    assign addressALUOut = PCPlus4_1 + (imm32_1 << 2);

    // Model main ALU
    wire [31:0] operand1 = (ForwardA == 2'b10) ? ALUOut_2
                         : (ForwardA == 2'b01) ? writeData
                         : readData1_1;
 
    wire [31:0] operand2 = (ForwardB == 2'b10) ? ALUOut_2
                         : (ForwardB == 2'b01) ? writeData
                         : (ALUSrc_1) ? imm32_1 : readData2_1;
    wire Zero;
    reg [31:0] ALUOut;
    wire [3:0] ALUCode;
    
    wire [5:0] ALUControlBits;

    always @(operand1 or operand2 or ALUCode)
    casex(ALUCode)
        `ALU_AND:    ALUOut = operand1 & operand2;
        `ALU_OR :    ALUOut = operand1 | operand2;
        `ALU_ADD:    ALUOut = operand1 + operand2;
        `ALU_SUB:    ALUOut = operand1 - operand2;
        `ALU_SLT:    ALUOut = operand1 < operand2;
        `ALU_NOR:    ALUOut = ~(operand1 | operand2);
        default:    ALUOut = 0;
    endcase
    
    assign Zero = (ALUOut == 0);
    
    assign ALUControlBits = imm32_1[5:0];
    
    ALUControl aluControl(ALUOp_1, ALUControlBits, ALUCode);
   
    // Model Data memory
    wire [31:0] memoryReadData;

    DataMemory dataMemory(ALUOut_2, readData2_2, MemRead_2, MemWrite_2, memoryReadData);
    
    // Forwarding Unit with necessary inputs and outputs
    ForwardingUnit forwardingUnit(readRegister1_1, readRegister2_1, RegWrite_2,
                                  writeRegister_2, RegWrite_3, writeRegister_3,
                                  initialReadRegister1, initialReadRegister2, Branch, MemtoReg_3,
                                  ForwardA, ForwardB, ForwardCA, ForwardCB);
                                  
    // Hazard Detection Unit necessary inputs and outputs
	HazardDetectionUnit hazardDetectionUnit(initialReadRegister1, initialReadRegister2, MemRead_1,
										    writeRegister_I_1, Branch, Branch_1, RegWrite_1,
										    MemtoReg_1, writeRegister_R_1, RegWrite_2,
										    writeRegister_2, MemtoReg_2, compareResult,
										    PCWrite, IF_ID_Write, ControlSrc, IF_Flush);
	
	// BEQ compare logic
	assign compareOperand1 = (ForwardCA == 2'b10) ? ALUOut_2
	                       : (ForwardCA == 2'b01) ? memoryReadData_3
	                       : readData1;
	                       
    assign compareOperand2 = (ForwardCB == 2'b10) ? ALUOut_2
	                       : (ForwardCB == 2'b01) ? memoryReadData_3
	                       : readData2;
	                       
	assign compareResult = (compareOperand1 == compareOperand2) ^ BranchNot;
	
	assign PCSrc = compareResult && Branch;
	
    initial
    begin
        PC <= 0;
        Zero_2 <= 0;
        Branch_2 <= 0;
        Branch_1 <= 0;
        instructionRegister_0 <= 0;
        RegWrite_1 <= 0;
        RegWrite_2 <= 0;
        RegWrite_3 <= 0;
        writeRegister_R_1 <= 0;
        writeRegister_I_1 <= 0;
        MemRead_1 <= 0;
        PCSrc_1 <= 0;
        IF_Flush_1 <= 0;
        PCPlus4_1 <= 0;
    end
    
    // Synchrone parts
    always @(posedge clk)
    begin
    
        if(res)
            PC <= 0;
        else
        // Update PC
            if(PCWrite)
                PC <= (PCSrc_1) ? addressALUOut : (PC + 4);
    
        // Update first pipeline stage IF/ID
        if(IF_ID_Write)
        begin
            PCSrc_1 <= PCSrc;
            if(IF_Flush || IF_Flush_1)
                instructionRegister_0 <= 32'h00000020;
            else
                instructionRegister_0 <= instructionMemoryOut;
                PCPlus4_0 <= PC + 4;
        end
        
        // Update second pipeline stage ID/EX
        PCPlus4_1 <= PCPlus4_0;
        readData1_1 <= readData1;
        readData2_1 <= readData2;
        imm32_1 <= {{16{imm16[15]}},imm16};
        writeRegister_I_1 <= writeRegister_I;
        PCPlus4_1 <= PCPlus4_0;
        readRegister1_1 <= readRegister1;
        readRegister2_1 <= readRegister2;

        IF_Flush_1 <= IF_Flush;
        
        if(ControlSrc)
        begin
            // Non-stall instructions
            writeRegister_R_1 <= writeRegister_R;
            
            {RegDst_1, ALUSrc_1, MemtoReg_1, RegWrite_1, MemRead_1, MemWrite_1, Branch_1, ALUOp_1} <=
            {RegDst  , ALUSrc  , MemtoReg  , RegWrite  , MemRead  , MemWrite  , Branch  , ALUOp  };
        end
        else
        begin
            // Begin a pipeline stall (bubble)
            // Simmulate add $zero, $zero, $zero
            // Setting all control signals for rtype except ALUOp which we set to 00 for addition
            {RegDst_1, ALUSrc_1, MemtoReg_1, RegWrite_1, MemRead_1, MemWrite_1, Branch_1, ALUOp_1} <= 9'b1_0_0_1_0_0_0_00;
            
            // Setting write register to $zero
            writeRegister_R_1 <= 5'b00000;         
        end
        
        // Update third pipeline stage EX/MEM
        writeRegister_2 <= (RegDst_1) ? writeRegister_R_1 : writeRegister_I_1;
        MemRead_2 <= MemRead_1;
        MemWrite_2 <= MemWrite_1;
        MemtoReg_2 <= MemtoReg_1;
        readData2_2 <= readData2_1;
        Branch_2 <= Branch_1;
        RegWrite_2 <= RegWrite_1;
        ALUOut_2 <= ALUOut;
        Zero_2 <= Zero;
        
        // Update fourth pipeline stage MEM/WB
        writeRegister_3 <= writeRegister_2;
        RegWrite_3 <= RegWrite_2;
        MemtoReg_3 <= MemtoReg_2;
        memoryReadData_3 <= memoryReadData;
        ALUOut_3 <= ALUOut_2;
    end
endmodule
