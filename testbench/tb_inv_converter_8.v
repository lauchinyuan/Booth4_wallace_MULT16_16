`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/07/11 16:51:21
// Module Name: tb_inv_converter_8
// Description: testbench for inv_converter_8 module
//////////////////////////////////////////////////////////////////////////////////
module tb_inv_converter_8(

    );
    reg [7:0]      data_i  ;
    wire[8:0]      inv_o   ;
    
    integer i;
    initial begin
        data_i <= 8'h80; //测试补码表示的下界是否能正常生成相反数
        for(i=0;i<=32768;i=i+1) begin
            #20
            data_i <= $random;
        end
    
    end
    
    inv_converter_8 inv_converter_8_inst(
        .data_i (data_i ),//输入数据

        .inv_o  (inv_o  ) //输出相反数
    );
endmodule
