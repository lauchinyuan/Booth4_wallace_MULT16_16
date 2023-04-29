`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/27 20:16:15
// Module Name: booth2_pp_decoder
// Description: 依据输入的3bit booth Radix-4乘数编码,解码部分积输出
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_decoder(
		input wire	[2:0] 		code		,  //输入的3bit编码
		input wire	[15:0]		A	  		,  //被乘数A
		input wire  [15:0]		inversed_A	,  //取反后的被乘数(-A)
		
		output wire [16:0]		pp_out		   //输出的部分积,输出17bit
    );
	
	//定义中间变量是为了实现资源复用
	wire 		xor_0_1		; //中间变量,xor_0_1 = code[0] ^ code[1]
	wire		not_xor_0_1	; //中间变量,not_xor_0_1 = ~xor_0_1
	wire		not_2		; //中间变量,not_2 = ~code[2]
	wire		not_1		; //中间变量,not_1 = ~code[1]
	
	//标志信号,分别代表A、-A、2A、-2A四种部分积产生情况
	wire 		flag_A		;   //部分积为A
	wire		flag_inv_A	;	//部分积为-A
	wire		flag_2xA	;	//部分积为2A
	wire		flag_inv_2xA;	//部分积为-2A
	
	//产生的标志信号和A相与得到对应项
	//由于产生的17位部分积2A -2A最低位一定为0,其与另一数相与必为0
	//17位部分积A、-A的最高位与次高位相同,无需重复对其使用与门
	//故这里定义的数据位宽均为16bit,四个对应项共节省了4个与门
	wire 	[15:0]	and_A		;   //对应项为A
	wire	[15:0]	and_inv_A	;	//对应项为-A
	wire	[15:0]	and_2xA		;	//对应项为2A
	wire	[15:0]	and_inv_2xA	;	//对应项为-2A	
	
	
	//中间变量产生
	assign xor_0_1 = code[0] ^ code[1];
	assign not_xor_0_1 = ~xor_0_1;
	assign not_2 = ~code[2];
	assign not_1 = ~code[1];
	
	//标志信号产生
	//使用或非门实现
	assign flag_A 		= ~(code[2] | not_xor_0_1);
	assign flag_inv_A 	= ~(not_2 	| not_xor_0_1);
	assign flag_2xA		= (~(code[2] | xor_0_1)) & code[1];
	assign flag_inv_2xA = (~(not_2 	| xor_0_1)) & not_1;
	
	//对应项产生
	//这里产生的实际上是A[15:0]以及-A[15:0],连接到后面或门时需要补符号位
	assign and_A 		= {16{flag_A}} & A;
	assign and_inv_A 	= {16{flag_inv_A}} & inversed_A;
	
	//这里产生的实际上是2A[16:1]以及-2A[16:1],连接到后面或门时需要错开一位
	assign and_2xA		= {16{flag_2xA}} & A;   
	assign and_inv_2xA  = {16{flag_inv_2xA}} & inversed_A;
	
	//部分积最低位,对于2A及-2A一定为0,don't care
	assign pp_out[0] = and_A[0] | and_inv_A[0]; 
	
	//部分积中间位
	genvar i;
	generate
		for(i=1;i<=15;i=i+1) begin
			assign pp_out[i] = and_A[i] | and_inv_A[i] | and_2xA[i-1] | and_inv_2xA[i-1];
		end
	endgenerate
	
	//部分积最高位
	assign pp_out[16] = and_A[15] | and_inv_A[15] | and_2xA[15] | and_inv_2xA[15];
	
endmodule
