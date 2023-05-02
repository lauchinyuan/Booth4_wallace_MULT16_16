`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/27 20:16:15
// Module Name: booth2_pp_decoder
// Description: 依据输入的3bit booth Radix-4乘数编码,解码部分积输出
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_decoder(
        input wire  [2:0]       code        ,  //输入的3bit编码
        input wire  [15:0]      A           ,  //被乘数A
        input wire  [15:0]      inversed_A  ,  //取反后的被乘数(-A)
        
        output wire [16:0]      pp_out         //输出的部分积,输出17bit
    );
    
    //定义中间变量是为了实现资源复用
    wire        xor_0_1     ; //中间变量,xor_0_1 = code[0] ^ code[1]
    wire        not_xor_0_1 ; //中间变量,not_xor_0_1 = ~xor_0_1
    wire        not_2       ; //中间变量,not_2 = ~code[2]
    wire        not_1       ; //中间变量,not_1 = ~code[1]
    
    //标志信号,分别代表A、-A、2A、-2A四种部分积产生情况
    wire        flag_A      ;   //部分积为A
    wire        flag_inv_A  ;   //部分积为-A
    wire        flag_2xA    ;   //部分积为2A
    wire        flag_inv_2xA;   //部分积为-2A
    
    //产生的标志信号和对应的项通过与或非门运算得到对应项
    //分为两级进行计算,与门&或非门,或非门的两个输入是与门的输出,故两者共同组成“与或非门”

    
    //由于产生的17位部分积2A -2A最低位一定为0,其与另一数相与必为0
    //17位部分积A、-A的最高位与次高位相同,无需重复对其使用与门
    //故这里定义的数据位宽均为16bit,四个对应项共节省了4个与门
    wire    [15:0]  and_A       ;   //对应项为A时与门输出
    wire    [15:0]  and_inv_A   ;   //对应项为-A时与门输出
    wire    [15:0]  and_2xA     ;   //对应项为2A时与门输出
    wire    [15:0]  and_inv_2xA ;   //对应项为-2A时与门输出
    
    //由于产生的17位部分积2A -2A最低位一定为0,通过与或非门后的输出一定是1,无需对其进行计算,后续直接补1即可
    //17位部分积A、-A的最高位与次高位相同,无需重复对其使用或非门
    //综上,部分积2A -2A的对应位是对齐的,A -A的对应位是对齐的,在使用或非门时要求位对齐的在一起运算
    //综上,一共节省了2个与或非门
    wire    [15:0]  nor_A_inv       ;   //对应项为A或者-A时或非门输出
    wire    [15:0]  nor_2xA_inv     ;   //对应项为2A时或非门输出
    
    //中间变量产生
    assign xor_0_1 = code[0] ^ code[1];
    assign not_xor_0_1 = ~xor_0_1;
    assign not_2 = ~code[2];
    assign not_1 = ~code[1];
    
    //译码,标志信号产生
    //使用或非门结合与门实现
    assign flag_A       = ~(code[2] | not_xor_0_1);
    assign flag_inv_A   = ~(not_2   | not_xor_0_1);
    assign flag_2xA     = (~(code[2] | xor_0_1)) & code[1];
    assign flag_inv_2xA = (~(not_2  | xor_0_1)) & not_1;
    
    //与门对应项产生
    //这里产生的实际上是A[15:0]以及-A[15:0]
    assign and_A        = {16{flag_A}} & A;
    assign and_inv_A    = {16{flag_inv_A}} & inversed_A;
    
    //这里产生的实际上是2A[16:1]以及-2A[16:1]
    assign and_2xA      = {16{flag_2xA}} & A;   
    assign and_inv_2xA  = {16{flag_inv_2xA}} & inversed_A;
    
    //或非门对应项输出,亦即是与门与或非门组成的与或非门的输出
    //这里产生的实际上是与或非门输出数据的[15:0],[16]和[15]相同,位扩充即可
    assign nor_A_inv = ~(and_A | and_inv_A);
    
    //这里产生的实际上是与或非门输出数据的[16:1],最低位一定为1,不必运算
    assign nor_2xA_inv = ~(and_2xA | and_inv_2xA);
    
    //输出pp_out[0]的产生直接使用非门实现,与非门的一个输入一定为1,等效为非门
    assign pp_out[0] = ~nor_A_inv[0]; 
    
    //16个与非门(NAND gate)实现pp_out[16:1]
    //注意nor_A_inv需要将次高位复制给最高位
    assign pp_out[16:1] = ~({nor_A_inv[15],nor_A_inv[15:1]} & nor_2xA_inv);
    
endmodule
