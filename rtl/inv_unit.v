`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/06/09 16:12:43
// Description: 取反加一模块的最小单元
//              实际上实现的就是异或门的功能
//              其中的或门输出的中间数据可以复用
//////////////////////////////////////////////////////////////////////////////////
module inv_unit(
        input wire  a       ,
        input wire  b       ,
        
        output wire xor_o   ,  //异或输出
        output wire or_o       //或输出
    );
    
    //中间变量
    wire aORb       ;  //对输入的两个数据进行"或"运算
    wire aNANDb     ;  //对输入的两个数据进行"与非"运算
    wire NAND_o2    ;  //第二级与非门输出
    
    assign aORb     = a | b;
    assign aNANDb   = ~(a & b);
    assign NAND_o2  = ~(aORb & aNANDb);
    
    assign xor_o    = ~NAND_o2;
    assign or_o     = aORb;
    
endmodule
