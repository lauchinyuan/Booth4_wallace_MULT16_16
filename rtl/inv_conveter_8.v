`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/07/11 16:41:41
// Module Name: inv_conveter_8
// Description: 将输入的8bit补码转换为对应相反数的补码
// 实质上是进行按位取反末位加一
// Attention: 考虑到8'h80的相反数是9'h080,需要9bit补码才够表达
//////////////////////////////////////////////////////////////////////////////////

module inv_converter_8(
        input wire [7:0]   data_i  ,//输入数据
        
        output wire[8:0]   inv_o    //输出相反数
    );
    
    wire [6:0]     wire_cout       ;  //进位输出连线
    wire            not_o           ;  //非门,输出连接到最后一级inv_unit_nor_out模块的一个输入端
    
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
        for(i=2;i<=5;i=i+1) begin
            inv_unit inv_unit_inst(
                .a       (data_i[i]       ),
                .b       (wire_cout[i-2]  ),
        
                .xor_o   (inv_o[i]        ),  //异或输出,作为本权值位的输出数据
                .or_o    (wire_cout[i-1]  )   //或输出,作为下一级单元的输出
            );
        end
    endgenerate
    
    //inv_o[7]、inv_o[6]的产生由资源使用量更少的inv_unit_nor_out模块生成
    inv_unit_nor_out inv_unit_nor_out_inst_6(
        .a       (data_i[6]     ),
        .b       (wire_cout[4]  ),

        .xor_o   (inv_o[6]      ),  //异或输出
        .nor_o   (wire_cout[5]  )   //或非输出
    );
    
    inv_unit_nor_out inv_unit_nor_out_inst_7(
        .a       (data_i[7]     ),
        .b       (not_o          ),  //上一级模块或非输出的取反,相当于得到或输入

        .xor_o   (inv_o[7]      ),  //异或输出
        .nor_o   (wire_cout[6]  )   //或非输出
    );
    
    
    //对产生inv_o[6]的inv_unit_nor_out模块的或非输出(nor_o)求非,相当于得到或输出
    //非门(NOT)
    assign not_o     = ~wire_cout[5]   ;
    
    //通过一个或非门得到inv_o[8]
    //或非门(NOR)
    assign inv_o[8] = ~(wire_cout[5] | data_i[7]);
    
endmodule