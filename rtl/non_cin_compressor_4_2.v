`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/05 15:16:48
// Module Name: non_cin_compressor_4_2
// Description: 不考虑进位输入的4：2压缩器
//////////////////////////////////////////////////////////////////////////////////
module non_cin_compressor_4_2(
        input   wire    i0  ,
        input   wire    i1  ,
        input   wire    i2  ,
        input   wire    i3  ,
        
        output  wire    co  ,
        output  wire    c   ,
        output  wire    d
    );
    
    wire    wire_d      ;  //3:2压缩器和半加器之间的连线
    
    //第一个3:2压缩器
    compressor_3_2 compressor_3_2_class1(
        .i0     (i0),
        .i1     (i1),
        .ci     (i2),

        .co     (co),
        .d      (wire_d)
    );
    
    //不考虑进位输入,第二级直接使用半加器即可
    half_adder half_adder_class(
        .a   (wire_d),
        .b   (i3),

        .cout(c),
        .sum (d)
    );
    
    
    
    
endmodule
