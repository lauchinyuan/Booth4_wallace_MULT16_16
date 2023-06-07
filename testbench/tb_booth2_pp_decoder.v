`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email : lauchinyuan@yeah.net
// Create Date: 2023/04/27 21:51:06
// Module Name: tb_booth2_pp_decoder
// Description: testbench for booth2_pp_decoder
//////////////////////////////////////////////////////////////////////////////////
module tb_booth2_pp_decoder();
    reg [2:0]       code        ;
    reg [15:0]      A           ;
    reg [16:0]      inversed_A  ;
    
    wire [17:0]     pp_out_inv_s    ;
    wire [17:0]     pp_out          ;
    
    initial begin
        A <= 16'b0101_1100_0000_1011;
        inversed_A <= 17'b1_1010_0011_1111_0101;
        code <= 3'b000;
    #20
        code <= 3'b001;
    #20 
        code <= 3'b010;
    #20
        code <= 3'b011;
    #20 
        code <= 3'b100;
    #20
        code <= 3'b101;
    #20 
        code <= 3'b110;
    #20
        code <= 3'b111;
    #20
        A <= 16'h8000;  //测试当A为表示范围下界的情况
        inversed_A <= 17'h08000; //将A符号位扩展到17bit后按位取反,末位加一
        code <= 3'b000;
    #20
        code <= 3'b001;
    #20 
        code <= 3'b010;
    #20
        code <= 3'b011;
    #20 
        code <= 3'b100;
    #20
        code <= 3'b101;
    #20 
        code <= 3'b110;
    #20
        code <= 3'b111;       
    end
    

    booth2_pp_decoder booth2_pp_decoder_inst(
            .code           (code       ),  //输入的3bit编码
            .A              (A          ),  //被乘数A
            .inversed_A     (inversed_A ),  //取反后的被乘数(-A)

            .pp_out         (pp_out_inv_s)   //输出的部分积,输出17bit
        );
        
    //将符号位反逻辑输出转换为正逻辑输出,以方便在仿真工具中观察数据正确性
    assign pp_out = {~pp_out_inv_s[17],pp_out_inv_s[16:0]};
    
    
endmodule
