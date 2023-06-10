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
    
    //第一个取反单元inv_unit
    inv_unit inv_unit_bit1(
        .a       (data_i[1]     ),
        .b       (data_i[0]     ),

        .xor_o   (inv_o[1]      ),  //异或输出,作为本权值位的输出数据
        .or_o    (wire_cout[0]  )   //或输出,作为下一级单元的输出
    );
    
    
    //中间位置的取反单元inv_unit
    genvar i;
    generate 
        for(i=2;i<=15;i=i+1) begin
            inv_unit inv_unit_inst(
                .a       (data_i[i]     ),
                .b       (wire_cout[i-2]),
        
                .xor_o   (inv_o[i]      ),  //异或输出,作为本权值位的输出数据
                .or_o    (wire_cout[i-1]  )   //或输出,作为下一级单元的输出
            );
        end
    endgenerate
    
    //inv_o[17]直接由上一级半加器进位输出 以及输入数据的符号位异或运算产生
    assign inv_o[16] = (wire_cout[14] ^ data_i[15]);
    
endmodule