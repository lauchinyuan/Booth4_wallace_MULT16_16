`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/06/09 09:06:26
// Module Name: tb_half_adder
// Description: testbench for half_adder module
//////////////////////////////////////////////////////////////////////////////////


module tb_half_adder(

    );
    
    reg a, b;
    wire cout, sum;
    
    initial begin
        {a, b} = 2'b00;
    #20
        {a, b} = 2'b01;       
    #20
        {a, b} = 2'b10;   
    #20
        {a, b} = 2'b11;   
    end
    
    half_adder half_adder_inst(
        .a   (a   ),
        .b   (b   ),

        .cout(cout),
        .sum (sum )
    );
endmodule
