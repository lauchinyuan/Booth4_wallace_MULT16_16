`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 2023/04/20 19:23:13
// Module Name: simplify_compressor_4_2
// Description: 简化的4:2压缩器，省去了输出co、c的电路资源，只输出d
//////////////////////////////////////////////////////////////////////////////////
module simplify_compressor_4_2(
        input wire i0   ,
        input wire i1   ,
        input wire i2   ,
        input wire i3   ,
        input wire ci   ,
        
        output wire d
    );
        assign d = i0 ^ i1 ^ i2 ^ i3 ^ ci;
endmodule
    
