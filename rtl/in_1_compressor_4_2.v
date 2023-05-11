`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/11 19:59:36
// Module Name: in_1_compressor_4_2
// Description: 4:2压缩器的变形,有一个输入端确定为1,这里令原来第一级3:2压缩器的cin输入(4:2压缩器的i2)为1
//////////////////////////////////////////////////////////////////////////////////
module in_1_compressor_4_2(
        input   wire        i0  ,
        input   wire        i1  ,
        input   wire        i3  ,
        input   wire        ci  ,
        
        output  wire        co  ,
        output  wire        c   ,
        output  wire        d   
    );
    
    wire   i0_xnor_i1       ;  //i0与i1的同或,亦是原本第一级3:2压缩器的d输出
    
    
    //使用一个同或门和两个与非门构建出原来4:2压缩器的第一级3:2压缩器
    assign i0_xnor_i1 = ~(i0 ^ i1);
    
    //再使用两个与非门级联得到co输出
    assign co = ~((~(i0 & i1))&i0_xnor_i1);
    
    //4:2压缩器中的第二级3:2压缩器
    compressor_3_2 compressor_3_2_class2(
        .i0     (i0_xnor_i1),
        .i1     (i3),
        .ci     (ci),

        .co     (c),
        .d      (d)
    ); 
    
    
endmodule
