`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/27 20:16:15
// Module Name: booth2_pp_decoder
// Description: 依据输入的3bit booth Radix-4乘数编码,解码部分积输出
// Resource:     //---------------------------------------------
                 //|  Gate  |  Gate count  | Transistor count  |
                 //---------------------------------------------
                 //|  AND   |  1           | 6                 | 
                 //|  OR    |  0           | 0                 |
                 //|  NOT   |  2           | 4                 |  
                 //|  NAND  |  0           | 0                 |
                 //|  NOR   |  5           | 20                | 
                 //|  AOI4  |  33          | 264               |
                 //|  XNOR  |  0           | 0                 |
                 //|  XOR   |  0           | 0                 |
                 //---------------------------------------------
                 //| summary|  41          | 294               |
                 //---------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
module booth2_pp_decoder(
        input wire  [2:0]       code        ,  //输入的3bit编码
        input wire  [15:0]      A           ,  //被乘数A
        input wire  [16:0]      inversed_A  ,  //取反后的被乘数(-A)
        
        output wire [17:0]      pp_out         //输出的部分积,输出18bit,注意最高位是反逻辑的
    );
    
    wire [16:0] pp_source    ;//部分积数据的来源(数据本体),可以是A或者-A
    
        //定义有关的flag信号,信号的意涵如下
    //--------------------------------------------
    //|  pp  |  flag_2x  | flag_s1   |  flag_s2  |
    //|  A   |     0     |     0     |     1     |
    //|  -A  |     0     |     1     |     0     |
    //|  2A  |     1     |     0     |     1     |   
    //|  -2A |     1     |     1     |     0     |
    //|  0   |     x     |     0     |     0     |    
    //---------------------------------------------
    
    //解码电路
    //中间变量,实现资源复用
    wire not_c2             ;  //code[2]取反
    wire c1_and_c0          ;  //code[1] & code[0]
    wire c1_nor_c0          ;  //code[1] 和 code[0]的或非结果
    wire nor_o2             ;  //构成"异或门"的第二级或非门的输出结果
    
    //三个flag信号
    wire    flag_2x         ;
    wire    flag_s1         ;
    wire    flag_s2         ;
    
    //解码电路的电路结构描述
    //一共2个非门NOT,1个与门AND,4个或非门NOR,共计26个MOS管(资源代价)
    //中间变量
    assign not_c2       = ~code[2]                  ;//非门NOT
    assign c1_and_c0    = code[1] & code[0]         ;//与门AND
    assign c1_nor_c0    = ~(code[1] | code[0])      ;//或非门NOR
    assign nor_o2       = ~(c1_and_c0 | c1_nor_c0)  ;//或非门NOR
    
    //三个flag信号
    assign flag_2x      = ~nor_o2                   ;//非门NOT
    assign flag_s1      = ~(not_c2 | c1_and_c0)     ;//或非门NOR
    assign flag_s2      = ~(code[2] | c1_nor_c0)    ;//或非门NOR
    
    
    //flag_2xflag信号的取反信号,用于部分积操作数的选择,其实就是"异或门"的输出nor_o2
    // 无需额外资源开销
    wire    flag_not_2x = nor_o2; 
    
    //使用与或非门选择输出的数据本体是A还是-A
    //当最终部分积为A、2A时,选择A作为数据本体
    //当最终部分积为-A、-2A时,选择-A作为数据本体
    //注意:这里输出的数据本体是原来数据按位取反后的结果,例如当数据本体为A时,这里输出的是~A
    //17个与或非门AOI4

    assign pp_source = ~(({{A[15]}, A}  & {17{flag_s2}}) | (inversed_A & {17{flag_s1}}));
    
    
    //通过flag_2x和flag_not_2x信号确定是否需要将数据本体乘以2
    
    //输出部分积的最低位(pp_out[0])只在部分积为A和-A时有可能为1,部分积为2A和-2A的情况下下为0
    //故只需要一个或非门实现pp_out[0]的输出
    //1个或非门NOR
    assign pp_out[0] = ~(flag_2x | pp_source[0]);
    
    //高位依据flag_2x和flag_not_2x信号来选择是否需要移位,部分积生成的逻辑表达式为
    //pp_out[i] = flag_2x & (~pp_source[i-1]) + flag_not_2x & ~(pp_source[i])
    //逻辑化简后,使用下面的连续赋值语句实现这一功能
    //16个与或非门AOI4
    assign pp_out[16:1] = ~(({16{flag_2x}} & pp_source[15:0]) | ({16{flag_not_2x}} & pp_source[16:1]));
    
    //对于部分积为A和-A的情况,pp_source[17]如果存在,则一定有pp_source[17] = pp_source[16]
    //即pp_out[17] = ~(flag_2x & pp_source[16] + flag_not_2x & pp_source[17]) = 
    // = ~(flag_2x & pp_source[16] + flag_not_2x & pp_source[16]) = ~pp_source[16];
    
    
    //这里取相反的逻辑,因为对于PP2-PP8,在部分积压缩时,不需要符号位,只需要符号位取反后的数据
    //这一操作可以节省非门的使用
    //无需额外资源开销
    assign pp_out[17] = pp_source[16];
    
endmodule
