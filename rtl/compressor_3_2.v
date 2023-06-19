//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/09 16:39:11
// Module Name: compressor_3_2 
// Description: 3：2压缩器,实质上是全加器
//              实现异或门的内部门结构
//              并对内部结构产生的结果进行复用,减少了全加器的MOS管数量
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //--------------------------------------------
                 //|  AND   |  0           | 0                 | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  2           | 4                 |  
                 //|  NAND  |  3           | 12                |
                 //|  NOR   |  0           | 0                 | 
                 //|  AOI4  |  2           | 16                |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  7           | 32                |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module compressor_3_2(
        input wire i0   ,
        input wire i1   ,
        input wire ci   ,
        
        output wire co  ,
        output wire d   
    );
    
    //中间数据(连线)
    wire i0_nand_i1     ; //i0和i1与非的结果,作为中间数据
    wire AOI_o1         ; //第一个与或非门(AOI4)的输出
    wire xor_o1         ; //第一个等效"异或门"的输出
    wire xoro1_nand_ci  ; //xor_o1和ci与非的结果,作为中间数据
    wire AOI_o2         ; //第一个与或非门(AOI4)的输出
    
    
    //中间数据的产生
    //与非门(NAND)
    assign i0_nand_i1       = ~(i0 & i1);
    
    //与或非门(AOI4)
    assign AOI_o1           = ~((i0 & i0_nand_i1) | (i1 & i0_nand_i1));
    
    //非门(NOT)
    assign xor_o1           = ~AOI_o1;
    
    //与非门(NAND)
    assign xoro1_nand_ci    = ~(ci & xor_o1);
    
    //与或非门(AOI4)
    assign AOI_o2           = ~((xoro1_nand_ci & xor_o1) | (xoro1_nand_ci & ci));
    
    //数据输出
    //非门(NOT)
    assign d                = ~AOI_o2;
    //与非门(NAND)
    assign co               = ~(xoro1_nand_ci & i0_nand_i1);
    
    
endmodule