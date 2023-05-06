`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/06 12:46:05
// Module Name: tb_nand_xor_compressor_4_2
// Description: testbench for nand_xor_compressor_4_2 module
//////////////////////////////////////////////////////////////////////////////////
module tb_nand_xor_compressor_4_2();
    reg i0,i1,i2,i3 ;
    reg ci          ;
    wire co,c,d     ;
    wire i0_xor_i1  ;
    wire i0_nand_i1  ;
    
    initial begin
        ci = 0;
        {i0,i1,i2,i3} = 4'b0000;
    #20
        {i0,i1,i2,i3} = 4'b0001;
    #20
        {i0,i1,i2,i3} = 4'b0010;
    #20
        {i0,i1,i2,i3} = 4'b0011;
    #20
        {i0,i1,i2,i3} = 4'b0100;
    #20
        {i0,i1,i2,i3} = 4'b0101;
    #20
        {i0,i1,i2,i3} = 4'b0110;
    #20
        {i0,i1,i2,i3} = 4'b0111;
    #20
        {i0,i1,i2,i3} = 4'b1000;
    #20                    
        {i0,i1,i2,i3} = 4'b1001;
    #20                    
        {i0,i1,i2,i3} = 4'b1010;
    #20                    
        {i0,i1,i2,i3} = 4'b1011;
    #20                    
        {i0,i1,i2,i3} = 4'b1100;
    #20                    
        {i0,i1,i2,i3} = 4'b1101;
    #20                    
        {i0,i1,i2,i3} = 4'b1110;
    #20                    
        {i0,i1,i2,i3} = 4'b1111;
    #20
        ci = 1;
        {i0,i1,i2,i3} = 4'b0000;
    #20
        {i0,i1,i2,i3} = 4'b0001;
    #20
        {i0,i1,i2,i3} = 4'b0010;
    #20
        {i0,i1,i2,i3} = 4'b0011;
    #20
        {i0,i1,i2,i3} = 4'b0100;
    #20
        {i0,i1,i2,i3} = 4'b0101;
    #20
        {i0,i1,i2,i3} = 4'b0110;
    #20
        {i0,i1,i2,i3} = 4'b0111;
    #20
        {i0,i1,i2,i3} = 4'b1000;
    #20                    
        {i0,i1,i2,i3} = 4'b1001;
    #20                    
        {i0,i1,i2,i3} = 4'b1010;
    #20                    
        {i0,i1,i2,i3} = 4'b1011;
    #20                    
        {i0,i1,i2,i3} = 4'b1100;
    #20                    
        {i0,i1,i2,i3} = 4'b1101;
    #20                    
        {i0,i1,i2,i3} = 4'b1110;
    #20                    
        {i0,i1,i2,i3} = 4'b1111;
        
    end
    
    assign i0_nand_i1 = ~(i0 & i1);
    assign i0_xor_i1 = i0 ^ i1;
    
    
    nand_xor_compressor_4_2 nand_xor_compressor_4_2_inst(
        .i0_xor_i1   (i0_xor_i1 ),   //输入的i0 ^ i1
        .i0_nand_i1  (i0_nand_i1),   //输入的~(i0 & i1)
        .i2          (i2        ),
        .i3          (i3        ),
        .ci          (ci        ),
        
        .co          (co        ),
        .c           (c         ),
        .d           (d         )
    );
    
endmodule
