//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: compressor_4_2 
// Description: 4：2压缩器,使用两个3：2压缩器联合产生
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
    
/*     wire xored_i0123    ;   //中间变量i0 ^ i1 ^ i2 ^ i3
    
    assign xored_i0123 = i0 ^ i1 ^ i2 ^ i3;
    
    assign d = xored_i0123 ^ ci;
    assign co = (i0 | i1) & (i2 | i3);
    assign c = (xored_i0123 & ci) | ~(xored_i0123 | ~((i0 & i1) | (i2 & i3))); */
    
endmodule
