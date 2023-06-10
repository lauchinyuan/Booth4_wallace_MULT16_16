`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/04/09 19:53:30
// Module Name: half_adder
//              使用门电路实现了"异或门"结构,使得"异或门"内部的信号可以复用
//              减少了MOS管的使用量
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //|  AND   |  1           | 6                 | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  0           | 0                 |  
                 //|  NAND  |  0           | 0                 |
                 //|  NOR   |  2           | 8                 | 
                 //|  AOI4  |  0           | 0                 |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  3           | 14                |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module half_adder(
        input wire  a   ,
        input wire  b   ,
        
        output wire cout,
        output wire sum 
    );
    
    //中间数据(连线),部分数据可以实现复用
    wire a_nor_b        ;   //a和b或非的结果,构成"异或门"中间数据
    wire a_and_b        ;   //a和b相与的结果,构成"异或门"中间数据,也是cout输出
    
    assign a_and_b = a & b;    //与门
    assign a_nor_b = ~(a | b); //或非门
   
    //模块输出
    assign cout     = a_and_b;
    assign sum      = ~(a_nor_b | a_and_b);
    
endmodule