`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/20 13:46:12
// Module Name: tb_inv_half_adder
// Description: testbench for inv_half_adder module
//////////////////////////////////////////////////////////////////////////////////
module tb_inv_half_adder();
    reg inv_a, inv_b;
    wire cout, sum;
    
    initial begin
        {inv_a,inv_b} = 2'b00;
    #20
        {inv_a,inv_b} = 2'b01;
    #20
        {inv_a,inv_b} = 2'b10;
    #20
        {inv_a,inv_b} = 2'b11;        
    
    
    end

inv_half_adder inv_half_adder(
         .inv_a   (inv_a),
         .inv_b   (inv_b),

         .cout    (cout ),
         .sum     (sum  )
    );
endmodule
