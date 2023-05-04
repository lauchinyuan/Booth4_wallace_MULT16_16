`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/04 16:26:03
// Module Name: tb_booth2_pp_decoder_pp1
// Dependencies: testbench for booth2_pp_decoder_pp1 module
//////////////////////////////////////////////////////////////////////////////////
module tb_booth2_pp_decoder_pp1(

    );
    
    reg [2:0]       code_2bit       ;
    reg [15:0]      A               ;
    reg [15:0]      inversed_A      ;
    
    wire [16:0]     pp_out          ;
    
    initial begin
        A <= 16'b0101_1100_0000_1011;
        inversed_A <= 16'b1010_0011_1111_0101;
        code_2bit <= 2'b00;
    #20
        code_2bit <= 2'b01;
    #20 
        code_2bit <= 2'b10;
    #20
        code_2bit <= 2'b11;
    end
    
    booth2_pp_decoder_pp1 booth2_pp_decoder_pp1_inst(
        .code_2bit   (code_2bit ),  //原本要输入3bit booth编码,对于一个部分积只需要2bit,最低位编码一定为0
        .A           (A         ),  //被乘数A
        .inversed_A  (inversed_A),  //取反后的被乘数(-A)

        .pp_out      (pp_out    )   //输出的部分积,输出17bit
    );
endmodule
