`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/07/11 18:28:12
// Module Name: booth2_pp_compressor
// Description: 将8bit乘法器通过Booth2算法产生的4个部分积进行压缩,采用符号位编码方案
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_compressor(
        //4个部分积,这里的部分还未进行移位补零操作，
        //PP1为booth2乘数编码最低位与被乘数相乘而产生的
        //PP4为booth2乘数编码最高位与被乘数相乘而产生的
        //即PP1为做竖式乘法运算由上往下第一行
        input wire [9:0] PP1   ,
        input wire [9:0] PP2   ,   
        input wire [9:0] PP3   ,
        input wire [9:0] PP4   ,

        output wire [15:0] PPout1,  //压缩后生成的第一个部分积
        output wire [13:0] PPout2   //压缩后生成的第二个部分积,低位暂未补零
    );
    
    //符号位编码后的部分积
    wire [11:0] PP1_code;   //经过符号位编码后的PP1，最低位暂不补零
    wire [10:0] PP2_code;   //经过符号位编码后的PP2，最低位暂不补零
    wire [10:0] PP3_code; 
    //改
    wire [9:0]  PP4_code;   


    wire [15:0] PPC1_1;  //第一级压缩产生的部分积1
    wire [13:0] PPC1_2; //第一级压缩产生的部分积2,低位暂未补零    
 

    //压缩器之间的进位连线
    wire [6:0] cout_class1_ppc12; 
    
    //产生用于符号位编码的符号位信号,消耗1个非门资源
    wire    PP1_s  ;   
    
    //部分积1的真实符号位,因为部分积生成模块booth2_pp_gen生成的PPX的"符号位"是反逻辑
    //取反后得到真实的符号位
    assign  PP1_s = ~PP1[9];  //NOT
    
    
    //对部分积进行符号位编码
    assign PP1_code = {PP1[9],{2{PP1_s}},PP1[8:0]};
    assign PP2_code = {1'b1,PP2};
    assign PP3_code = {1'b1,PP3};
    assign PP4_code = PP4;   
    
    
    //前两个3:2压缩器
    genvar i;
    generate 
        for(i=4;i<=5;i=i+1) begin : compressor_3_2_class1_ppc12_inst
            compressor_3_2 compressor_3_2_class1_ppc12_i (
                .i0 (PP1_code[i]),
                .i1 (PP2_code[i-2]),
                .ci (PP3_code[i-4]),
        
                .co (PPC1_2[i-1]),
                .d  (PPC1_1[i])
            );       
        end
    endgenerate
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第1个4:2压缩器,使用不考虑进位的4:2压缩器
    non_cin_compressor_4_2 compressor_4_2_class1_ppc12_1(
        .i0  (PP1_code[6]),
        .i1  (PP2_code[4]),
        .i2  (PP3_code[2]),
        .i3  (PP4_code[0]),

        .co  (cout_class1_ppc12[0]),
        .c   (PPC1_2[5]),
        .d   (PPC1_1[6])
    );
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第i个4:2压缩器
    generate 
        for(i=7;i<=11;i=i+1) begin: compressor_4_2_class1_ppc12_inst
            compressor_4_2 compressor_4_2_class1_ppc12_i (
                    .i0 (PP1_code[i]),
                    .i1 (PP2_code[i-2]),
                    .i2 (PP3_code[i-4]),
                    .i3 (PP4_code[i-6]),
                    .ci (cout_class1_ppc12[i-7]),  
            
                    .co (cout_class1_ppc12[i-6]),
                    .c  (PPC1_2[i-1]),
                    .d  (PPC1_1[i])
                );              
        end
    endgenerate  
    
    //PP2_code[10]一定是1,PP1_code[12]不存在数值
    //相当于这一级使用的4:2压缩器两个输入分别确定是0和1
    //使用有两个输入分别确定是0和1的4:2压缩器,节省资源开销
    in_0_1_compressor_4_2 in_0_1_compressor_4_2_class1_ppc12_19(
            .i1   (PP3_code[8]   ),
            .i3   (PP4_code[6]   ),
            .ci   (cout_class1_ppc12[5]),

            .co  (cout_class1_ppc12[6]),
            .c   (PPC1_2[11]),
            .d   (PPC1_1[12])
    );    
    
    //PP3_code[9]所在的同一权位,在产生4:2压缩时,只有三个有效输入
    //使用3:2压缩器即可
    compressor_3_2 compressor_3_2_class1_ppc12_20(
        .i0      (PP3_code[9]),
        .i1      (PP4_code[7]),
        .ci      (cout_class1_ppc12[6]),

        .co      (PPC1_2[12]),
        .d       (PPC1_1[13])
    );
    
    //PP3_code[10]一定是1,而在同一权值的PP1_code[14]和PP2_code[12]都不存在,相当于是0
    //且这一权值不存在来自上一级的进位,相当于这一权值的4:2压缩器的有效输入只有1和PP4_code[8]
    //则PPC1_1[14] = ~PP4_code[8]; PPC1_2[13] = PP4_code[8]
    assign PPC1_1[14] = ~PP4_code[8];  //NOT
    assign PPC1_2[13] = PP4_code[8];
    
    //最高位和最低位部分本来就是两个部分积,不用处理,直接连续赋值(接线)
    assign PPC1_1[15]   = PP4_code[9]       ;
    assign PPC1_1[3:0]  = PP1_code[3:0]     ; 
    //assign PPC1_2[14]   = PP4_code[10]      ;
    assign PPC1_2[1:0]  = PP2_code[1:0]     ;
    assign PPC1_2[2]    = 1'b0              ; //第一次使用3:2压缩器的位置，进位部分积没有进位
    
   
    //****************************************输出两个压缩后的部分积****************************************//
    assign PPout1 = PPC1_1;
    assign PPout2 = PPC1_2;
   
    
endmodule
