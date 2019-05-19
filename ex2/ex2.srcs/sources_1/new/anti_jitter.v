`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 22:35:08
// Design Name: 
// Module Name: anti_jitter
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


module anti_jitter(
input clk,
input btn_in,
output reg btn_out
);
reg [10:0]shift;
always @(posedge clk)begin
    shift = shift<<1;
    shift[0] = btn_in;
    if(shift == 10'b1111111111)
       btn_out = 1'b1;
    if(shift == 0)
       btn_out = 1'b0;
      end
endmodule