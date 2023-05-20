`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/20 13:33:51
// Module Name: inv_half_adder
// Description: 输入为取反后数据的半加器
// 输入inv_a为1相当于原来半加器输入的a为0, inv_b与b之间的关系同理
// 当输入信号外部逻辑已经可以产生a\b取反后的信号时,使用此模块相比传统半加器减少了资源使用量
//                      真值表
//      --------------------------------------
//      |  inv_a  |  inv_b  |  cout   |  sum  |
//      |    0    |    0    |    1    |   0   |
//      |    0    |    1    |    0    |   1   |
//      |    1    |    0    |    0    |   1   |
//      |    1    |    1    |    0    |   0   |
//      --------------------------------------
//////////////////////////////////////////////////////////////////////////////////

module inv_half_adder(
        input wire      inv_a   ,
        input wire      inv_b   ,
        
        output wire     cout    ,
        output wire     sum     
    );
    
    assign sum = inv_a ^ inv_b;
    assign cout = ~(inv_a | inv_b);  //或非门
    
endmodule
