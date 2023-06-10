`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email: lauchinyuan@yeah.net
// Create Date: 2023/06/10 21:59:49
// Module Name: inv_unit_nor_out
// Description:  在"取反加一"模块inv_converter_16中,产生"-A[15]"的取反单元
//               实际上就是"异或门"结构,复用了内部的或非门NOR
//               相比其他位置上使用的普通取反单元inv_unit
//               其输出的一个端口由OR门变为XOR门其资源开销更小
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

module inv_unit_nor_out(
        input wire  a       ,
        input wire  b       ,
        
        output wire xor_o   ,  //异或输出
        output wire nor_o      //或非输出
    );
    
    //构成门电路的中间连线(中间数据)
    wire    a_AND_b     ;  //a和b相与
    wire    a_NOR_b     ;  //a和b或非
    
    //与门
    assign  a_AND_b = a & b;
    
    //或非门
    assign  a_NOR_b = ~(a | b);
    
    //输出
    assign  xor_o   = ~(a_AND_b | a_NOR_b); //或非门
    assign  nor_o   = a_NOR_b;
    
endmodule
