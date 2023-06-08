`timescale 1ns / 1ps
module tb_compressor_3_2(
        
    );
    reg i0,i1;
    reg ci;
    wire c,d;
    
    initial begin
        ci = 0;
        {i1, i0} = 2'b00;
    #20
        {i1, i0} = 2'b01;       
    #20
        {i1, i0} = 2'b10;   
    #20
        {i1, i0} = 2'b11;   
    #20
        ci = 1;
        {i1, i0} = 2'b00;
    #20
        {i1, i0} = 2'b01;       
    #20
        {i1, i0} = 2'b10;   
    #20
        {i1, i0} = 2'b11;   
    end

    topmodule compressor_3_2_inst(
        .i0 (i0 ),
        .i1 (i1 ),
        .ci (ci ),
             
        .co (c  ),
        .d  (d  )
    );
endmodule
