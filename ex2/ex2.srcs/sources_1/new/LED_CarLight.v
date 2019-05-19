`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/08 14:17:03
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


module LED_CarLight(
	input LT,
	input RT,
	input BR,
	input EM,
	input clk,
	output  LR, RR, beep,
	output [7:0]duan,
	output [2:0]wei
);

reg[1:0] temp;
assign LR=temp[0];
assign RR=temp[1];
reg b;
assign beep=b;
wire[3:0] in;

parameter countbits = 50000000;
parameter emergent = 16'hBA9E;

parameter anti_sum= 1250000;
reg[31:0] anti_counter = 0; 
reg anti_clk;

reg[31:0] divclk = 0; 
reg counter=0;//低频时钟
reg[15:0]cnt=16'd0;
reg cnter=0;

  anti_jitter aj0(.clk(anti_clk),.btn_in(LT),.btn_out(in[0]));
  anti_jitter aj1(.clk(anti_clk),.btn_in(RT),.btn_out(in[1]));
  anti_jitter aj2(.clk(anti_clk),.btn_in(BR),.btn_out(in[2]));
  anti_jitter aj3(.clk(anti_clk),.btn_in(EM),.btn_out(in[3]));
reg[15:0] out;

///////////////////////////////////////////////////////////////////////////
reg[2:0] an=3'b111;//位码
reg[7:0] seg=8'b00000000;//段码 
assign wei = an;
assign duan = seg;
reg counter2=0;//分频时钟二号，用于数码管显示 
reg[14:0] divclk2=0;//分频时钟二号，用于数码管显示 
parameter maxcnt=25000;//封频，使得每个数码管位亮1毫秒 50000分频 
reg[1:0] div_bit=0;//记录亮的位 0~3
always @(posedge clk)
begin
	if(divclk2==maxcnt)
	begin
		counter2=~counter2;
		divclk2=0;
	end
	else
	begin
		divclk2=divclk2+1'b1;
	end
end
always @(posedge counter2)//bit从0~3进入接下来的程序 
begin
	if(div_bit>=3)
		div_bit=0;
	else
		div_bit=div_bit+1'b1;

	case(div_bit)
	2'h0:
		begin	an =  3'b001;end
	2'h1:
		begin	an =  3'b010;end
	2'h2:
		begin	an =  3'b100;end
	2'h3:
		begin	an =  3'b000;end
	endcase
end
////////////////////////////////////////////////////////////////////


always  @(in or counter or cnter) 
begin
case(in)
4'b0000:out=16'b0000_0000_0000_0001;//0
4'b0001:out=16'b0000_0000_0000_0010;//1
4'b0010:out=16'b0000_0000_0000_0100;//2
4'b0011:out=16'b0000_0000_0000_1000;//3
4'b0100:out=16'b0000_0000_0001_0000;//4
4'b0101:out=16'b0000_0000_0010_0000;//5
4'b0110:out=16'b0000_0000_0100_0000;//6
4'b0111:out=16'b0000_0000_1000_0000;//7
4'b1000:out=16'b0000_0001_0000_0000;//8
4'b1001:out=16'b0000_0010_0000_0000;//9
4'b1010:out=16'b0000_0100_0000_0000;//10
4'b1011:out=16'b0000_1000_0000_0000;//11
4'b1100:out=16'b0001_0000_0000_0000;//12
4'b1101:out=16'b0010_0000_0000_0000;//13
4'b1110:out=16'b0100_0000_0000_0000;//14
4'b1111:out=16'b1000_0000_0000_0000;//15
endcase
//需要闪烁 
//LT左转弯开关-使得左边的灯闪烁 
if (out[8]||out[9]||out[10]||out[11])
	begin
		temp[1] = 1'b0;
		if(counter)
		begin
			b=1'b1;
			temp[0] = 1'b1;
		end
		else
		begin
			b=1'b0;
			temp[0] = 1'b0;
		end
		case(an)/////////////////////////////////////////////////////////
			3'b001:
				seg = 8'b0100_0000;
			3'b010:
				seg = 8'b0100_0000;
			3'b100:
				seg = 8'b0111_1001;
			default:
				seg = 8'b0000_0000;
		endcase/////////////////////////////////////////////////////////

	end

//需要闪烁 
//RT右转弯开关-使得右边的灯闪烁
else if (out[4]||out[5]||out[6]||out[7])
begin
	temp[0] = 1'b0;
	if(counter)
	begin
		b=1'b1;
		temp[1] = 1'b1;
	end
	else
	begin
		b=1'b0;
		temp[1] = 1'b0;
	end

	case(an)//////////////////////////////////////////////////////////
		3'b001:
			seg = 8'b0100_1111;
		3'b010:
			seg = 8'b0100_0000;
		default:
			seg = 8'b0100_0000;
	endcase//////////////////////////////////////////////////////////

end

//BR紧急刹车开关-使得两边的灯都亮
else if (out[2] ||out[3])
begin
    temp[0] = 1'b1;
    temp[1] = 1'b1;

	case(an)///////////////////////////////////////////////////
		3'b001:
			seg = 8'b0101_0000;
		3'b010:
			seg = 8'b0111_1111;
		default:
			seg = 8'b0000_0000;
	endcase///////////////////////////////////////////////////

end

//需要闪烁 
//EM紧急情况开关-使得两边的灯都闪烁 
else if (out[1] == 1'b1)
begin
	if(counter)
	begin
		temp[0]=1'b0;
		temp[1]=1'b0;
		seg = 8'b0000_0000;
	end
	else
	begin
		temp[0]=1'b1;
		temp[1]=1'b1;
		
		case(an)////////////////////////////////////////////////
			3'b001:
				seg = 8'b1111_1001;
			default:
				seg = 8'b0000_0000;
		endcase/////////////////////////////////////////////////
	end
	if(cnter)
		b=1'b0;
	else
		b=1'b1;

end

//else//本块共有RR和LR两个元素，必须保证它们一定会经过赋值，不然在不赋值的情况中会生成latch
//begin
//	temp[0] = 1'b0;
//	temp[1] = 1'b0;
//end
else if(out[0])//本块共有RR和LR两个元素，必须保证它们一定会经过赋值，不然在不赋值的情况中会生成latch/////////
begin
	temp[0] = 1'b0;
	temp[1] = 1'b0;
	seg = 8'b0000_0000;/////////////////////////////////////
end

else//Error
begin
	temp[0] = 1'b0;
	temp[1] = 1'b0;
	case(an)/////////////////////////////////////////////////
		3'b001:
			seg = 8'b1101_0000;
		3'b010:
			seg = 8'b0101_0000;
		3'b100:
			seg = 8'b0111_1001;
		default:
			seg = 8'b0000_0000;
	endcase///////////////////////////////////////////////////
end

end

always @(posedge clk)
begin
	if(divclk==countbits)
	begin
		counter=~counter;
		divclk=0;
	end
	else
	begin
		divclk=divclk+1'b1;
	end
	if(cnt==emergent)
	begin
		cnter=~cnter;
		cnt=0;
	end
	else
		cnt=cnt+1'b1;
	
	
	if(anti_counter==anti_sum)
	begin
		anti_clk=~anti_clk;
		anti_counter=0;
	end
	else
	begin 
		anti_counter=anti_counter+1'b1;
	end 
end

endmodule
