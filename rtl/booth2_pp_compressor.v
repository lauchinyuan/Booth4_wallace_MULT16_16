`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Zhengzhou University
// Author: Lau chinyuan
// Create Date: 2023/04/08 17:24:06
// Module Name: booth2_pp_compressor
// Dependencies: 将16bit乘法器通过Booth2算法产生的8个部分积进行压缩
//使用3:2压缩方案和4:2压缩方案
//////////////////////////////////////////////////////////////////////////////////


module booth2_pp_compressor(
		//8个部分积,这里的部分还未进行移位补零操作，
		//PP1为booth2乘数编码最低位与被乘数相乘而产生的
		//PP8为booth2乘数编码最高位与被乘数相乘而产生的
		//即PP1为做竖式乘法运算由上往下第一行
		input wire [16:0] PP1	,
		input wire [16:0] PP2	,	
		input wire [16:0] PP3	,
		input wire [16:0] PP4	,
		input wire [16:0] PP5	,
		input wire [16:0] PP6	,
		input wire [16:0] PP7	,
		input wire [16:0] PP8	,

		output wire [31:0] PPout1,  //压缩后生成的两个部分积
		output wire [31:0] PPout2
    );
	
	//符号位扩展后部分积
	wire [31:0] PP1_ext;   //经过符号位扩展后的PP1
	wire [29:0] PP2_ext;   //经过符号位扩展后的PP2，最低位暂不补零
	wire [27:0] PP3_ext;   
	wire [25:0] PP4_ext;
	wire [23:0] PP5_ext;
	wire [21:0] PP6_ext;
	wire [19:0] PP7_ext;
	wire [17:0] PP8_ext;
	
	//第一次压缩产生的部分积
	wire [31:0] PPC1_1;  //第一级压缩产生的部分积1
	wire [29:0] PPC1_2;	//第一级压缩产生的部分积2,低位暂未补零
	wire [23:0] PPC1_3;	//第一级压缩产生的部分积3,低位暂未补零
	wire [21:0] PPC1_4;	//第一级压缩产生的部分积4,低位暂未补零
	
	wire [31:0] PPC2_1;//第一级压缩产生的部分积1
	wire [29:0] PPC2_2;//第一级压缩产生的部分积2,低位暂未补零
	
	//4:2压缩器的进位连线
	//第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到26个4:2压缩器
	//有25个cout输出连线，最高位进位输出舍去
	wire [24:0] cout_class1_ppc12; 
	//第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)时用18个4:2压缩器
	wire [16:0] cout_class1_ppc34;
	//第二级压缩用22个4:2压缩器
	wire [20:0]	cout_class2;
	
	
	
	
	
	//符号位扩展,低位暂未补零
	assign PP1_ext = {{15{PP1[16]}},PP1};
	assign PP2_ext = {{13{PP2[16]}},PP2};
	assign PP3_ext = {{11{PP3[16]}},PP3};
	assign PP4_ext = {{9{PP4[16]}},PP4};	
	assign PP5_ext = {{7{PP5[16]}},PP5};
	assign PP6_ext = {{5{PP6[16]}},PP6};	
	assign PP7_ext = {{3{PP7[16]}},PP7};
	assign PP8_ext = {{1{PP8[16]}},PP8};
	
	
	//***************第一级压缩******************//
	
	//第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第1个3:2压缩器
	compressor_3_2 compressor_3_2_class1_ppc12_1 (
		.i0	(PP1_ext[4]),
		.i1	(PP2_ext[2]),
		.ci	(PP3_ext[0]),

		.co	(PPC1_2[3]),
		.d	(PPC1_1[4])
    );
	
	//第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第2个3:2压缩器
	compressor_3_2 compressor_3_2_class1_ppc12_2 (
		.i0	(PP1_ext[5]),
		.i1	(PP2_ext[3]),
		.ci	(PP3_ext[1]),

		.co	(PPC1_2[4]),
		.d	(PPC1_1[5])
    );	
	
	//第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第1个4:2压缩器
	compressor_4_2 compressor_4_2_class1_ppc12_1 (
		.i0	(PP1_ext[6]),
		.i1	(PP2_ext[4]),
		.i2	(PP3_ext[2]),
		.i3	(PP4_ext[0]),
		.ci	(1'b0),  //第一个压缩器的进位输入为0

		.co	(cout_class1_ppc12[0]),
		.c	(PPC1_2[5]),
		.d	(PPC1_1[6])
    );	
	
	
	//第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第i个4:2压缩器
	genvar i;
	generate 
		for(i=7;i<=30;i=i+1) begin: compressor_4_2_class1_ppc12_inst
			compressor_4_2 compressor_4_2_class1_ppc12_i (
					.i0	(PP1_ext[i]),
					.i1	(PP2_ext[i-2]),
					.i2	(PP3_ext[i-4]),
					.i3	(PP4_ext[i-6]),
					.ci	(cout_class1_ppc12[i-7]),  
			
					.co	(cout_class1_ppc12[i-6]),
					.c	(PPC1_2[i-1]),
					.d	(PPC1_1[i])
				);				
		end
	endgenerate
	
	
	//第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的最后个4:2压缩器
	compressor_4_2 compressor_4_2_class1_ppc12_last (
		.i0	(PP1_ext[31]),
		.i1	(PP2_ext[29]),
		.i2	(PP3_ext[27]),
		.i3	(PP4_ext[25]),
		.ci	(cout_class1_ppc12[24]),  //第一个压缩器的进位输入为0

		.co	(),  //超出范围，don't care       
		.c	(),  //超出范围，don't care
		.d	(PPC1_1[31])
    );	
	
	
	//补全部分积1(PPC1_1)和部分积2(PPC1_2)没有用到压缩的位置
	//没有变化的位置
	assign PPC1_1[3:0] = PP1_ext[3:0]; 
	assign PPC1_2[1:0] = PP2_ext[1:0];
	assign PPC1_2[2] = 1'b0; //第一次使用3:2压缩器的位置，进位部分积没有进位
	
	
	
	
	
	//第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第1个3:2压缩器
	compressor_3_2 compressor_3_2_class1_ppc34_1 (
		.i0	(PP5_ext[4]),
		.i1	(PP6_ext[2]),
		.ci	(PP7_ext[0]),

		.co	(PPC1_4[3]),
		.d	(PPC1_3[4])
    );
	
	//第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第2个3:2压缩器
	compressor_3_2 compressor_3_2_class1_ppc34_2 (
		.i0	(PP5_ext[5]),
		.i1	(PP6_ext[3]),
		.ci	(PP7_ext[1]),

		.co	(PPC1_4[4]),
		.d	(PPC1_3[5])
    );	
	
	//第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第1个4:2压缩器
	compressor_4_2 compressor_4_2_class1_ppc34_1 (
		.i0	(PP5_ext[6]),
		.i1	(PP6_ext[4]),
		.i2	(PP7_ext[2]),
		.i3	(PP8_ext[0]),
		.ci	(1'b0),  //第一个压缩器的进位输入为0

		.co	(cout_class1_ppc34[0]),
		.c	(PPC1_4[5]),
		.d	(PPC1_3[6])
    );	
	
	//第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第i个4:2压缩器
	generate 
		for(i=7;i<=22;i=i+1) begin: compressor_4_2_class1_ppc34_inst
			compressor_4_2 compressor_4_2_class1_ppc34_i (
					.i0	(PP5_ext[i]),
					.i1	(PP6_ext[i-2]),
					.i2	(PP7_ext[i-4]),
					.i3	(PP8_ext[i-6]),
					.ci	(cout_class1_ppc34[i-7]),  
			
					.co	(cout_class1_ppc34[i-6]),
					.c	(PPC1_4[i-1]),
					.d	(PPC1_3[i])
				);				
		end
	endgenerate
	
	//第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的最后一个4:2压缩器
	compressor_4_2 compressor_4_2_class1_ppc34_last (
		.i0	(PP5_ext[23]),
		.i1	(PP6_ext[21]),
		.i2	(PP7_ext[19]),
		.i3	(PP8_ext[17]),
		.ci	(cout_class1_ppc34[16]),  //第一个压缩器的进位输入为0

		.co	(),  //超出范围，don't care       
		.c	(),  //超出范围，don't care
		.d	(PPC1_3[23])
    );	
	
	//补全部分积3(PPC1_3)和部分积4(PPC1_4)没有用到压缩的位置
	//没有变化的位置
	assign PPC1_3[3:0] = PP5_ext[3:0]; 
	assign PPC1_4[1:0] = PP6_ext[1:0];
	assign PPC1_4[2] = 1'b0; //第一次使用3:2压缩器的位置，进位部分积没有进位
	
	
	
	//****************************************第二级压缩****************************************//
	
	
	
	//第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第1个3:2压缩器
	compressor_3_2 compressor_3_2_class2_ppc12_1 (
		.i0	(PPC1_1[8]),
		.i1	(PPC1_2[6]),
		.ci	(PPC1_3[0]),

		.co	(PPC2_2[7]),
		.d	(PPC2_1[8])
    );
	
	//第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第2个3:2压缩器
	compressor_3_2 compressor_3_2_class2_ppc12_2 (
		.i0	(PPC1_1[9]),
		.i1	(PPC1_2[7]),
		.ci	(PPC1_3[1]),

		.co	(PPC2_2[8]),
		.d	(PPC2_1[9])
    );
	
	//第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第1个4:2压缩器
	compressor_4_2 compressor_4_2_class2_ppc12_1 (
		.i0	(PPC1_1[10]),
		.i1	(PPC1_2[8]),
		.i2	(PPC1_3[2]),
		.i3	(PPC1_4[0]),
		.ci	(1'b0),  //第一个压缩器的进位输入为0

		.co	(cout_class2[0]),
		.c	(PPC2_2[9]),
		.d	(PPC2_1[10])
    );	
	
	//第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第i个4:2压缩器
	generate 
		for(i=11;i<=30;i=i+1) begin: compressor_4_2_class2_ppc12_inst
			compressor_4_2 compressor_4_2_class1_ppc12_i (
					.i0	(PPC1_1[i]),
					.i1	(PPC1_2[i-2]),
					.i2	(PPC1_3[i-8]),
					.i3	(PPC1_4[i-10]),
					.ci	(cout_class2[i-11]),  
			
					.co	(cout_class2[i-10]),
					.c	(PPC2_2[i-1]),
					.d	(PPC2_1[i])
				);				
		end
	endgenerate
	
	//第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的最后一个4:2压缩器
	compressor_4_2 compressor_4_2_class2_ppc12_last (
		.i0	(PPC1_1[31]),
		.i1	(PPC1_2[29]),
		.i2	(PPC1_3[23]),
		.i3	(PPC1_4[21]),
		.ci	(cout_class2[20]),  //第一个压缩器的进位输入为0

		.co	(),  //超出范围，don't care       
		.c	(),  //超出范围，don't care
		.d	(PPC2_1[31])
    );		

	//补全部分积1(PPC2_1)和部分积2(PPC2_2)没有用到压缩的位置
	//没有变化的位置
	assign PPC2_1[7:0] = PPC1_1[7:0]; 
	assign PPC2_2[5:0] = PPC1_2[5:0];
	//第一次使用3:2压缩器的位置，保留进位部分积没有进位
	assign PPC2_2[6] = 1'b0; 	
	
	
	
	//****************************************输出两个压缩后的部分积****************************************//
	assign PPout1 = PPC2_1;
	assign PPout2 = {PPC2_2,2'b0};
	
endmodule
