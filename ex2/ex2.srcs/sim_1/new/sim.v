`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 23:17:03
// Design Name: 
// Module Name: LED_CarLight
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
module sim();
 reg clk,LT,RT,BR,EM;
//   wire light;
   parameter period1 = 20;
   parameter period2 = 2;
   LED_CarLight dut(
   .clk(clk),
   .LT(LT),
   .RT(RT),
   .BR(BR),
   .EM(EM)
//   .light(light)
   );
   always begin
       clk=1'b0;
       #(period1/2);
       clk=1'b1;
       #(period1/2);
      end
    always begin
    //��ת 
    	LT=1'b1;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
       #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
       #(period2*100);
    //��ת 
        LT=1'b0;
        RT=1'b1;
        BR=1'b0;
        EM=1'b0;
       #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*100);
    //ɲ�� 
        LT=1'b0;
        RT=1'b0;
        BR=1'b1;
        EM=1'b0;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*100);
    //������� 
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b1;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*100);
    //ͬʱѡ������ת 
        LT=1'b1;
        RT=1'b1;
        BR=1'b0;
        EM=1'b0;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*1000);
    //ͬʱѡ����ת��ɲ�� 
        LT=1'b1;
        RT=1'b0;
        BR=1'b1;
        EM=1'b0;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*1000);
    //ͬʱѡ����ת��ɲ�� 
        LT=1'b0;
        RT=1'b1;
        BR=1'b1;
        EM=1'b0;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*1000);
    //ͬʱѡ��BR��EM
        LT=1'b0;
        RT=1'b0;
        BR=1'b1;
        EM=1'b1;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*1000);
    //ͬʱѡ����ת������ 
        LT=1'b1;
        RT=1'b0;
        BR=1'b0;
        EM=1'b1;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*1000);
    //ͬʱѡ����ת������ 
        LT=1'b0;
        RT=1'b1;
        BR=1'b0;
        EM=1'b1;
        #20;
        LT=1'b0;
        RT=1'b0;
        BR=1'b0;
        EM=1'b0;
        #(period2*1000);
        end
endmodule
