`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/29 22:21:18 
// Module Name: tb_inv_converter_16
// Description: testbench for inv_converter_16
//////////////////////////////////////////////////////////////////////////////////
module tb_inv_converter_16(

    );
    reg [15:0]      data_i  ;
    wire[16:0]      inv_o   ;
    
    integer i;
    initial begin
        data_i <= 16'h8000; //测试补码表示的下界是否能正常生成相反数
        for(i=0;i<=65536;i=i+1) begin
            #20
            data_i <= $random;
        end
    
    end
    
    inv_converter_16 inv_converter_16_inst(
        .data_i (data_i ),//输入数据

        .inv_o  (inv_o  ) //输出相反数
    );
endmodule
