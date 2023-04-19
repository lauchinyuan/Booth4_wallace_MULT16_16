`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: booth2_pp_gen 
// Description: 利用booth2算法产生16*16乘法器的8个部分积
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_gen(
		input wire [15:0]	A_NUM	,   //乘数
		input wire [15:0]	B_NUM	, 	//被乘数
		
		//注意:这里产生的部分积并未进行补零操作
		//部分积的最大长度为17位
		output reg [16:0]	PP1		,
		output reg [16:0]	PP2		,
		output reg [16:0]	PP3		,
		output reg [16:0]	PP4		,
		output reg [16:0]	PP5		,
		output reg [16:0]	PP6		,
		output reg [16:0]	PP7		,
		output reg [16:0]	PP8		
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
	
	//部分积由B、-B、0及相应的移位数据产生
	wire [15:0] inversed_B	;  //-1*B
	wire [16:0]	inversed_Bx2;  //-2*B
	assign inversed_B = ~B_NUM + 16'b1; //-1*B
	assign inversed_Bx2 = {inversed_B, 1'b0};
	
	assign B_code1 = {A_NUM[1:0],1'b0}	;
	assign B_code2 = A_NUM[3:1]			;
	assign B_code3 = A_NUM[5:3]			;
	assign B_code4 = A_NUM[7:5]			;
	assign B_code5 = A_NUM[9:7]			;
	assign B_code6 = A_NUM[11:9]		;
	assign B_code7 = A_NUM[13:11]		;
	assign B_code8 = A_NUM[15:13]		;
	
	
	//PP1
	always @ (*) begin
		case(B_code1) 
			3'b000,3'b111: begin
				PP1 = 17'b0;
			end
			3'b001,3'b010: begin
				PP1 = {B_NUM[15],B_NUM};  //B
			end
			3'b011: begin
				PP1 = {B_NUM, 1'b0};  //2B
			end
			3'b100: begin
				PP1 = inversed_Bx2;  //-2B
			end
			default: begin  //3'b101,3'b110
				//符号位扩展
				PP1 = {inversed_B[15], inversed_B}; //-B
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
				PP2 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP2 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP2 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP2 = {inversed_B[15], inversed_B};
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
				PP3 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP3 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP3 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP3 = {inversed_B[15], inversed_B};
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
				PP4 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP4 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP4 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP4 = {inversed_B[15], inversed_B};
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
				PP5 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP5 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP5 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP5 = {inversed_B[15], inversed_B};
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
				PP6 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP6 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP6 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP6 = {inversed_B[15], inversed_B};
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
				PP7 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP7 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP7 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP7 = {inversed_B[15], inversed_B};
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
				PP8 = {B_NUM[15],B_NUM};
			end
			3'b011: begin
				PP8 = {B_NUM, 1'b0};
			end
			3'b100: begin
				PP8 = inversed_Bx2;
			end
			default: begin  //3'b101,3'b110
				PP8 = {inversed_B[15], inversed_B};
			end	
		endcase
	end
	
endmodule
