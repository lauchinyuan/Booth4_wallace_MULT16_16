//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: compressor_4_2 
// Description: 4：2压缩器,使用两个3：2压缩器联合产生
// Resource: 
//-----------------------------------------------------------------------------------
//|  Module /Gate           | Module count | Transistor counts per Module  | Total  |
//-----------------------------------------------------------------------------------
//|  compressor_3_2         | 2            | 32                            | 64     |
//-----------------------------------------------------------------------------------
//|  summary                | 2            | **                            | 64     |
//-----------------------------------------------------------------------------------

// Counting resources from the gate-level circuit perspective
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //--------------------------------------------
                 //|  AND   |  0           | 0                 | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  4           | 8                 |  
                 //|  NAND  |  6           | 24                |
                 //|  NOR   |  0           | 0                 | 
                 //|  AOI4  |  4           | 32                |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  14          | 64                |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module compressor_4_2(
        input wire i0   ,
        input wire i1   ,
        input wire i2   ,
        input wire i3   ,
        input wire ci   ,
        
        output wire co  ,
        output wire c   ,
        output wire d   
    );
    
    wire    wire_d      ;  //两个3:2之间的级联线
    
    //第一个3:2压缩器
    compressor_3_2 compressor_3_2_class1(
        .i0     (i0),
        .i1     (i1),
        .ci     (i2),

        .co     (co),
        .d      (wire_d)
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
