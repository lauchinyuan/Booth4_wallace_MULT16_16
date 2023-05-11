`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/11 19:32:14
// Module Name: tb_in_0_1_compressor_4_2
// Description: testbench for in_0_1_compressor_4_2
//////////////////////////////////////////////////////////////////////////////////
module tb_in_0_1_compressor_4_2();
    reg     i1,i3,ci    ;
    wire    co,c,d      ;
    
    initial begin
        {i1,i3,ci} = 3'b000;
    #20
        {i1,i3,ci} = 3'b001;
    #20
        {i1,i3,ci} = 3'b010; 
    #20
        {i1,i3,ci} = 3'b011;
    #20
        {i1,i3,ci} = 3'b100;
    #20
        {i1,i3,ci} = 3'b101;
    #20
        {i1,i3,ci} = 3'b110;
    #20
        {i1,i3,ci} = 3'b111;       
    
    end
    
    
    in_0_1_compressor_4_2 in_0_1_compressor_4_2_inst(
            .i1     (i1  ),
            .i3     (i3  ),
            .ci     (ci  ),
                     
            .co     (co  ),
            .c      (c   ),
            .d      (d   )
        );
endmodule
