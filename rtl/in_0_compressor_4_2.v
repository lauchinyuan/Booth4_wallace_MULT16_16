`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/10 21:46:40
// Module Name: in_0_compressor_4_2
// Description: 4:2压缩器的变式,有一个输入端口确定为0的4:2压缩器,这里将i0设为0
// Resource: 
//-----------------------------------------------------------------------------------
//|  Module /Gate           | Module count | Transistor counts per Module  | Total  |
//-----------------------------------------------------------------------------------
//|  compressor_3_2         | 1            | 32                            | 32     |
//|  half_adder             | 1            | 14                            | 14     |
//-----------------------------------------------------------------------------------
//|  summary                | 2            | **                            | 46     |
//-----------------------------------------------------------------------------------

// Counting resources from the gate-level circuit perspective
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //--------------------------------------------
                 //|  AND   |  1           | 6                 | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  2           | 4                 |  
                 //|  NAND  |  3           | 12                |
                 //|  NOR   |  2           | 8                 | 
                 //|  AOI4  |  2           | 16                |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  10          | 46                |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module in_0_compressor_4_2(
        input wire i1   ,
        input wire i2   ,
        input wire i3   ,
        input wire ci   ,
        
        output wire co  ,
        output wire c   ,
        output wire d   

    );
    
    wire   wire_d   ;   //第一级半加器与第一级3:2压缩器之间的连线
    //当原本4:2的i0为0时,第一级3:2压缩器变成半加器
    half_adder half_adder_class1(
        .a      (i1),
        .b      (i2),

        .cout   (co),
        .sum    (wire_d)
    );
    
    
    //第二个3:2压缩器
    compressor_3_2 compressor_3_2_class2(
        .i0     (wire_d),
        .i1     (i3),
        .ci     (ci),

        .co     (c),
        .d      (d)
    ); 
endmodule
