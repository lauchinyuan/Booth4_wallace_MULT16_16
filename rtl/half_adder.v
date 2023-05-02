`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/04/09 19:53:30
// Module Name: half_adder
//////////////////////////////////////////////////////////////////////////////////


module half_adder(
        input wire  a   ,
        input wire  b   ,
        
        output wire cout,
        output wire sum 
    );
    
    assign cout = a & b;
    assign sum  = a ^ b;
endmodule
