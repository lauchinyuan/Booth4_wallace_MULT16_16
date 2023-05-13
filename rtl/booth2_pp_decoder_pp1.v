`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/04 12:43:48
// Module Name: booth2_pp_decoder_pp1
// Description: 产生部分积pp1的专用解码器
//booth算法对于第一个部分积，输入的三位booth编码为{b1,b0,b-1},其中b-1一定为0,故可以使用专用结构来简化电路
//////////////////////////////////////////////////////////////////////////////////


module booth2_pp_decoder_pp1(
        input wire  [1:0]       code_2bit   ,  //原本要输入3bit booth编码,对于一个部分积只需要2bit,最低位编码一定为0
        input wire  [15:0]      A           ,  //被乘数A
        input wire  [15:0]      inversed_A  ,  //取反后的被乘数(-A)
        
        output wire [16:0]      pp_out         //输出的部分积,输出17bit
    );
    
    wire [15:0] pp_source       ;//部分积数据的来源(数据本体),可以是A或者-A
    
    //可以复用的信号作为中间变量
    wire not_code0 ;
    assign not_code0 = ~code_2bit[0];
    
    
    
    
    //定义有关的flag信号,信号的意涵如下
    //--------------------------------------------
    //|  pp  |  flag_2x  | flag_s1   |  flag_s2  |
    //|  A   |     0     |     0     |     1     |
    //|  -A  |     0     |     1     |     0     |
    //|  2A  |     1     |     0     |     1     |   
    //|  -2A |     1     |     1     |     0     |
    //|  0   |     x     |     0     |     0     |    
    //---------------------------------------------
    
    wire    flag_2x       ;
    wire    flag_s1       ;
    wire    flag_s2       ;    
    
    assign  flag_2x = not_code0;  //使用非门产生flag_2x
    assign  flag_s1 = code_2bit[1]; //flag_s1的生成无需新增额外电路资源
    assign  flag_s2 = ~(code_2bit[1] | not_code0);  //使用或非门实现flag_s2信号生成
    
    //产生flag_2xflag信号的取反信号,作为中间变量,实现资源复用
    wire    flag_not_2x = ~flag_2x;
    
    //使用与或非门选择输出的数据本体是A还是-A
    //当最终部分积为A、2A时,选择A作为数据本体
    //当最终部分积为-A、-2A时,选择-A作为数据本体
    //注意:这里输出的数据本体是原来数据按位取反后的结果,例如当数据本体为A时,这里输出的是~A
    assign pp_source = ~((A  & {16{flag_s2}}) | (inversed_A & {16{flag_s1}}));
    
    
    //通过flag_2x和flag_not_2x信号确定是否需要将数据本体乘以2
    
    //输出部分积的最低位(pp_out[0])只在部分积为A和-A时有可能为1,部分积为2A和-2A的情况下下为0
    //这里需要一个或非门实现pp_out[0]的输出
    assign pp_out[0] = ~(flag_2x | pp_source[0]);
    
    //高位依据flag_2x和flag_not_2x信号来选择是否需要移位,部分积生成的逻辑表达式为
    //pp_out[i] = flag_2x & (~pp_source[i-1]) + flag_not_2x & ~(pp_source[i])
    //通过化简逻辑表达式,使用15个与或非门实现pp_out[15:1]
    assign pp_out[15:1] = ~(({15{flag_2x}} & pp_source[14:0]) | ({15{flag_not_2x}} & pp_source[15:1]));
    
    //对于部分积为A和-A的情况,pp_source[16]如果存在,则一定有pp_source[16] = pp_source[15]
    //即pp_out[16] = ~(flag_2x & pp_source[15] + flag_not_2x & pp_source[16]) = 
    // = ~(flag_2x & pp_source[15] + flag_not_2x & pp_source[15]) = ~pp_source[15];
    //assign pp_out[16] = ~(flag_2x & pp_source[15] + flag_not_2x & pp_source[15]);
    assign pp_out[16] = ~pp_source[15];
endmodule
