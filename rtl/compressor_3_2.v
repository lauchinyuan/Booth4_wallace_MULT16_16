//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: compressor_4_2 
// Description: 3：2压缩器,实质上是全加器
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module compressor_3_2(
        input wire i0   ,
        input wire i1   ,
        input wire ci   ,
        
        output wire co  ,
        output wire d   
    );
    
    wire    i0xori1             ;  //中间信号，i0和i1的异或
    
    assign  i0xori1  = i0 ^ i1  ;
    
    //异或得到d输出
    assign d = i0xori1 ^ ci     ;
    
    //与或非门加非门实现co输出
    assign co = ~(~((i0 & i1) | (ci & i0xori1)));
    
    
endmodule
