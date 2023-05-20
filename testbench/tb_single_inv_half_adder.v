`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/20 17:04:35
// Module Name: tb_single_inv_half_adder
// Description: testbench for single_inv_half_adder module
//////////////////////////////////////////////////////////////////////////////////

module tb_single_inv_half_adder();

reg inv_a, b;
wire cout, sum;

initial begin
    {inv_a,b} = 2'b00;
#20
    {inv_a,b} = 2'b01;
#20
    {inv_a,b} = 2'b10;
#20
    {inv_a,b} = 2'b11;        


end


    single_inv_half_adder single_inv_half_adder_inst(
            .inv_a    (inv_a ),
            .b        (b     ),
                       
            .cout     (cout  ),
            .sum      (sum   )
        );
endmodule
