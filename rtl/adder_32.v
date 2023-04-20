`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 19:48:06
// Module Name: adder_32
// Dependencies: 32bit adder with input sign signal
//////////////////////////////////////////////////////////////////////////////////
module adder_32(
		input wire 	[30:0] 	A		,
		input wire 	[30:0] 	B		,
		input wire 			sign	,
		
		output wire	[31:0] 	C		
    );
	
	//各级产生的进位
	wire [29:0] cout_adder_32bit;
	
	//最低位使用半加器
	half_adder half_adder_32bit_0(
		.a		(A[0])					,
		.b		(B[0])					,

		.cout	(cout_adder_32bit[0])	,
		.sum	(C[0])
    );
	
	genvar i ;
	generate
		for(i = 1;i <= 29;i = i + 1) begin: adder_32_full_adder_inst
			//3:2压缩器实质上是全加器
			compressor_3_2 full_adder(
				.i0	(A[i]),
				.i1	(B[i]),
				.ci	(cout_adder_32bit[i-1]),

				.co	(cout_adder_32bit[i]),
				.d	(C[i])
			);
		end

	endgenerate
	
	compressor_3_2 full_adder_msb(
				.i0	(A[30]),
				.i1	(B[30]),
				.ci	(cout_adder_32bit[29]),

				.co	(  ), //don't care
				.d	(C[30])
			);
	
	assign C[31] = sign;
	

	
endmodule
