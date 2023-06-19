`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/06/09 16:12:43
// Description: 取反加一模块的最小单元
//              实际上实现的就是异或门的功能
//              其中的或门输出的中间数据可以复用
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //|  AND   |  1           | 6                 | 
                 //|  OR    |  1           | 6                 |
                 //|  NOT   |  0           | 0                 |  
                 //|  NAND  |  1           | 4                 |
                 //|  NOR   |  0           | 0                 | 
                 //|  AOI4  |  0           | 0                 |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  3           | 16                |
                 //---------------------------------------------
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
    
    //OR
    assign aORb     = a | b;
    
    //NAND
    assign aNANDb   = ~(a & b);
        
    
    //输出值
    //AND
    assign xor_o    = (aORb & aNANDb);
    //无额外资源
    assign or_o     = aORb;
    
endmodule
