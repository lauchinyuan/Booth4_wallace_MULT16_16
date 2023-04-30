`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: booth2_pp_gen 
// Description: 利用booth2算法产生16*16乘法器的8个部分积
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_gen(
		input wire [15:0]	A_NUM	,   //被乘数
		input wire [15:0]	B_NUM	, 	//乘数
		
		//注意:这里产生的部分积并未进行补零操作
		//部分积的最大长度为17位
		output wire [16:0]	PP1		,
		output wire [16:0]	PP2		,
		output wire [16:0]	PP3		,
		output wire [16:0]	PP4		,
		output wire [16:0]	PP5		,
		output wire [16:0]	PP6		,
		output wire [16:0]	PP7		,
		output wire [16:0]	PP8		
    );
	//用于产生8个部分积的编码
	wire [2:0] 	B_code1	;
	wire [2:0]	B_code2	;
	wire [2:0]	B_code3	;
	wire [2:0]	B_code4	;
	wire [2:0]	B_code5	;
	wire [2:0]	B_code6	;
	wire [2:0]	B_code7	;
	wire [2:0]	B_code8	;
	
	//部分积由-1*A
	wire [15:0] inversed_A	;  //-1*A
	
	
	//产生-1*A,使用专用的电路,而不使用加法器,减少资源开销
	inv_converter_16 inv_converter_16_inst(
		.data_i	(A_NUM),//输入数据

		.inv_o	(inversed_A) //输出相反数
    );
	
	assign B_code1 = {B_NUM[1:0],1'b0}	;
	assign B_code2 = B_NUM[3:1]			;
	assign B_code3 = B_NUM[5:3]			;
	assign B_code4 = B_NUM[7:5]			;
	assign B_code5 = B_NUM[9:7]			;
	assign B_code6 = B_NUM[11:9]		;
	assign B_code7 = B_NUM[13:11]		;
	assign B_code8 = B_NUM[15:13]		;
	
	//通过例化8个booth2_pp_decoder模块得到8个部分积
	//PP1
	booth2_pp_decoder booth2_pp_decoder_pp1(
		.code		(B_code1			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP1				)   //输出的部分积,输出17bit
    );

	//PP2
	booth2_pp_decoder booth2_pp_decoder_pp2(
		.code		(B_code2			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP2				)   //输出的部分积,输出17bit
    );

	//PP3
	booth2_pp_decoder booth2_pp_decoder_pp3(
		.code		(B_code3			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP3				)   //输出的部分积,输出17bit
    );

	//PP4
	booth2_pp_decoder booth2_pp_decoder_pp4(
		.code		(B_code4			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP4				)   //输出的部分积,输出17bit
    );

	//PP5
	booth2_pp_decoder booth2_pp_decoder_pp5(
		.code		(B_code5			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP5				)   //输出的部分积,输出17bit
    );

	//PP6
	booth2_pp_decoder booth2_pp_decoder_pp6(
		.code		(B_code6			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP6				)   //输出的部分积,输出17bit
    );

	//PP7
	booth2_pp_decoder booth2_pp_decoder_pp7(
		.code		(B_code7			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP7				)   //输出的部分积,输出17bit
    );

	//PP8
	booth2_pp_decoder booth2_pp_decoder_pp8(
		.code		(B_code8			),  //输入的3bit编码
		.A	  		(A_NUM				),  //被乘数A
		.inversed_A	(inversed_A			),  //取反后的被乘数(-A)

		.pp_out		(PP8				)   //输出的部分积,输出17bit
    );	
	
/* 	//PP1
	always @ (*) begin
		case(B_code1) 
			3'b000,3'b111: begin
				PP1 = 17'b0;
			end
			3'b001,3'b010: begin
				PP1 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP1 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP1 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP1 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end

	//PP2
	always @ (*) begin
		case(B_code2) 
			3'b000,3'b111: begin
				PP2 = 17'b0;
			end
			3'b001,3'b010: begin
				PP2 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP2 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP2 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP2 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end
	
	//PP3
	always @ (*) begin
		case(B_code3) 
			3'b000,3'b111: begin
				PP3 = 17'b0;
			end
			3'b001,3'b010: begin
				PP3 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP3 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP3 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP3 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end

	//PP4
	always @ (*) begin
		case(B_code4) 
			3'b000,3'b111: begin
				PP4 = 17'b0;
			end
			3'b001,3'b010: begin
				PP4 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP4 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP4 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP4 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end
	
	//PP5
	always @ (*) begin
		case(B_code5) 
			3'b000,3'b111: begin
				PP5 = 17'b0;
			end
			3'b001,3'b010: begin
				PP5 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP5 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP5 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP5 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end

	//PP6
	always @ (*) begin
		case(B_code6) 
			3'b000,3'b111: begin
				PP6 = 17'b0;
			end
			3'b001,3'b010: begin
				PP6 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP6 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP6 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP6 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end

	//PP7
	always @ (*) begin
		case(B_code7) 
			3'b000,3'b111: begin
				PP7 = 17'b0;
			end
			3'b001,3'b010: begin
				PP7 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP7 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP7 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP7 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end
	
	//PP8
	always @ (*) begin
		case(B_code8) 
			3'b000,3'b111: begin
				PP8 = 17'b0;
			end
			3'b001,3'b010: begin
				PP8 = {A_NUM[15],A_NUM};  //A
			end
			3'b011: begin
				PP8 = {A_NUM, 1'b0};  //2A
			end
			3'b100: begin
				PP8 = inversed_Ax2;  //-2A
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP8 = {inversed_A[15], inversed_A}; //-A
			end	
		endcase
	end */
	
	
endmodule
