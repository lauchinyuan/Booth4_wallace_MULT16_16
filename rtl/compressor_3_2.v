`timescale 1ns / 1ps
//实质上是全加器
module compressor_3_2(
		input wire i0	,
		input wire i1	,
		input wire ci	,
		
		output wire co	,
		output wire d	
    );
	
	assign d = i0 ^ i1 ^ ci;
	assign co = (i0 & i1) | (ci & (i0 | i1));
	
endmodule
