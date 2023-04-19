`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Create Date: 2023/04/09 20:42:50
// Module Name: tb_mult_16_16_top
// Description: testbench for mult_16_16_top module
//////////////////////////////////////////////////////////////////////////////////
module tb_mult_16_16_top();
	reg [15:0]	A_NUM	;
	reg [15:0]	B_NUM	;
	
	wire [31:0]	C_NUM	;
	integer i;
	initial begin
		A_NUM <= 16'h3524;  
		B_NUM <= 16'h5e81;  
	#20
		for(i=0;i<=100;i=i+1) begin
			#20
			A_NUM = $random;
			B_NUM = $random;
			
		end

		
/* 	#20
		B_NUM <= 16'b1111_1010_1100_1000;
	#20
		B_NUM <= 16'b0111_1010_1100_1000;
		
	#20
		B_NUM <= 16'b1111_1010_0000_0001;
	#20
		B_NUM <= 16'b0111_1010_0000_1000; */
		
	end
	
	mult_16_16_top mult_16_16_top_inst(
		.A_NUM	(A_NUM),   	//乘数
		.B_NUM	(B_NUM), 	//被乘数

		.C_NUM	(C_NUM)		//积
    );
	
endmodule
