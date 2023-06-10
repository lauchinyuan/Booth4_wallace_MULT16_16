`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Create Date: 2023/04/09 20:42:50
// Module Name: tb_mult_16_16_top
// Description: testbench for mult_16_16_top module
//////////////////////////////////////////////////////////////////////////////////
module tb_mult_16_16_top();
    reg  signed [15:0]  A_NUM   ;
    reg  signed [15:0]  B_NUM   ;
    wire        [31:0]  C_NUM   ;
    wire signed [31:0]  C_NUM_real;  //计算结果的真实值
    wire                correct ;    //计算结果正确标志
    
    //遍历所有可能的输入情况
    //16bit有符号数的范围为[-32768,32767]
    integer i,j;
    initial begin
        //初始值给定一个随机数
        A_NUM <= $random;
        B_NUM <= $random;
        //遍历一轮数据需要操作进行(2^16 - 1)=65535次自增1运算
        for(i=0;i<=65535;i=i+1) begin
            for(j=0;j<=65535;j=j+1) begin
                //延时放在语句后面,使得A_NUM和B_NUM能同时变化
                #20
/*                 A_NUM <= i - 16'd32768; //A_NUM从-32768开始自增
                B_NUM <= j - 16'd32768; //B_NUM从-32768开始自增 */
                A_NUM <= $random;
                B_NUM <= $random;             
            end
        end
    end
    
    //正确结果
    assign C_NUM_real = A_NUM * B_NUM;
    
    //计算结果正确标志
    assign correct = (C_NUM_real == C_NUM);
    
    //模块例化
    mult_16_16_top mult_16_16_top_inst(
        .A_NUM  (A_NUM),    //乘数
        .B_NUM  (B_NUM),    //被乘数

        .C_NUM  (C_NUM)     //积
    );
    
endmodule
