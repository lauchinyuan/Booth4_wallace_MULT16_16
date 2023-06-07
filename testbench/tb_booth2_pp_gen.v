`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email:lauchinyuan@yeah.net
// Create Date: 2023/04/09 17:29:39
// Module Name: tb_booth2_pp_gen
// Description: testbench for booth2_pp_gen module
//////////////////////////////////////////////////////////////////////////////////
module tb_booth2_pp_gen(

    );
    reg     [15:0] A_NUM    ;
    reg     [15:0] B_NUM    ;
    
    wire    [17:0] PP1      ;
    wire    [17:0] PP2      ;
    wire    [17:0] PP3      ;
    wire    [17:0] PP4      ;
    wire    [17:0] PP5      ;
    wire    [17:0] PP6      ;
    wire    [17:0] PP7      ;
    wire    [17:0] PP8      ;
    
    
    initial begin
        A_NUM <= 16'h8000;   //测试当A_NUM为补码表示下界时的情景
        B_NUM <= 16'b0000_0000_0001_1001;
    #20
        A_NUM <= 16'b0000_0000_0000_0001;
        B_NUM <= 16'b0000_0000_0000_0001;
    #20
        A_NUM <= 16'b0000_0000_0000_1001;
        B_NUM <= 16'b0000_0000_0000_1001;
    #20
        A_NUM <= 16'b0000_0000_0001_1001;
        B_NUM <= 16'b0000_0000_0001_1001;
        
    end
    
    booth2_pp_gen booth2_pp_gen_inst(
        .A_NUM      (A_NUM  ),//乘数
        .B_NUM      (B_NUM  ),//被乘数

        .PP1        (PP1    ),
        .PP2        (PP2    ),
        .PP3        (PP3    ),
        .PP4        (PP4    ),
        .PP5        (PP5    ),
        .PP6        (PP6    ),
        .PP7        (PP7    ),
        .PP8        (PP8    )
    );
endmodule
