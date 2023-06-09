`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/06/09 16:23:30
// Module Name: tb_inv_unit
// Description: testbench for inv_unit module
//////////////////////////////////////////////////////////////////////////////////
module tb_inv_unit(

    );
    reg a, b;
    wire xor_o, or_o;
    
    initial begin
        {a,b} <= 2'b00;
    #20 
        {a,b} <= 2'b01;
    #20 
        {a,b} <= 2'b10;
    #20 
        {a,b} <= 2'b11;        
    end
    
    
    inv_unit inv_unit_inst(
        .a       (a    ),
        .b       (b    ),
                  
        .xor_o   (xor_o),  //异或输出
        .or_o    (or_o )   //或输出
    );
endmodule
