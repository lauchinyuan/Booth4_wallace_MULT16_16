`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/10 22:03:02
// Module Name: in_0_1_compressor_4_2 
// Description: 4:2压缩器的变式,有一个输入端口确定为0,另一个输入端口确定为1的4:2压缩器
//              相当于使用等效"同或门"和等效"异或门"的级联来构成这一个压缩器
// Resource:     //--------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //|  AND   |  0           | 0                 | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  1           | 2                 |  
                 //|  NAND  |  3           | 12                |
                 //|  NOR   |  0           | 0                 | 
                 //|  AOI4  |  2           | 16                |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  6           | 30                |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module in_0_1_compressor_4_2(
        input wire i1   ,
        input wire i3   ,
        input wire ci   ,
        
        output wire co  ,
        output wire c   ,
        output wire d   
    );
    
    
    //中间数据(连线)
    wire i1_nand_i3     ; //i1和i3与非的结果,作为中间数据
    wire AOI_o1         ; //第一个与或非门(AOI4)的输出,也是第一个等效同或门的输出
    wire aoio1_nand_ci  ; //AOI_o1和ci与非的结果,作为中间数据
    wire AOI_o2         ; //第一个与或非门(AOI4)的输出
    
    
    //中间数据的产生
    //与非门
    assign i1_nand_i3       = ~(i1 & i3);
    
    //与或非门(AOI)
    assign AOI_o1           = ~((i1 & i1_nand_i3) | (i3 & i1_nand_i3));
    
    //与非门
    assign aoio1_nand_ci    = ~(ci & AOI_o1);
    
    //与或非门(AOI)
    assign AOI_o2           = ~((aoio1_nand_ci & AOI_o1) | (aoio1_nand_ci & ci));
    
    //数据输出
    assign d                = ~AOI_o2;  //非门
    assign c                = ~(aoio1_nand_ci & i1_nand_i3); //与非门
    assign co               = i1;  // co的值就是输入i1的值,与ci无关,不会产生进位链延长问题
    
    
endmodule
