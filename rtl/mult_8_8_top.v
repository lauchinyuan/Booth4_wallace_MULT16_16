`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/07/11 16:09:54
// Module Name: mult_8_8_top
// Description: 顶层模块,基于booth2乘数编码原理和wallace压缩树的8bit*8bit有符号乘法器
//////////////////////////////////////////////////////////////////////////////////
module mult_8_8_top(
        input wire [7:0]   A_NUM   ,   //被乘数
        input wire [7:0]   B_NUM   ,   //乘数
        
        output wire[15:0]  C_NUM       //积
    );
    
    //由Radix-4 Booth算法生成的部分积操作数
    //未进行符号扩展和低位补零
    wire [9:0]     PP1     ;
    wire [9:0]     PP2     ;
    wire [9:0]     PP3     ;
    wire [9:0]     PP4     ;
    
    //经过wallace算法压缩后输出的两个部分积
    wire [15:0]     PPcompressed1   ;
    wire [14:0]     PPcompressed2   ;
    
    
    //生成4个部分积
    //注意:这里产生的部分积并未进行低位补零操作
    booth2_pp_gen booth2_pp_gen_inst(
        .A_NUM      (A_NUM  ),  //乘数
        .B_NUM      (B_NUM  ),  //被乘数

        .PP1        (PP1    ),
        .PP2        (PP2    ),
        .PP3        (PP3    ),
        .PP4        (PP4    )
    );
    
    // 部分积压缩模块
    booth2_pp_compressor booth2_pp_compressor_inst(

        .PP1        (PP1    ),  //4个部分积,这里的部分还未进行移位补零操作
        .PP2        (PP2    ),
        .PP3        (PP3    ),
        .PP4        (PP4    ),

        .PPout1     (PPcompressed1),//压缩后生成的两个部分积
        .PPout2     (PPcompressed2) //PPcompressed1是30位数据
    );
    
    
    //求得最后结果
    adder_16 adder_16_inst(
        .A      (PPcompressed1  ),
        .B      (PPcompressed2  ),
        
        .C      (C_NUM          )
    );
    
endmodule
