`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: booth2_pp_gen 
// Description: 利用Radix-4 Booth算法产生16*16乘法器的8个部分积操作数

// Counting resources from the module perspective
// Resource: 
//----------------------------------------------------------------------------------------
//|  Module/Gate            | Module count | Transistor counts per Module/Gate  | Total  |
//----------------------------------------------------------------------------------------
//|  inv_converter_16       | 1            | 242                                | 242    |
//|  booth2_pp_decoder_pp1  | 1            | 274                                | 274    |
//|  booth2_pp_decoder      | 7            | 294                                | 2058   |
//----------------------------------------------------------------------------------------
//|  summary                | 9            | **                                 | 2574   |
//----------------------------------------------------------------------------------------

// Counting resources from the gate-level circuit perspective
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //--------------------------------------------
                 //|  AND   |  20          | 120               | 
                 //|  OR    |  15          | 90                |
                 //|  NOT   |  16          | 32                |  
                 //|  NAND  |  17          | 68                |
                 //|  NOR   |  38          | 152               | 
                 //|  AOI4  |  264         | 2112              |
                 //|  XNOR  |  0           | 12                |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  370         | 2574              |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_gen(
        input wire [15:0]   A_NUM   ,   //被乘数
        input wire [15:0]   B_NUM   ,   //乘数
        
        //注意:这里产生的部分积并未进行补零操作
        //部分积操作数的位宽为18位,这是由于-2A需要使用PP[17]来表示其符号
        output wire [17:0]  PP1     ,
        output wire [17:0]  PP2     ,
        output wire [17:0]  PP3     ,
        output wire [17:0]  PP4     ,
        output wire [17:0]  PP5     ,
        output wire [17:0]  PP6     ,
        output wire [17:0]  PP7     ,
        output wire [17:0]  PP8     
    );
    //用于产生8个部分积的编码
    wire [1:0]  B_code1 ;
    wire [2:0]  B_code2 ;
    wire [2:0]  B_code3 ;
    wire [2:0]  B_code4 ;
    wire [2:0]  B_code5 ;
    wire [2:0]  B_code6 ;
    wire [2:0]  B_code7 ;
    wire [2:0]  B_code8 ;
    
    //部分积由-1*A
    wire [16:0] inversed_A  ;//-1*A
    
    
    //产生-1*A,使用专用的电路,而不使用加法器,减少资源开销
    inv_converter_16 inv_converter_16_inst(
        .data_i (A_NUM),//输入数据

        .inv_o  (inversed_A) //输出相反数
);
    
    assign B_code1 = B_NUM[1:0]         ;
    assign B_code2 = B_NUM[3:1]         ;
    assign B_code3 = B_NUM[5:3]         ;
    assign B_code4 = B_NUM[7:5]         ;
    assign B_code5 = B_NUM[9:7]         ;
    assign B_code6 = B_NUM[11:9]        ;
    assign B_code7 = B_NUM[13:11]       ;
    assign B_code8 = B_NUM[15:13]       ;
    
    //通过例化7个booth2_pp_decoder模块和1个booth2_pp_decoder_pp1得到8个部分积
    
    
    //原本要输入3bit乘数,对于第一个部分积的生成,最低位编码一定为0
    //PP1的产生使用简化版的pp_decoder,即booth2_pp_decoder_pp1
    //PP1
    booth2_pp_decoder_pp1 booth2_pp_decoder_pp1(
        .code_2bit   (B_code1    ),  
        .A           (A_NUM      ),  //被乘数A
        .inversed_A  (inversed_A ),  //取反后的被乘数(-A)

        .pp_out      (PP1        )   //输出的部分积操作数,输出18bit
    );


    //PP2
    booth2_pp_decoder booth2_pp_decoder_pp2(
        .code       (B_code2            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP2                )   //输出的部分积操作数,输出18bit
    );

    //PP3
    booth2_pp_decoder booth2_pp_decoder_pp3(
        .code       (B_code3            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP3                )   //输出的部分积操作数,输出18bit
    );

    //PP4
    booth2_pp_decoder booth2_pp_decoder_pp4(
        .code       (B_code4            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP4                )   //输出的部分积操作数,输出18bit
    );

    //PP5
    booth2_pp_decoder booth2_pp_decoder_pp5(
        .code       (B_code5            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP5                )   //输出的部分积操作数,输出18bit
    );

    //PP6
    booth2_pp_decoder booth2_pp_decoder_pp6(
        .code       (B_code6            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP6                )   //输出的部分积操作数,输出18bit
    );

    //PP7
    booth2_pp_decoder booth2_pp_decoder_pp7(
        .code       (B_code7            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP7                )   //输出的部分积操作数,输出18bit
    );

    //PP8
    booth2_pp_decoder booth2_pp_decoder_pp8(
        .code       (B_code8            ),  //输入的3bit编码
        .A          (A_NUM              ),  //被乘数A
        .inversed_A (inversed_A         ),  //取反后的被乘数(-A)

        .pp_out     (PP8                )   //输出的部分积操作数,输出18bit
    );
    
    
endmodule
