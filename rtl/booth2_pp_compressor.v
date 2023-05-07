`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/08 17:24:06
// Module Name: booth2_pp_compressor
// Dependencies: 将16bit乘法器通过Booth2算法产生的8个部分积进行压缩
//使用3:2压缩方案和4:2压缩方案
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
    
    //符号位扩展后部分积
    wire [31:0] PP1_ext;   //经过符号位扩展后的PP1
    wire [29:0] PP2_ext;   //经过符号位扩展后的PP2，最低位暂不补零
    wire [27:0] PP3_ext;   
    wire [25:0] PP4_ext;
    wire [23:0] PP5_ext;
    wire [21:0] PP6_ext;
    wire [19:0] PP7_ext;
    wire [17:0] PP8_ext;                                                   
    
    //第一次压缩产生的部分积
    wire [31:0] PPC1_1;  //第一级压缩产生的部分积1
    wire [29:0] PPC1_2; //第一级压缩产生的部分积2,低位暂未补零
    wire [23:0] PPC1_3; //第一级压缩产生的部分积3,低位暂未补零
    wire [21:0] PPC1_4; //第一级压缩产生的部分积4,低位暂未补零
    
    wire [31:0] PPC2_1;//第二级压缩产生的部分积1
    wire [29:0] PPC2_2;//第二级压缩产生的部分积2,低位暂未补零
    
    
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的4:2压缩器的进位连线
    //最高位进位输出舍去(不考虑)
    wire [18:0] cout_class1_ppc12; 
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)时用到的4:2压缩器的进位连线
    //最高位进位输出舍去(不考虑)
    wire [16:0] cout_class1_ppc34;
    //第二级压缩4:2压缩器的进位连线
    wire [20:0] cout_class2;
    
    
    //部分积符号位扩展,低位暂未补零
    assign PP1_ext = {{7{PP1[16]}},PP1};
    assign PP2_ext = {{5{PP2[16]}},PP2};
    assign PP3_ext = {{3{PP3[16]}},PP3};
    assign PP4_ext = {{1{PP4[16]}},PP4};    
    assign PP5_ext = {{7{PP5[16]}},PP5};
    assign PP6_ext = {{5{PP6[16]}},PP6};    
    assign PP7_ext = {{3{PP7[16]}},PP7};
    assign PP8_ext = {{1{PP8[16]}},PP8};
    

    //使用nand_xor_compressor_4_2模块,需要在模块外部计算i0 ^ i1 以及 ~(i0 & i1)
    //这一计算结果作为中间结果,实现资源复用,以下是在各级压缩时,所用到的计算结果
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的i0 ^ i1 以及 ~(i0 & i1)中间结果
    wire    i0_xor_i1_class1_ppc12       ;
    wire    i0_nand_i1_class1_ppc12      ;
   
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)时用到的i0 ^ i1 以及 ~(i0 & i1)中间结果
    wire    i0_xor_i1_class1_ppc34       ;
    wire    i0_nand_i1_class1_ppc34      ;

    //第二级压缩时用到的i0 ^ i1 以及 ~(i0 & i1)中间结果
    wire    i0_xor_i1_class2             ;
    wire    i0_nand_i1_class2            ;  

    //部分积压缩的高位有一部分可以复用4:2压缩器中的3:2压缩器的d作为中间结果
    //至于3:2压缩器的进位直接作为部分积压缩的结果,不需向另一个3:2压缩器传递
    //这一计算结果作为中间结果,实现资源复用
    //以下是在各级压缩时,所用到的3:2压缩器的中间结果
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的3:2压缩器的中间结果d
    wire    wire_3_2_d_class1_ppc12     ;

    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)时用到的3:2压缩器的中间结果d
    wire    wire_3_2_d_class1_ppc34     ;   
    
    //第二级压缩时用到的3:2压缩器的中间结果d
    wire    wire_3_2_d_class2           ;   
    
    
    
    //***************第一级压缩******************//
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第1个3:2压缩器
    compressor_3_2 compressor_3_2_class1_ppc12_1 (
        .i0 (PP1_ext[4]),
        .i1 (PP2_ext[2]),
        .ci (PP3_ext[0]),

        .co (PPC1_2[3]),
        .d  (PPC1_1[4])
    );
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第2个3:2压缩器
    compressor_3_2 compressor_3_2_class1_ppc12_2 (
        .i0 (PP1_ext[5]),
        .i1 (PP2_ext[3]),
        .ci (PP3_ext[1]),

        .co (PPC1_2[4]),
        .d  (PPC1_1[5])
    );  
    
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第1个4:2压缩器,使用不考虑进位的4:2压缩器
    non_cin_compressor_4_2 compressor_4_2_class1_ppc12_1(
        .i0  (PP1_ext[6]),
        .i1  (PP2_ext[4]),
        .i2  (PP3_ext[2]),
        .i3  (PP4_ext[0]),

        .co  (cout_class1_ppc12[0]),
        .c   (PPC1_2[5]),
        .d   (PPC1_1[6])
    );
    
    
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)的第i个4:2压缩器
    genvar i;
    generate 
        for(i=7;i<=17;i=i+1) begin: compressor_4_2_class1_ppc12_inst
            compressor_4_2 compressor_4_2_class1_ppc12_i (
                    .i0 (PP1_ext[i]),
                    .i1 (PP2_ext[i-2]),
                    .i2 (PP3_ext[i-4]),
                    .i3 (PP4_ext[i-6]),
                    .ci (cout_class1_ppc12[i-7]),  
            
                    .co (cout_class1_ppc12[i-6]),
                    .c  (PPC1_2[i-1]),
                    .d  (PPC1_1[i])
                );              
        end
    endgenerate
    

    //从PP1_ext[18](PP2_ext[16])开始,PP1_ext以及PP2_ext的更高位都是一样的数据
    //可以复用原来基本4:2压缩器中的异或门以及与非门资源
    //使用需要异或输入和与非输入的4:2压缩器nand_xor_compressor_4_2,以节约资源开销
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的i0 ^ i1 以及 ~(i0 & i1)中间结果
    assign i0_xor_i1_class1_ppc12  = PP1_ext[18] ^ PP2_ext[16]; //相当于原本4:2压缩器内部的i0 ^ i1运算
    assign i0_nand_i1_class1_ppc12 = ~(PP1_ext[18] & PP2_ext[16]);// 相当于原本4:2压缩器内部~(i0 & i1)
    
    //例化nand_xor_compressor_4_2模块
    generate 
        for(i=18;i<=19;i=i+1) begin: nand_xor_compressor_4_2_class1_ppc12_inst
            nand_xor_compressor_4_2 nand_xor_compressor_4_2_class1_ppc12_i(
                .i0_xor_i1   (i0_xor_i1_class1_ppc12 ),   //输入的i0 ^ i1
                .i0_nand_i1  (i0_nand_i1_class1_ppc12),   //输入的~(i0 & i1)
                .i2          (PP3_ext[i-4]           ),
                .i3          (PP4_ext[i-6]           ),
                .ci          (cout_class1_ppc12[i-7] ),
                        
                .co          (cout_class1_ppc12[i-6] ),
                .c           (PPC1_2[i-1]            ),
                .d           (PPC1_1[i]              )
            );           
        end
    endgenerate
    
    //从PP1_ext[20](PP2_ext[18]或PP3_ext[16])开始, PP1_ext、PP2_ext以及PP3_ext的更高位都是一样的数据
    //可以复用原来基本4:2压缩器中的一个3:2压缩器(亦即是全加器),以节省资源开销
    
    //第一级压缩产生产生部分积1(PPC1_1)和部分积2(PPC1_2)时,产生复用信号的3:2压缩器
    compressor_3_2 compressor_3_2_class1_ppc12_reused (
        .i0 (PP1_ext[20]),
        .i1 (PP2_ext[18]),
        .ci (PP3_ext[16]),

        //将复用的3:2压缩器的co端口接原本4：2压缩器的进位输出,这样4:2压缩器的进位输出和进位输入无关
        //不会造成进位链延长的问题
        .co (cout_class1_ppc12[14]),     //产生的进位信号,部分积高位产生的进位信号也是一样的,后续扩展即可
        .d  (wire_3_2_d_class1_ppc12)    //产生复用的中间数据
    ); 
    
    
    
    //例化原本4:2压缩器中的第二级3:2压缩器,3:2压缩器的i0输入接到第一级3:2压缩器产生的中间信号
    //相当于只需要例化3:2压缩器即可实现原本4:2压缩器的功能
    generate
        for(i=20;i<=23;i=i+1) begin: compressor_3_2_class1_ppc12_inst
            compressor_3_2 compressor_3_2_class1_ppc12_i (
                .i0 (wire_3_2_d_class1_ppc12), //使用复用的3:2压缩器产生的信号
                .i1 (PP4_ext[i-6]           ),
                .ci (cout_class1_ppc12[i-7] ),
        
                .co (PPC1_2[i-1]),
                .d  (PPC1_1[i])    //产生复用的中间数据
            );
        
        end
    endgenerate
    
    
    
    //补全部分积1(PPC1_1)和部分积2(PPC1_2)没有用到压缩的位置
    //没有变化的位置
    assign PPC1_1[3:0] = PP1_ext[3:0]; 
    assign PPC1_1[31:24] = {8{PPC1_1[23]}}; //将最后一个4:2的输出结果进行扩展,生成压缩后的部分积
    assign PPC1_2[1:0] = PP2_ext[1:0];
    assign PPC1_2[2] = 1'b0; //第一次使用3:2压缩器的位置，进位部分积没有进位
    assign PPC1_2[29:23] = {7{PPC1_2[22]}}; //将最后一个4:2的输出结果进行扩展,生成压缩后的部分积
    //补全进位链,高位部分积压缩时,由于4:2压缩器的i0、i1、i2输入一样,进位输出是一样的
    assign cout_class1_ppc12[18:15] = {4{cout_class1_ppc12[14]}};   
    
    
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第1个3:2压缩器
    compressor_3_2 compressor_3_2_class1_ppc34_1 (
        .i0 (PP5_ext[4]),
        .i1 (PP6_ext[2]),
        .ci (PP7_ext[0]),

        .co (PPC1_4[3]),
        .d  (PPC1_3[4])
    );
    
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第2个3:2压缩器
    compressor_3_2 compressor_3_2_class1_ppc34_2 (
        .i0 (PP5_ext[5]),
        .i1 (PP6_ext[3]),
        .ci (PP7_ext[1]),

        .co (PPC1_4[4]),
        .d  (PPC1_3[5])
    ); 

    
    
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第1个4:2压缩器,使用不考虑进位的4:2压缩器
    non_cin_compressor_4_2 compressor_4_2_class1_ppc34_1 (
        .i0 (PP5_ext[6]),
        .i1 (PP6_ext[4]),
        .i2 (PP7_ext[2]),
        .i3 (PP8_ext[0]),

        .co (cout_class1_ppc34[0]),
        .c  (PPC1_4[5]),
        .d  (PPC1_3[6])
    ); 


    
    //第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)的第i个4:2压缩器
    generate 
        for(i=7;i<=17;i=i+1) begin: compressor_4_2_class1_ppc34_inst
            compressor_4_2 nand_xor_compressor_4_2_class1_ppc34_i (
                    .i0 (PP5_ext[i]),
                    .i1 (PP6_ext[i-2]),
                    .i2 (PP7_ext[i-4]),
                    .i3 (PP8_ext[i-6]),
                    .ci (cout_class1_ppc34[i-7]),  
            
                    .co (cout_class1_ppc34[i-6]),
                    .c  (PPC1_4[i-1]),
                    .d  (PPC1_3[i])
                );              
        end
    endgenerate
    
    //从PP5_ext[18](PP6_ext[16])开始,PP5_ext以及PP6_ext的更高位都是一样的数据
    //可以复用原来基本4:2压缩器中的异或门以及与非门资源
    //使用需要异或输入和与非输入的4:2压缩器nand_xor_compressor_4_2,以节约资源开销
    //第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的i0 ^ i1 以及 ~(i0 & i1)中间结果
    assign i0_xor_i1_class1_ppc34  = PP5_ext[18] ^ PP6_ext[16]; //相当于原本4:2压缩器内部的i0 ^ i1运算
    assign i0_nand_i1_class1_ppc34 = ~(PP5_ext[18] & PP6_ext[16]);// 相当于原本4:2压缩器内部~(i0 & i1)
    
    //例化nand_xor_compressor_4_2模块
    generate 
        for(i=18;i<=19;i=i+1) begin: nand_xor_compressor_4_2_class1_ppc34_inst
            nand_xor_compressor_4_2 nand_xor_compressor_4_2_class1_ppc34_i(
                .i0_xor_i1   (i0_xor_i1_class1_ppc34 ),   //输入的i0 ^ i1
                .i0_nand_i1  (i0_nand_i1_class1_ppc34),   //输入的~(i0 & i1)
                .i2          (PP7_ext[i-4]           ),
                .i3          (PP8_ext[i-6]           ),
                .ci          (cout_class1_ppc34[i-7] ),
                        
                .co          (cout_class1_ppc34[i-6] ),
                .c           (PPC1_4[i-1]            ),
                .d           (PPC1_3[i]              )
            );           
        end
    endgenerate
    
    //从PP5_ext[20](PP6_ext[18]或PP7_ext[16])开始, PP5_ext、PP6_ext以及PP7_ext的更高位都是一样的数据
    //可以复用原来基本4:2压缩器中的一个3:2压缩器(亦即是全加器),以节省资源开销
    
    //第一级压缩产生产生部分积1(PPC1_3)和部分积2(PPC1_4)时,产生复用信号的3:2压缩器
    compressor_3_2 compressor_3_2_class1_ppc34_reused (
        .i0 (PP5_ext[20]),
        .i1 (PP6_ext[18]),
        .ci (PP7_ext[16]),

        //将复用的3:2压缩器的co端口接原本4：2压缩器的进位输出,这样4:2压缩器的进位输出和进位输入无关
        //不会造成进位链延长的问题
        .co (cout_class1_ppc34[14]),     //产生的进位信号,部分积高位产生的进位信号也是一样的,后续扩展即可
        .d  (wire_3_2_d_class1_ppc34)    //产生复用的中间数据
    ); 
    
    
    
    //例化原本4:2压缩器中的第二级3:2压缩器,3:2压缩器的i0输入接到第一级3:2压缩器产生的中间信号
    //相当于只需要例化3:2压缩器即可实现原本4:2压缩器的功能
    generate
        for(i=20;i<=22;i=i+1) begin: compressor_3_2_class1_ppc34_inst
            compressor_3_2 compressor_3_2_class1_ppc34_i (
                .i0 (wire_3_2_d_class1_ppc34), //使用复用的3:2压缩器产生的信号
                .i1 (PP8_ext[i-6]           ),
                .ci (cout_class1_ppc34[i-7] ),
        
                .co (PPC1_4[i-1]),
                .d  (PPC1_3[i])    //产生复用的中间数据
            );
        
        end
    endgenerate
    
    
    //最高位使用简化的4-2处理器,舍去产生co和c的资源
    simplify_compressor_4_2 compressor_4_2_class1_ppc34_last (
        .i0 (PP5_ext[23]),
        .i1 (PP6_ext[21]),
        .i2 (PP7_ext[19]),
        .i3 (PP8_ext[17]),
        .ci (cout_class1_ppc34[16]),  

        .d  (PPC1_3[23])
    );  
    
    //补全部分积3(PPC1_3)和部分积4(PPC1_4)没有用到压缩的位置
    //没有变化的位置
    assign PPC1_3[3:0] = PP5_ext[3:0]; 
    assign PPC1_4[1:0] = PP6_ext[1:0];
    assign PPC1_4[2] = 1'b0; //第一次使用3:2压缩器的位置，进位部分积没有进位
    
    //补全进位链,高位部分积压缩时,由于4:2压缩器的i0、i1、i2输入一样,进位输出是一样的
    assign cout_class1_ppc34[16:15] = {2{cout_class1_ppc34[14]}};
    
    
    
    //****************************************第二级压缩****************************************//
    
    
    
    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第1个3:2压缩器
    compressor_3_2 compressor_3_2_class2_ppc12_1 (
        .i0 (PPC1_1[8]),
        .i1 (PPC1_2[6]),
        .ci (PPC1_3[0]),

        .co (PPC2_2[7]),
        .d  (PPC2_1[8])
    );
    
    //第二级压缩产生部分积1(PPC2_1)和部分积2(PPC2_2)的第2个3:2压缩器
    compressor_3_2 compressor_3_2_class2_ppc12_2 (
        .i0 (PPC1_1[9]),
        .i1 (PPC1_2[7]),
        .ci (PPC1_3[1]),

        .co (PPC2_2[8]),
        .d  (PPC2_1[9])
    );
    
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
        for(i=13;i<=22;i=i+1) begin: compressor_4_2_class2_ppc12_inst
            compressor_4_2 compressor_4_2_class2_ppc12_i (
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
    
    //从PPC1_1[23](PPC1_2[21])开始,PPC1_1以及PPC1_1的更高位都是一样的数据
    //可以复用原来基本4:2压缩器中的异或门以及与非门资源
    //第二级压缩时用到的i0 ^ i1 以及 ~(i0 & i1)中间结果
    assign i0_xor_i1_class2  = PPC1_1[23] ^ PPC1_2[21]; //相当于原本4:2压缩器内部的i0 ^ i1运算
    assign i0_nand_i1_class2 = ~(PPC1_1[23] & PPC1_2[21]);// 相当于原本4:2压缩器内部~(i0 & i1)
    
    //例化nand_xor_compressor_4_2模块
    generate 
        for(i=23;i<=30;i=i+1) begin: nand_xor_compressor_4_2_class2_ppc12_inst
            nand_xor_compressor_4_2 nand_xor_compressor_4_2_class2_ppc12_i(
                .i0_xor_i1   (i0_xor_i1_class2          ),   //输入的i0 ^ i1
                .i0_nand_i1  (i0_nand_i1_class2         ),   //输入的~(i0 & i1)
                .i2          (PPC1_3[i-8]               ),
                .i3          (PPC1_4[i-10]              ),
                .ci          (cout_class2[i-11]         ),
                        
                .co          (cout_class2[i-10]         ),
                .c           (PPC2_2[i-1]               ),
                .d           (PPC2_1[i]                 )
            );           
        end
    endgenerate
    
    
    //高位使用简化的4-2处理器,舍去产生co和c的资源
    simplify_compressor_4_2 compressor_4_2_class2_ppc12_last (
        .i0 (PPC1_1[31]),
        .i1 (PPC1_2[29]),
        .i2 (PPC1_3[23]),
        .i3 (PPC1_4[21]),
        .ci (cout_class2[20]),  

        .d  (PPC2_1[31])
    );      

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
