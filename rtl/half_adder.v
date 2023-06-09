`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/04/09 19:53:30
// Module Name: half_adder
//              实现了原本半加器中的异或门结构,使得异或门内部的信号可以复用
//              减少了MOS管的使用量
//////////////////////////////////////////////////////////////////////////////////
module half_adder(
        input wire  a   ,
        input wire  b   ,
        
        output wire cout,
        output wire sum 
    );
    
    //中间数据(连线),部分数据可以实现复用
    wire a_nand_b       ;   //a和b与非的结果
    wire AOI_o          ;   //与或非门输出的结果
    
    assign a_nand_b = ~(a & b);    //与非门
    assign AOI_o    = ~((a_nand_b & a) | (a_nand_b & b)); //与或非门
    
    //模块输出
    assign cout     = ~a_nand_b;
    assign sum      = ~AOI_o;
    
endmodule