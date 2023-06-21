`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 19:48:06
// Module Name: adder_32
// Description: 32bit adder 

// Resource: 
//-----------------------------------------------------------------------------------
//|  Module /Gate           | Module count | Transistor counts per Module  | Total  |
//-----------------------------------------------------------------------------------
//|  compressor_3_2         | 26           | 32                            | 832    |
//|  half_adder             | 3            | 14                            | 42     |
//|  XOR                    | 2            | 12                            | 24     |
//-----------------------------------------------------------------------------------
//|  summary                | 31           | **                            | 898    |
//-----------------------------------------------------------------------------------

// Counting resources from the gate-level circuit perspective
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //--------------------------------------------
                 //|  AND   |  3           | 18                | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  52          | 104               |  
                 //|  NAND  |  78          | 312               |
                 //|  NOR   |  6           | 24                | 
                 //|  AOI4  |  52          | 416               |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  2           | 24                |
                 //---------------------------------------------
                 //| summary|  193         | 898               |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module adder_32(
        input wire  [31:0]  A       ,
        input wire  [29:0]  B       ,
        
        output wire [31:0]  C       
    );
    
    
    wire [28:0] cout_adder_32bit;
    wire        xor_o1          ; //处理最高位时,分两级异或处理,这是第一级异或门的输出
    
    //输出数据的低两位就是31bit输入数据的低两位
    assign C[1:0] = A[1:0];
    
    //C[2]使用半加器生成,因为前级的进位一定是0
    half_adder half_adder_c2(
        .a      (A[2])                  ,
        .b      (B[0])                  ,

        .cout   (cout_adder_32bit[0])   ,
        .sum    (C[2])
    );
    
    //C[3]使用全加器生成,需要考虑进位
    //3:2压缩器实质上就是全加器
    compressor_3_2 full_adder_c3(
                .i0 (A[3]),
                .i1 (B[1]),
                .ci (cout_adder_32bit[0]),

                .co (cout_adder_32bit[1]),
                .d  (C[3])
    );
    
    //C[4]使用半加器生成,因为C[4]位置上的输入B[2]一定是0
    //将前一级的进位当作半加器的一个输入
    half_adder half_adder_c4(
        .a      (A[4])                  ,
        .b      (cout_adder_32bit[1])   ,

        .cout   (cout_adder_32bit[2])   ,
        .sum    (C[4])
    );  
    
    //C[7:5]使用全加器生成
    genvar i;
    generate
        for(i=5;i<=7;i=i+1) begin
            compressor_3_2 full_adder_c7_5(
                        .i0 (A[i]),
                        .i1 (B[i-2]),
                        .ci (cout_adder_32bit[i-3]),
        
                        .co (cout_adder_32bit[i-2]), 
                        .d  (C[i])
            );          
        end
    endgenerate

    //C[8]使用半加器生成,因为C[8]位置上的输入B[6]一定是0
    //将前一级的进位当作半加器的一个输入
    half_adder half_adder_c8(
        .a      (A[8])                  ,
        .b      (cout_adder_32bit[5])   ,

        .cout   (cout_adder_32bit[6])   ,
        .sum    (C[8])
    );  
    
    //C[30:9]使用全加器生成
    genvar j;
    generate
        for(j=9;j<=30;j=j+1) begin
            compressor_3_2 full_adder_c29_9(
                        .i0 (A[j]),
                        .i1 (B[j-2]),
                        .ci (cout_adder_32bit[j-3]),
        
                        .co (cout_adder_32bit[j-2]), 
                        .d  (C[j])
            );          
        end
    endgenerate 
    
    //C[31](最高位)使用两级级联异或门生成
    assign xor_o1 = A[31] ^ B[29];   //第一级异或门(XOR)
    assign C[31] = xor_o1 ^ cout_adder_32bit[28];  //第二级异或门(XOR)
    
endmodule
