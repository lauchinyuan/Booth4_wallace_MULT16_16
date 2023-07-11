`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email: lauchinyuan@yeah.net
// Create Date: 2023/07/11 19:13:27
// Module Name: tb_mult_8_8_top
// Description: testbench for mult_8_8_top module
//////////////////////////////////////////////////////////////////////////////////
module tb_mult_8_8_top();

    reg  signed [7:0]   A_NUM   ;
    reg  signed [7:0]   B_NUM   ;
    wire        [15:0]  C_NUM   ;
    wire signed [15:0]  C_NUM_real;  //计算结果的真实值
    wire                correct ;    //计算结果正确标志
    
    //遍历所有可能的输入情况
    //8bit有符号数的范围为[-128,127]
    integer i,j;
    initial begin
        //初始值给定一个随机数
        A_NUM <= $random;
        B_NUM <= $random;
        //遍历一轮数据需要操作进行(2^8 - 1)=255次自增1运算
        for(i=0;i<=255;i=i+1) begin
            for(j=0;j<=255;j=j+1) begin
                //延时放在语句后面,使得A_NUM和B_NUM能同时变化
                #20
                A_NUM <= i - 8'd128; //A_NUM从-128开始自增
                B_NUM <= j - 8'd128; //B_NUM从-128开始自增
/*                 A_NUM <= $random;
                B_NUM <= $random;     */         
            end
        end
    end
    
    //正确结果
    assign C_NUM_real = A_NUM * B_NUM;
    
    //计算结果正确标志
    assign correct = (C_NUM_real == C_NUM);
    
    //模块例化
    mult_8_8_top mult_8_8_top_inst(
        .A_NUM  (A_NUM),    //乘数
        .B_NUM  (B_NUM),    //被乘数

        .C_NUM  (C_NUM)     //积
    );

endmodule
