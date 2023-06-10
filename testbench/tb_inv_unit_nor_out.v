`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/06/10 22:23:17
// Module Name: tb_inv_unit_nor_out
// Description: testbench for inv_unit_nor_out module
//////////////////////////////////////////////////////////////////////////////////


module tb_inv_unit_nor_out(

    );
    reg a, b;
    wire xor_o, nor_o;
    
    initial begin
        {a, b} = 2'b00;
    #20
        {a, b} = 2'b01;
    #20
        {a, b} = 2'b10;
    #20
        {a, b} = 2'b11;
    end
    
    inv_unit_nor_out inv_unit_nor_out_inst(
        .a       (a    ),
        .b       (b    ),
                  
        .xor_o   (xor_o),  //异或输出
        .nor_o   (nor_o)   //或非输出
    );
endmodule
