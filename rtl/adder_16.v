`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email:lauchinyuan@yeah.net
// Create Date: 2023/07/11 18:56:06
// Module Name: adder_16
// Description: 16bit adder 
//////////////////////////////////////////////////////////////////////////////////
module adder_16(
        input wire  [15:0]  A       ,
        input wire  [13:0]  B       ,
        
        output wire [15:0]  C       
    );
    
    
    wire [28:0] cout_adder_16bit;
    wire        xor_o1          ; //处理最高位时,分两级异或处理,这是第一级异或门的输出
    
    //输出数据的低两位就是31bit输入数据的低两位
    assign C[1:0] = A[1:0];
    
    //C[2]使用半加器生成,因为前级的进位一定是0
    half_adder half_adder_c2(
        .a      (A[2])                  ,
        .b      (B[0])                  ,

        .cout   (cout_adder_16bit[0])   ,
        .sum    (C[2])
    );
    
    //C[3]使用全加器生成,需要考虑进位
    //3:2压缩器实质上就是全加器
    compressor_3_2 full_adder_c3(
                .i0 (A[3]),
                .i1 (B[1]),
                .ci (cout_adder_16bit[0]),

                .co (cout_adder_16bit[1]),
                .d  (C[3])
    );
    
    //C[4]使用半加器生成,因为C[4]位置上的输入B[2]一定是0
    //将前一级的进位当作半加器的一个输入
    half_adder half_adder_c4(
        .a      (A[4])                  ,
        .b      (cout_adder_16bit[1])   ,

        .cout   (cout_adder_16bit[2])   ,
        .sum    (C[4])
    );  
    
    //C[14:5]使用全加器生成
    genvar i;
    generate
        for(i=5;i<=14;i=i+1) begin
            compressor_3_2 full_adder_c7_5(
                        .i0 (A[i]),
                        .i1 (B[i-2]),
                        .ci (cout_adder_16bit[i-3]),
        
                        .co (cout_adder_16bit[i-2]), 
                        .d  (C[i])
            );          
        end
    endgenerate

    
    //C[15](最高位)使用两级级联异或门生成
    assign xor_o1 = A[15] ^ B[13];   //第一级异或门(XOR)
    assign C[15] = xor_o1 ^ cout_adder_16bit[12];  //第二级异或门(XOR)
    
endmodule