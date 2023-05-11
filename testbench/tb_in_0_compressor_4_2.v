`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/10 21:56:06
// Module Name: tb_in_0_compressor_4_2
// Description: testbench for in_0_compressor_4_2 module
//////////////////////////////////////////////////////////////////////////////////
module tb_in_0_compressor_4_2();
    
    reg i1,i2,i3,ci;
    wire co,c,d;
    
    initial begin
        {i1,i2,i3,ci} = 4'b0000;
    #20
        {i1,i2,i3,ci} = 4'b0001;
    #20
        {i1,i2,i3,ci} = 4'b0010;
    #20
        {i1,i2,i3,ci} = 4'b0011;
    #20
        {i1,i2,i3,ci} = 4'b0100;
    #20
        {i1,i2,i3,ci} = 4'b0101;
    #20
        {i1,i2,i3,ci} = 4'b0110;
    #20
        {i1,i2,i3,ci} = 4'b0111;
    #20
        {i1,i2,i3,ci} = 4'b1000;
    #20                    
        {i1,i2,i3,ci} = 4'b1001;
    #20                    
        {i1,i2,i3,ci} = 4'b1010;
    #20                    
        {i1,i2,i3,ci} = 4'b1011;
    #20                    
        {i1,i2,i3,ci} = 4'b1100;
    #20                    
        {i1,i2,i3,ci} = 4'b1101;
    #20                    
        {i1,i2,i3,ci} = 4'b1110;
    #20                    
        {i1,i2,i3,ci} = 4'b1111;
        
    end
    
    
    in_0_compressor_4_2 in_0_compressor_4_2_inst(
        .i1      (i1 ),
        .i2      (i2 ),
        .i3      (i3 ),
        .ci      (ci ),

        .co      (co ),
        .c       (c  ),
        .d       (d  )

    );
endmodule
