`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/09 20:12:55
// Module Name: tb_adder_32
// Description: Testbench for adder_32 module
//////////////////////////////////////////////////////////////////////////////////
module tb_adder_32();
    //实际模块输入是有错位的,即是B的最低两位没有补零,导致模块中输入的B是29bit
    //为了方便在Modelsim中观察,使用补零后的字长,但B输入模块时,将低两位数据舍去
    reg signed  [31:0]  A_FULL              ;  
    reg signed  [31:0]  B_FULL              ;
    wire        [31:0]  C                   ;
    wire signed [31:0]  ture_value          ;  //仿真计算出来的真实值
    wire                error_flag          ;  //计算错误标志
    
    integer i;
    
    initial begin
        A_FULL <= $random;
        B_FULL[1:0] <= 2'b00;   //adder_32模块功能默认B_FULL[1:0]必须为2'b00,B_FULL[4]和B_FULL[8]也必须为0;
        B_FULL[4] <= 1'b0;
        B_FULL[8] <= 1'b0;

        B_FULL[31:9] <= $random;//B_FULL其他位随机产生
        B_FULL[7:5] <= $random;
        B_FULL[3:2] <= $random;
        
        for(i=0;i<=100;i=i+1) begin //再产生100个随机测试向量
        #20
            A_FULL <= $random;
            B_FULL[31:9] <= $random;    //B_FULL其他位随机产生
            B_FULL[7:5] <= $random;
            B_FULL[3:2] <= $random;
        end
    end
    
    //真实的计算结果
    assign ture_value = A_FULL + B_FULL ;
    //错误标志信号
    assign error_flag = (ture_value == C);
    
    
    
    adder_32 adder_32_inst(
        .A      (A_FULL[31:0]   ),
        .B      (B_FULL[31:2]   ),
                    
        .C      (C              )
    );
    
endmodule
