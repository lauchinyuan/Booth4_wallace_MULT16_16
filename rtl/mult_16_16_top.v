`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/09 20:23:54
// Module Name: mult_16_16_top
// Description: 顶层模块,基于booth2乘数编码原理和wallace压缩树的16bit*16bit有符号乘法器
// Resource:     
//-----------------------------------------------------------------------------------
//|  Module                 | Module count | Transistor counts per Module  | Total  |
//-----------------------------------------------------------------------------------
//|  booth2_pp_gen          | 1            | 2582                          | 2582   |
//|  booth2_pp_compressor   | 1            | 3068                          | 3068   |
//|  adder_32               | 1            | 898                           | 898    |
//-----------------------------------------------------------------------------------
//|  summary                | 3            | **                            | 6538   |
//-----------------------------------------------------------------------------------

// Counting resources from the gate-level circuit perspective
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //--------------------------------------------
                 //|  AND   |  34          | 204               | 
                 //|  OR    |  16          | 96                |
                 //|  NOT   |  253         | 506               |  
                 //|  NAND  |  366         | 1464              |
                 //|  NOR   |  63          | 252               | 
                 //|  AOI4  |  496         | 3968              |
                 //|  XNOR  |  1           | 12                |
                 //|  XOR   |  3           | 36                |
                 //---------------------------------------------
                 //| summary|  1232        | 6538              |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module mult_16_16_top(
        input wire [15:0]   A_NUM   ,   //被乘数
        input wire [15:0]   B_NUM   ,   //乘数
        
        output wire [31:0]  C_NUM       //积
    );
    
    //由Radix-4 Booth算法生成的部分积操作数
    //未进行符号扩展和低位补零
    wire [17:0]     PP1     ;
    wire [17:0]     PP2     ;
    wire [17:0]     PP3     ;
    wire [17:0]     PP4     ;
    wire [17:0]     PP5     ;
    wire [17:0]     PP6     ;
    wire [17:0]     PP7     ;
    wire [17:0]     PP8     ;
    
    //经过wallace算法压缩后输出的两个部分积
    //PPcompressed2是30bit,产生的第二个部分积的最低2bit一定是0
    //为简化电路结构,这里直接忽略
    wire [31:0]     PPcompressed1   ;
    wire [29:0]     PPcompressed2   ;
    
    
    //生成8个部分积
    //注意:这里产生的部分积并未进行低位补零操作
    booth2_pp_gen booth2_pp_gen_inst(
        .A_NUM      (A_NUM  ),  //乘数
        .B_NUM      (B_NUM  ),  //被乘数

        .PP1        (PP1    ),
        .PP2        (PP2    ),
        .PP3        (PP3    ),
        .PP4        (PP4    ),
        .PP5        (PP5    ),
        .PP6        (PP6    ),
        .PP7        (PP7    ),
        .PP8        (PP8    )
    );
    
    // 部分积压缩模块
    booth2_pp_compressor booth2_pp_compressor_inst(

        .PP1        (PP1    ),  //8个部分积,这里的部分还未进行移位补零操作
        .PP2        (PP2    ),
        .PP3        (PP3    ),
        .PP4        (PP4    ),
        .PP5        (PP5    ),
        .PP6        (PP6    ),
        .PP7        (PP7    ),
        .PP8        (PP8    ),

        .PPout1     (PPcompressed1),//压缩后生成的两个部分积
        .PPout2     (PPcompressed2) //PPcompressed1是30位数据
    );
    
    
    //求得最后结果
    adder_32 adder_32_inst(
        .A      (PPcompressed1  ),
        .B      (PPcompressed2  ),
        
        .C      (C_NUM          )
    );
    
endmodule
