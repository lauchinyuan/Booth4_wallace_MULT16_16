`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/20 14:28:52
// Module Name: inv_converter_16
// Description: 将输入的16bit补码转换为对应相反数的补码
// 实质上是进行按位取反末位加一,加一过程使用自行设计的专用"加一器",无需使用乘法器,节省了电路资源开销
//////////////////////////////////////////////////////////////////////////////////
module inv_converter_16(
        input wire [15:0]   data_i  ,//输入数据
        
        output wire[15:0]   inv_o    //输出相反数
    );
    
    wire [15:0]     bit_inv_data    ;  //按位取反后的数据
    wire [13:0]     wire_cout       ;  //进位输出连线
    
    //对取反后的数据加一
    //由于16bit数据 1表示为16'b0000_0000_0000_0001
    //仅最低位为1,其它位全是0,故使用半加器级联即可
    
    //inv_o最低位输出直接是data_i最低位
    //按位取反再加一,最低位不变
    assign inv_o[0] = data_i[0];
    


    //inv_o[14:1]位由14半加器级联产生
    //第一个半加器,两个输入都是原来数据取反后的数据,可以使用inv_half_adder模块,节省电路资源
    inv_half_adder inv_half_adder_bit1 (
            .inv_a      (data_i[1]),  //本权值数据
            .inv_b      (data_i[0]),  //来自上一级的进位输入

            .cout   (wire_cout[0]   ),
            .sum    (inv_o[1]       )
        );   

    genvar i;
    generate 
        for(i=2;i<=14;i=i+1) begin
            half_adder half_adder_inst (
                    .a      (bit_inv_data[i]),  //本权值数据
                    .b      (wire_cout[i-2] ),  //来自上一级的进位输入
        
                    .cout   (wire_cout[i-1] ),
                    .sum    (inv_o[i]       )
                );      
        end
    endgenerate
    
    //inv_o[15]直接由上一级半加器进位输出 以及本权值的输入数据同或产生
    assign inv_o[15] = ~(wire_cout[13] ^ data_i[15]);
    
    //按位取反,使用16个非门
    assign bit_inv_data = ~data_i;  
    
endmodule