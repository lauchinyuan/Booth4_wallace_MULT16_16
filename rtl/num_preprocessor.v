`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Lau chinyuan
// Create Date: 2023/04/20 18:41:49
// Module Name: num_preprocessor
// Description: 对输入的有符号数进行预处理,在这里通过异或门直接得到结果的最高位
//////////////////////////////////////////////////////////////////////////////////
module num_preprocessor(
	input wire 			A_NUM_sign,
	input wire 			B_NUM_sign,
	
	output wire 		sign
    );
	
	assign sign = A_NUM_sign ^ B_NUM_sign;
endmodule
