`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/10 22:03:02
// Module Name: in_0_1_compressor_4_2 
// Description: 4:2压缩器的变式,有一个输入端口确定为0,另一个输入端口确定为1的4:2压缩器,
// 这里将原来4:2压缩器的i0设为0,i2设为1,这样,第一级3:2可以直接使用一个非门资源实现
//////////////////////////////////////////////////////////////////////////////////
module in_0_1_compressor_4_2(
        input wire i1   ,
        input wire i3   ,
        input wire ci   ,
        
        output wire co  ,
        output wire c   ,
        output wire d   
    );
    
    //相当于第一级3:2压缩器
    wire    inv_i1 ;  //i1取反后的信号
    assign  inv_i1 = ~i1;
    
    assign  co = i1;  //i0设为0,i2设为1,则co=i1
    
    //第二级3:2压缩器
    compressor_3_2 compressor_3_2_class2(
        .i0     (inv_i1),
        .i1     (i3),
        .ci     (ci),

        .co     (c),
        .d      (d)
    ); 
    
endmodule
