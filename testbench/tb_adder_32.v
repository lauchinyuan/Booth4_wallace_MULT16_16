`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/04/09 20:12:55
// Module Name: tb_adder_32
// Description: Testbench for adder_32 module
//////////////////////////////////////////////////////////////////////////////////


module tb_adder_32();
	reg [31:0] A	;
	reg [31:0] B	;
	wire[31:0] C	;
	
	initial begin
		A <= 32'b0000_0000_0000_0000_0001_0010_0111_0100;
		B <= 32'b0000_0000_0000_0000_0001_0010_0111_0100;
	end
	
	
	
	adder_32 adder_32_inst(
		.A	(A),
		.B	(B),
		.C  (C)
    );
	
endmodule
