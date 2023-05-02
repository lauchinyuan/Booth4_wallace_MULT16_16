`timescale 1ns / 1ps
//实质上是全加器
module compressor_3_2(
        input wire i0   ,
        input wire i1   ,
        input wire ci   ,
        
        output wire co  ,
        output wire d   
    );
    
    wire        i0xori1         ;  //中间信号，i0和i1的异或
    wire        i0nandi1        ;  //中间信号，i0和i1的与非
    wire        i0xori1_nandci  ;  //中间信号，i0和i1的异或再与ci与非
    
    assign  i0xori1             = i0 ^ i1           ;
    assign  i0nandi1            = ~(i0 & i1)        ;
    assign  i0xori1_nandci      = ~(i0xori1 & ci)   ;
    
    assign d = i0xori1 ^ ci;
    assign co = ~(i0xori1_nandci & i0nandi1);
    
/*  assign d = i0 ^ i1 ^ ci;
    assign co = (i0 & i1) | (ci & (i0 | i1)); */
    
    
endmodule
