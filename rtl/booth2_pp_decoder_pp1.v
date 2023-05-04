`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/04 12:43:48
// Module Name: booth2_pp_decoder_pp1
// Description: 产生部分积pp1的专用解码器
//booth算法对于第一个部分积，输入的三位booth编码为{b1,b0,b-1},其中b-1一定为0,故可以使用专用结构来简化电路
//////////////////////////////////////////////////////////////////////////////////


module booth2_pp_decoder_pp1(
        input wire  [2:0]       code_2bit   ,  //原本要输入3bit booth编码,对于一个部分积只需要2bit,最低位编码一定为0
        input wire  [15:0]      A           ,  //被乘数A
        input wire  [15:0]      inversed_A  ,  //取反后的被乘数(-A)
        
        output wire [16:0]      pp_out         //输出的部分积,输出17bit
    );
    
    //flag信号产生的真值表,产生第一个部分积的booth编码的最低位一定是0
    //--------------------------------------------------------------------------
    //|    a    |    b    |    c    |   flag_A   | flag_inv_2xA |  flag_inv_A  |
    //|    0    |    0    |    0    |      0     |      0       |      0       |
    //|    0    |    1    |    0    |      1     |      0       |      0       |
    //|    1    |    0    |    0    |      0     |      1       |      0       |
    //|    1    |    1    |    0    |      0     |      0       |      1       |
    //--------------------------------------------------------------------------
    
    //定义中间变量,实现资源复用
    wire        not_a   ;
    wire        not_b   ;
    
    //部分积标志信号,分别代表A、-A、-2A四种部分积产生情况
    wire        flag_A      ;
    wire        flag_inv_A  ;
    wire        flag_inv_2xA;
    
    //部分积与对应的标志信号相与的中间结果
    //对于A和-A其17bit表达中,最高位[16]和次高位[15]是一样的,无需重复计算,故只需进行16次与运算    
    //注意:与的结果只是与或非门的中间结果,这一结果再通过或非门构成与或非门
    wire [15:0]        and_A      ;  //对应项为A时与门输出,实际上是17bit表达形式中的[15:0]
    wire [15:0]        and_inv_A  ;  //对应项为-A时与门输出,实际上是17bit表达形式中的[15:0]
    
    
    wire [15:0]        nor_A_inv  ;  //对应项为A,-A时使用的或非门输出的结果,实际上是17bit表达形式中的[15:0]
    
    //对于-2A,其17bit表达中最低位[0]一定是0,进行与非运算后结果定为1,无需多余计算
    //-2A这一部分积与对应flag信号进行与非运算的结果
    wire [15:0]        nand_inv_2xA;  //对应项为-2A时与非门输出,实际上是17bit表达形式中的[16:1]
   
    
    //中间变量的产生
    assign      not_a = ~code_2bit[1]   ;
    assign      not_b = ~code_2bit[0]   ;
    
    //部分积标志信号产生,使用或非门
    assign      flag_A          = ~(code_2bit[1] | not_b)       ;
    assign      flag_inv_2xA    = ~(not_a | code_2bit[0])       ;
    assign      flag_inv_A      = ~(not_a | not_b       )       ;
    
    
    //部分积中间数据与对应的标志信号相与的中间结果,实际上是17bit表达形式中的[15:0]
    assign      and_A           = {16{flag_A}} & A                  ;
    assign      and_inv_A       = {16{flag_inv_A}} & inversed_A     ;

    //对应项为A,-A时使用的或非门,这一或非门与前面的与门一起构成与或非门
    //实际上是17bit表达形式中的[15:0],[16]和[15]一样
    assign      nor_A_inv       = ~(and_A | and_inv_A)              ;
 
    //-2A与对应flag_inv_2xA信号进行与非运算,实际上是17bit表达形式中的[16:1],[0]位与非的结果一定是1
    assign      nand_inv_2xA    = ~({16{flag_inv_2xA}} & inversed_A);  
    
    //最后一级使用与非门实现pp_out[16:1],而由于最后nand_inv_2xA实际上对应项一定是1故无需进行与非,直接取非输出即可
    assign      pp_out[16:1]    = ~({nor_A_inv[15],nor_A_inv[15:1]} & nand_inv_2xA);
    assign      pp_out[0]       = ~nor_A_inv[0]  ;

    
    
    
endmodule
