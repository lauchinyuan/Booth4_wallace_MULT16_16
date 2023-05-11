`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/10 21:46:40
// Module Name: in_0_compressor_4_2
// Description: 4:2压缩器的变式,有一个输入端口确定为0的4:2压缩器,这里将i0设为0
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
    //当原本4:2的i0为0时,第一级3:2压缩器退化成半加器
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
