`timescale 1ns / 1ps

module compressor_4_2(
		input wire i0	,
		input wire i1	,
		input wire i2	,
		input wire i3	,
		input wire ci	,
		
		output wire co	,
		output wire c	,
		output wire d	
    );
	
	assign d = i0 ^ i1 ^ i2 ^ i3 ^ ci;
	assign co = (i0 | i1) & (i2 | i3); 
	assign c = ((i0 ^ i1 ^ i2 ^ i3) & ci) | ~(((i0 ^ i1 ^ i2 ^ i3) | ~((i0 & i1) | (i2 & i3))));
	
endmodule
