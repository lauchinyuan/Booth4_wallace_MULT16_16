`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Create Date: 2023/04/09 20:42:50
// Module Name: tb_mult_16_16_top
// Description: testbench for mult_16_16_top module
//////////////////////////////////////////////////////////////////////////////////
module tb_mult_16_16_top();
    reg  signed [15:0]  A_NUM   ;
    reg  signed [15:0]  B_NUM   ;
    wire        [31:0]  C_NUM   ;
    wire signed [31:0]  C_NUM_real;  //计算结果的真实值
    wire                correct ;    //计算结果正确标志
    
    
    integer i;
    initial begin
        A_NUM <= 16'h3524;  
        B_NUM <= 16'h5e81;  
    #20
        for(i=0;i<=100000;i=i+1) begin
            #20
            A_NUM = $random;
            B_NUM = $random;
            
        end
        
    end
    
    //正确结果
    assign C_NUM_real = A_NUM * B_NUM;
    
    //计算结果正确标志
    assign correct = (C_NUM_real == C_NUM);
    

    mult_16_16_top mult_16_16_top_inst(
        .A_NUM  (A_NUM),    //乘数
        .B_NUM  (B_NUM),    //被乘数

        .C_NUM  (C_NUM)     //积
    );
    
endmodule
