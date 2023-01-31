`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/25 17:58:38
// Design Name: 
// Module Name: qmultipler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// 延迟了2个周期
module qmultipler(
input i_clk,
input i_rst,
input [12:0] A,     // 乘数A
input [2:0] k,      // 乘数k
output reg [12:0] o_data
    );
reg [12:0] B;   
reg [12:0] C;

always@(posedge i_clk) begin
    if(i_rst) begin
        B <= 13'd0;
        C <= 13'd0;
        o_data <= 13'd0;
    end
    else begin
        case(k)
            0: begin
                B <= 13'd0;
                C <= 13'd0;
            end
            1: begin
                B <= A;
                C <= 13'd0;
            end
            2: begin
                B <= A << 1;
                C <= 13'd0;
            end
            3: begin
                B <= A << 1;
                C <= A;
            end
            4: begin
                B <= A << 2;
                C <= 13'd0;
            end
        endcase
        o_data <= B + C;
    end
end


endmodule
