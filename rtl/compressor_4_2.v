`timescale 1ns / 1ps

module compressor_4_2(
        input wire i0   ,
        input wire i1   ,
        input wire i2   ,
        input wire i3   ,
        input wire ci   ,
        
        output wire co  ,
        output wire c   ,
        output wire d   
    );
    
    wire xored_i0123    ;   //中间变量i0 ^ i1 ^ i2 ^ i3
    
    assign xored_i0123 = i0 ^ i1 ^ i2 ^ i3;
    
    assign d = xored_i0123 ^ ci;
    assign co = (i0 | i1) & (i2 | i3);
    assign c = (xored_i0123 & ci) | ~(xored_i0123 | ~((i0 & i1) | (i2 & i3)));
    
endmodule
