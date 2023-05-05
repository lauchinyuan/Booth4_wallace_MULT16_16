`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/05 15:29:19
// Module Name: tb_non_cin_compressor_4_2
// Description: testbench for non_cin_compressor_4_2
//////////////////////////////////////////////////////////////////////////////////
module tb_non_cin_pp_compressor_4_2();
    reg i0,i1,i2,i3;
    wire co,c,d;
    
    initial begin
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

    non_cin_compressor_4_2 non_cin_compressor_4_2(
            .i0  (i0 ),
            .i1  (i1 ),
            .i2  (i2 ),
            .i3  (i3 ),

            .co  (co ),
            .c   (c  ),
            .d   (d  )
    );
    
endmodule
