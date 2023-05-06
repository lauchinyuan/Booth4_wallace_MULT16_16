`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/05 21:44:06
// Module Name: nand_xor_compressor_4_2
// Description: 4：2压缩器的变种,没有i0、i1输入,但需要输入i0^i1以及~(i0&i1)
// 这相当于将原来4：2压缩器的异或门和与门电路外移,因为booth编码产生的部分积有许多i0和i1相同的位
// 这些位可以复用异或门和与非门
//////////////////////////////////////////////////////////////////////////////////
module nand_xor_compressor_4_2(
        input   wire        i0_xor_i1   ,   //输入的i0 ^ i1
        input   wire        i0_nand_i1  ,   //输入的~(i0 & i1)
        input   wire        i2          ,
        input   wire        i3          ,
        input   wire        ci          ,
        
        output  wire        co          ,
        output  wire        c           ,
        output  wire        d   
    );
    
    
    
    wire nand_co            ; //为了产生进位输出而通过与非门产生的中间变量
    wire i0_xor_i1_xor_i2   ; //i0 ^ i1 ^ i2
    
    //以下三行连续赋值语句相当于构建了一个简化版的3:2压缩器(全加器),用作4:2压缩器的第一级
    assign nand_co          = ~(i0_xor_i1 & i2          );
    assign co               = ~(nand_co & i0_nand_i1    );//通过与非门实现4：2压缩器的进位输出
    assign i0_xor_i1_xor_i2 = i0_xor_i1 ^ i2             ;//i0 ^ i1 ^ i2
    
    //第二级使用3:2压缩器生成
    compressor_3_2 compressor_3_2_class2(
        .i0     (i0_xor_i1_xor_i2),
        .i1     (i3),
        .ci     (ci),

        .co     (c),
        .d      (d)
    );
    
    
    
    
endmodule
