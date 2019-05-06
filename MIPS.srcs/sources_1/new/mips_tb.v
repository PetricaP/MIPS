`timescale 1ns / 1ps

module mips_tb;
	reg res;
	reg clk;
	
	mips mps(res, clk);
	
	initial
		forever #5 clk = ~clk;
		
	initial
	begin
		#0 clk = 0; res = 0;
		#5000 $finish;
	end
endmodule
