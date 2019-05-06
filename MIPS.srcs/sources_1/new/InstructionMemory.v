`timescale 1ns / 1ps

module InstructionMemory(address, dataOut);
	input [31:0] address;
	output [31:0] dataOut;
	
	reg [31:0] memory[0:1<<32 - 1];
	
	initial
		$readmemh("program.mem", memory, 32'h400000 >> 2);

	assign dataOut = memory[address >> 2];
endmodule
