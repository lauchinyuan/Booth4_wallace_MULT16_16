`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/05/20 14:28:52
// Module Name: inv_converter_16
// Description: 将输入的16bit补码转换为对应相反数的补码
// 实质上是进行按位取反末位加一
// Attention: 考虑到16'h8000的相反数是17'h08000,需要17bit补码才够表达
//////////////////////////////////////////////////////////////////////////////////
module inv_converter_16(
        input wire [15:0]   data_i  ,//输入数据
        
        output wire[16:0]   inv_o    //输出相反数
    );
    
    wire [14:0]     wire_cout       ;  //进位输出连线
    
    //inv_o最低位输出直接是data_i最低位
    //按位取反再加一,最低位不变
    assign inv_o[0] = data_i[0];
    
    //inv_o[15:1]位由14半加器级联产生
    //第一个半加器,两个输入都是原来数据取反后的数据,可以使用inv_half_adder模块,节省电路资源
    inv_half_adder inv_half_adder_bit1 (
            .inv_a  (data_i[1]      ),  //本权值数据
            .inv_b  (data_i[0]      ),  //来自上一级的进位输入

            .cout   (wire_cout[0]   ),
            .sum    (inv_o[1]       )
        );   

    //中间位置的半加器使用有一个端口为数据取反的半加器(single_inv_half_adder)
    genvar i;
    generate 
        for(i=2;i<=15;i=i+1) begin
            single_inv_half_adder single_inv_half_adder_inst (
                    .inv_a  (data_i[i]      ),  //本权值数据
                    .b      (wire_cout[i-2] ),  //来自上一级的进位输入
        
                    .cout   (wire_cout[i-1] ),
                    .sum    (inv_o[i]       )
                );      
        end
    endgenerate
    
    //inv_o[16]直接由上一级半加器进位输出 以及输入数据的符号位进行同或产生
    assign inv_o[16] = ~(wire_cout[14] ^ data_i[15]);
    
endmodule