`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/20 16:53:04
// Module Name: single_inv_half_adder
// Description: 单个端口的输入为取反后数据的半加器
// 输入inv_a为1相当于原来半加器输入的a为0
// 当输入信号外部逻辑已经可以产生a取反后的信号时,使用此模块相比传统半加器减少了资源使用量
// 本设计中用于“取反加一”模块,即"inv_converter_16"模块
//                      真值表
//      --------------------------------------
//      |  inv_a  |    b    |  cout   |  sum  |
//      |    0    |    0    |    0    |   1   |
//      |    0    |    1    |    1    |   0   |
//      |    1    |    0    |    0    |   0   |
//      |    1    |    1    |    0    |   1   |
//      --------------------------------------
//////////////////////////////////////////////////////////////////////////////////


module single_inv_half_adder(
        input wire     inv_a    ,
        input wire     b        ,
        
        output wire    cout     ,
        output wire    sum
    );
    
    wire inv_b          ;  //中间连线变量
    assign inv_b = ~b   ;
    
    assign cout = ~(inv_a | inv_b);  //使用或非门实现cout输出
    assign sum = ~(inv_a ^ b);       //使用同或门实现sum输出
    
    
    
endmodule
