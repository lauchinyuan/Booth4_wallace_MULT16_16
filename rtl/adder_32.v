`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan 
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 19:48:06
// Module Name: adder_32
// Dependencies: 32bit adder with input sign signal
//////////////////////////////////////////////////////////////////////////////////
module adder_32(
        input wire  [30:0]  A       ,
        input wire  [28:0]  B       ,
        input wire          sign    ,
        
        output wire [31:0]  C       
    );
    
    
    wire [29:0] cout_adder_32bit;
    
/*  //各级产生的进位
    wire [29:0] cout_adder_32bit;
    
    //最低位使用半加器
    half_adder half_adder_32bit_0(
        .a      (A[0])                  ,
        .b      (B[0])                  ,

        .cout   (cout_adder_32bit[0])   ,
        .sum    (C[0])
    );
    
    genvar i ;
    generate
        for(i = 1;i <= 29;i = i + 1) begin: adder_32_full_adder_inst
            //3:2压缩器实质上是全加器
            compressor_3_2 full_adder(
                .i0 (A[i]),
                .i1 (B[i]),
                .ci (cout_adder_32bit[i-1]),

                .co (cout_adder_32bit[i]),
                .d  (C[i])
            );
        end

    endgenerate
    
    compressor_3_2 full_adder_msb(
                .i0 (A[30]),
                .i1 (B[30]),
                .ci (cout_adder_32bit[29]),

                .co (  ), //don't care
                .d  (C[30])
            );
     */
     
     
    //输出数据的最高位直接由输入数据最高位异或产生
    assign C[31] = sign;
    
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
    
    //C[29:9]使用全加器生成
    genvar j;
    generate
        for(j=9;j<=29;j=j+1) begin
            compressor_3_2 full_adder_c29_9(
                        .i0 (A[j]),
                        .i1 (B[j-2]),
                        .ci (cout_adder_32bit[j-3]),
        
                        .co (cout_adder_32bit[j-2]), 
                        .d  (C[j])
            );          
        end
    endgenerate 
    
    //C[30](最高位)使用异或门生成,相当于不输出进位的全加器,减少资源开销
    assign C[30] = A[30] ^ B[28] ^ cout_adder_32bit[27];
    
endmodule
