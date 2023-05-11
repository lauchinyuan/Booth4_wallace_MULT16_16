`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/08 17:24:06
// Module Name: booth2_pp_compressor
// Dependencies: 将16bit乘法器通过Booth2算法产生的8个部分积进行压缩
//使用3:2压缩方案和4:2压缩方案,并采用符号位编码方案,而非直接扩展所产生部分积的符号位
//////////////////////////////////////////////////////////////////////////////////


module booth2_pp_compressor(
        //8个部分积,这里的部分还未进行移位补零操作，
        //PP1为booth2乘数编码最低位与被乘数相乘而产生的
        //PP8为booth2乘数编码最高位与被乘数相乘而产生的
        //即PP1为做竖式乘法运算由上往下第一行
        input wire [16:0] PP1   ,
        input wire [16:0] PP2   ,   
        input wire [16:0] PP3   ,
        input wire [16:0] PP4   ,
        input wire [16:0] PP5   ,
        input wire [16:0] PP6   ,
        input wire [16:0] PP7   ,
        input wire [16:0] PP8   ,

        output wire [31:0] PPout1,  //压缩后生成的第一个部分积
        output wire [29:0] PPout2   //压缩后生成的第二个部分积,低位暂未补零
    );
    
    //符号位后部分积
    wire [19:0] PP1_code;   //经过符号位编码后的PP1，最低位暂不补零
    wire [18:0] PP2_code;   //经过符号位编码后的PP2，最低位暂不补零
    wire [19:0] PP3_code;   
    wire [18:0] PP4_code;
    wire [18:0] PP5_code;
    wire [18:0] PP6_code;
    wire [19:0] PP7_code;
    wire [16:0] PP8_code;                                                   
    
    //第一次压缩产生的部分积
    wire [23:0] PPC1_1;  //第一级压缩产生的部分积1
    wire [22:0] PPC1_2; //第一级压缩产生的部分积2,低位暂未补零
    wire [23:0] PPC1_3; //第一级压缩产生的部分积3,低位暂未补零
    wire [21:0] PPC1_4; //第一级压缩产生的部分积4,低位暂未补零
    
    wire [31:0] PPC2_1;//第二级压缩产生的部分积1
    wire [29:0] PPC2_2;//第二级压缩产生的部分积2,低位暂未补零
    
    
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的4:2压缩器的进位连线
    wire [15:0] cout_class1_ppc12; 
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)时用到的4:2压缩器的进位连线
    wire [15:0] cout_class1_ppc34;
    //第二级压缩4:2压缩器的进位连线
    wire [20:0] cout_class2;
    
    //产生用于符号位编码的符号位取反信号,消耗8个非门资源
    wire    PP1_s_inv  ;   //部分积1的符号位取反信号 
    wire    PP2_s_inv  ;   //部分积2的符号位取反信号
    wire    PP3_s_inv  ;   //部分积3的符号位取反信号
    wire    PP4_s_inv  ;   //部分积4的符号位取反信号
    wire    PP5_s_inv  ;   //部分积5的符号位取反信号
    wire    PP6_s_inv  ;   //部分积6的符号位取反信号
    wire    PP7_s_inv  ;   //部分积7的符号位取反信号
    wire    PP8_s_inv  ;   //部分积8的符号位取反信号
    
    wire    [31:0] PP1_FULL;
    wire    [31:0] PP2_FULL;
    wire    [31:0] PP3_FULL;
    wire    [31:0] PP4_FULL;
    wire    [31:0] PP5_FULL;
    wire    [31:0] PP6_FULL;
    wire    [31:0] PP7_FULL;
    wire    [31:0] PP8_FULL; 
    
    wire    [31:0] PPC1_1_FULL;
    wire    [31:0] PPC1_2_FULL;
    wire    [31:0] PPC1_3_FULL;
    wire    [31:0] PPC1_4_FULL;
    
    
    assign  PP1_s_inv = ~PP1[16];
    assign  PP2_s_inv = ~PP2[16];
    assign  PP3_s_inv = ~PP3[16];
    assign  PP4_s_inv = ~PP4[16];
    assign  PP5_s_inv = ~PP5[16];
    assign  PP6_s_inv = ~PP6[16];
    assign  PP7_s_inv = ~PP7[16];
    assign  PP8_s_inv = ~PP8[16];
    
    //对部分积进行符号位编码
    assign PP1_code = {PP1_s_inv,{2{PP1[16]}},PP1};
    assign PP2_code = {1'b1,PP2_s_inv,PP2};
    assign PP3_code = {PP4_s_inv,1'b1,PP3_s_inv,PP3};
    assign PP4_code = {1'b1,1'b0,PP4};    
    assign PP5_code = {1'b1,PP5_s_inv,PP5};
    assign PP6_code = {1'b1,PP6_s_inv,PP6};    
    assign PP7_code = {PP8_s_inv,1'b1,PP7_s_inv,PP7};
    assign PP8_code = PP8;
    
    assign PP1_FULL = PP1_code;
    assign PP2_FULL = {PP2_code,2'b0};
    assign PP3_FULL = {PP3_code,4'b0};
    assign PP4_FULL = {PP4_code,6'b0};
    assign PP5_FULL = {PP5_code,8'b0};
    assign PP6_FULL = {PP6_code,10'b0};
    assign PP7_FULL = {PP7_code,12'b0};
    assign PP8_FULL = {PP8_code,14'b0}; 
    
    assign PPC1_1_FULL = {PPC1_1};
    assign PPC1_2_FULL = {PPC1_2,2'b0};
    assign PPC1_3_FULL = {PPC1_3,8'b0};
    assign PPC1_4_FULL = {PPC1_4,10'b0};
    
    /**************************************第一级第一次压缩*******************************/
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的前两个3:2压缩器
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
        for(i=7;i<=19;i=i+1) begin: compressor_4_2_class1_ppc12_inst
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
    
    //PP2_code[18]一定是1,PP1_code[20]不存在数值
    //相当于这一级使用的4:2压缩器两个输入分别确定是0和1
    //使用有两个输入分别确定是0和1的4:2压缩器,节省资源开销
    in_0_1_compressor_4_2 in_0_1_compressor_4_2_class1_ppc12_20(
            .i1   (PP3_code[16]   ),
            .i3   (PP4_code[14]   ),
            .ci   (cout_class1_ppc12[13]),

            .co  (cout_class1_ppc12[14]),
            .c   (PPC1_2[19]),
            .d   (PPC1_1[20])
    );    
    
    //PP3_code[17]所在的同一权位,在产生4:2压缩时,只有三个有效输入
    //使用3:2压缩器即可,会产生进位链
    compressor_3_2 compressor_3_2_class1_ppc12_21(
        .i0      (PP3_code[17]),
        .i1      (PP4_code[15]),
        .ci      (cout_class1_ppc12[14]),

        .co      (PPC1_2[20]),
        .d       (PPC1_1[21])
    );
    
    //PP3_code[18]一定是1,而在同一权值的PP1_code[22]和PP2_code[20]都不存在,相当于是0
    //且这一权值不存在来自上一级的进位,相当于这一权值的4:2压缩器的有效输入只有1和PP4_code[16]
    //则PPC1_1[22] = ~PP4_code[16]; PPC1_2[21] = PP4_code[16]
    assign PPC1_1[22] = ~PP4_code[16];
    assign PPC1_2[21] = PP4_code[16];
    
    //最高位和最低位部分本来就是两个部分积,不用处理,直接连续赋值(接线)
    assign PPC1_1[23]   = PP3_code[19]      ;
    assign PPC1_1[3:0]  = PP1_code[3:0]     ; 
    assign PPC1_2[22]   = PP4_code[18]      ;
    assign PPC1_2[1:0]  = PP2_code[1:0]     ;
    assign PPC1_2[2]    = 1'b0  ;           //第一次使用3:2压缩器的位置，进位部分积没有进位
    
    
    
    
    /**************************************第一级第二次压缩*******************************/   
    
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第1-2个3:2压缩器
    generate 
        for(i=4;i<=5;i=i+1) begin : compressor_3_2_class1_ppc34_inst
            compressor_3_2 compressor_3_2_class1_ppc34_i (
                .i0 (PP5_code[i]),
                .i1 (PP6_code[i-2]),
                .ci (PP7_code[i-4]),
        
                .co (PPC1_4[i-1]),
                .d  (PPC1_3[i])
            );       
        end
    endgenerate
    
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第1个4:2压缩器,使用不考虑进位的4:2压缩器
    non_cin_compressor_4_2 compressor_4_2_class1_ppc34_1 (
        .i0 (PP5_code[6]),
        .i1 (PP6_code[4]),
        .i2 (PP7_code[2]),
        .i3 (PP8_code[0]),

        .co (cout_class1_ppc34[0]),
        .c  (PPC1_4[5]),
        .d  (PPC1_3[6])
    ); 


    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第i个4:2压缩器
    generate 
        for(i=7;i<=17;i=i+1) begin: compressor_4_2_class1_ppc34_inst
            compressor_4_2 compressor_4_2_class1_ppc34_i (
                    .i0 (PP5_code[i]),
                    .i1 (PP6_code[i-2]),
                    .i2 (PP7_code[i-4]),
                    .i3 (PP8_code[i-6]),
                    .ci (cout_class1_ppc34[i-7]),  
            
                    .co (cout_class1_ppc34[i-6]),
                    .c  (PPC1_4[i-1]),
                    .d  (PPC1_3[i])
                );              
        end
    endgenerate 

    //PP5_code[18]一定是1,则产生PPC1_4[17]和PPC1_3[18]的4:2压缩器可以使用一个确定输入为1的4:2压缩器变式
    //这一变式器件并不延长进位链
    in_1_compressor_4_2 compressor_4_2_class1_ppc34_18(
        .i0  (PP6_code[16]),
        .i1  (PP7_code[14]),
        .i3  (PP8_code[12]),
        .ci  (cout_class1_ppc34[11]),

        .co  (cout_class1_ppc34[12]),
        .c   (PPC1_4[17]),
        .d   (PPC1_3[18])
    );
    
    //PP5_code[19]一定是0,则产生PPC1_4[18]和PPC1_3[19]的4:2压缩器可以使用一个确定输入为0的4:2压缩器变式
    //这一变式器件并不延长进位链
    in_0_compressor_4_2 compressor_4_2_class1_ppc34_19(
            .i1   (PP6_code[17]),
            .i2   (PP7_code[15]),
            .i3   (PP8_code[13]),
            .ci   (cout_class1_ppc34[12]),

            .co   (cout_class1_ppc34[13]),
            .c    (PPC1_4[18]),
            .d    (PPC1_3[19])
    
        );  

    //PP5_code[20]一定是0,PP6_code[18]一定是0,则产生PPC1_4[19]和PPC1_3[20]的4:2压缩器可以使用确定输入为0和1的4:2压缩器变式
    //这一变式器件并不延长进位链  
    in_0_1_compressor_4_2 compressor_4_2_class1_ppc34_20(
            .i1   (PP7_code[16]   ),
            .i3   (PP8_code[14]   ),
            .ci   (cout_class1_ppc34[13]),

            .co  (cout_class1_ppc34[14]),
            .c   (PPC1_4[19]),
            .d   (PPC1_3[20])
    ); 
 
    //PP7_code[17]所在的同一权位,在产生4:2压缩时,只有三个有效输入
    //使用3:2压缩器即可,会产生进位链
    compressor_3_2 compressor_3_2_class1_ppc34_21(
        .i0      (PP7_code[17]),
        .i1      (PP8_code[15]),
        .ci      (cout_class1_ppc34[14]),

        .co      (PPC1_4[20]),
        .d       (PPC1_3[21])
    ); 

    //PP7_code[18]一定是1,而在同一权值的PP5_code[22]和PP6_code[20]都不存在,相当于是0
    //且这一权值不存在来自上一级的进位,相当于这一权值的4:2压缩器的有效输入只有1和PP4_code[16]
    //则PPC1_1[22] = ~PP4_code[16]; PPC1_2[21] = PP4_code[16]
    assign PPC1_3[22] = ~PP8_code[16];
    assign PPC1_4[21] = PP8_code[16];
    
    //最高位和最低位部分本来就是两个部分积,不用处理,直接连续赋值(接线)
    assign PPC1_3[23]   = PP7_code[19]      ;
    assign PPC1_3[3:0]  = PP5_code[3:0]     ; 
    assign PPC1_4[1:0]  = PP6_code[1:0]     ;
    assign PPC1_4[2]    = 1'b0  ;           //第一次使用3:2压缩器的位置，进位部分积没有进位  
    
    
    
    //*************************************************************************************//
    /**************************************第二级4:2压缩*******************************/       
    
    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第1-2个3:2压缩器
    generate 
        for(i=8;i<=9;i=i+1) begin : compressor_3_2_class2_ppc12_inst
            compressor_3_2 compressor_3_2_class2_1_2 (
                .i0 (PPC1_1[i]),
                .i1 (PPC1_2[i-2]),
                .ci (PPC1_3[i-8]),
        
                .co (PPC2_2[i-1]),
                .d  (PPC2_1[i])
            );       
        end
    endgenerate
    
    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第1个4:2压缩器,使用不考虑进位的4:2压缩器
    non_cin_compressor_4_2 compressor_4_2_class2_ppc12_1 (
        .i0 (PPC1_1[10]),
        .i1 (PPC1_2[8]),
        .i2 (PPC1_3[2]),
        .i3 (PPC1_4[0]),

        .co (cout_class2[0]),
        .c  (PPC2_2[9]),
        .d  (PPC2_1[10])
    );  
    
    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第2个4:2压缩器
    compressor_4_2 compressor_4_2_class2_ppc12_2 (
        .i0 (PPC1_1[11]),
        .i1 (PPC1_2[9]),
        .i2 (PPC1_3[3]),
        .i3 (PPC1_4[1]),
        .ci (cout_class2[0]),

        .co (cout_class2[1]),
        .c  (PPC2_2[10]),
        .d  (PPC2_1[11])
    );     

    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第3个4:2压缩器,使用不考虑进位的4:2压缩器
    //因为原本的PPC1_4[2]一定为0,故这里将来自上一级的进位输入i3
    //这样变换后co依然只与i0、i1、i2有关,与cout_class2[1](i3)无关,不存在进位链传播的问题
    non_cin_compressor_4_2 compressor_4_2_class2_ppc12_3 (
        .i0 (PPC1_1[12]),
        .i1 (PPC1_2[10]),
        .i2 (PPC1_3[4]),
        .i3 (cout_class2[1]),

        .co (cout_class2[2]),
        .c  (PPC2_2[11]),
        .d  (PPC2_1[12])
    ); 
    
    
    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第i个4:2压缩器
    generate 
        for(i=13;i<=23;i=i+1) begin: compressor_4_2_class2_ppc12_inst
            compressor_4_2 compressor_4_2_class2_i (
                    .i0 (PPC1_1[i]),
                    .i1 (PPC1_2[i-2]),
                    .i2 (PPC1_3[i-8]),
                    .i3 (PPC1_4[i-10]),
                    .ci (cout_class2[i-11]),  
            
                    .co (cout_class2[i-10]),
                    .c  (PPC2_2[i-1]),
                    .d  (PPC2_1[i])
                );              
        end
    endgenerate
    
    //PPC1_1[24]一定是0,PPC1_2[22]一定是1,则产生PPC2_1[24]和PPC2_2[23]的4:2压缩器可以使用确定输入为0和1的4:2压缩器变式
    //这一变式器件并不延长进位链  
    in_0_1_compressor_4_2 compressor_4_2_class2_24(
            .i1   (PPC1_3[16]   ),
            .i3   (PPC1_4[14]   ),
            .ci   (cout_class2[13]),

            .co  (cout_class2[14]),
            .c   (PPC2_2[23]),
            .d   (PPC2_1[24])
    ); 
    
    //PPC1_3[17]所在的同一权位,在产生4:2压缩时,只有三个有效输入
    //使用3:2压缩器即可,会产生进位链
    compressor_3_2 compressor_4_2_class2_25(
        .i0      (PPC1_3[17]),
        .i1      (PPC1_4[15]),
        .ci      (cout_class2[14]),

        .co      (PPC2_2[24]),
        .d       (PPC2_1[25])
    ); 
    
    //PPC1_3[18]所在的同一权位,在产生4:2压缩时,只有两个有效输入
    //不会产生进位链 
    generate
        for(i=26;i<=30;i=i+1) begin: compressor_4_2_class2_half_adder_inst
            half_adder compressor_4_2_class2_half_adder_i(
                .a   (PPC1_3[i-8]),
                .b   (PPC1_4[i-10]),

                .cout(PPC2_2[i-1]),
                .sum (PPC2_1[i])
            );
        end
    endgenerate
    
    //PPC2_1最高位使用一个异或门即可得到
    assign PPC2_1[31] = PPC1_3[23] ^ PPC1_4[21];
    
    //补全部分积1(PPC2_1)和部分积2(PPC2_2)没有用到压缩的位置
    //没有变化的位置
    assign PPC2_1[7:0] = PPC1_1[7:0]; 
    assign PPC2_2[5:0] = PPC1_2[5:0];
    //第一次使用3:2压缩器的位置，保留进位部分积没有进位
    assign PPC2_2[6] = 1'b0;    
   
    //****************************************输出两个压缩后的部分积****************************************//
    assign PPout1 = PPC2_1;
    assign PPout2 = PPC2_2;
    
    
    
    
    
    
    
    
    
    
   
    
endmodule