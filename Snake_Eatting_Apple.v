module Snake_Eatting_Apple//苹果产生控制模块
(
	input CLK_50M,
	input RSTn,
	
	input [5:0] head_x,
	input [5:0] head_y,
	
	output reg [5:0] apple_x,
	output reg [4:0] apple_y,

	output reg add_cube
);
/***************************************************************************/
	reg [31:0] clk_cnt;
	reg [10:0] random_num;
	
	always@(posedge CLK_50M)
		random_num <= random_num + 11'd927;  //用加法产生随机数  
		//随机数高5位为苹果X坐标 低5位为苹果Y坐标
	
	always@(posedge CLK_50M or negedge RSTn)
		begin
			if(!RSTn)
				begin
					clk_cnt <= 0;
					
					apple_x <= 24;//这是默认出现的苹果的位置
					apple_y <= 10;
					
					add_cube <= 0;
				end
			else
				begin
					clk_cnt <= clk_cnt + 1;
					if(clk_cnt == 250_000)//0.5秒计时
						begin
							clk_cnt <= 0;
							if(apple_x == head_x&&apple_y == head_y)//蛇头吃到苹果
								begin
									add_cube <= 1;
									apple_x <= (random_num[10:5]>6'd38)?(random_num[10:5]-6'd25):((random_num[10:5] == 6'd0)?6'd1:random_num[10:5]);
									apple_y <= (random_num[4:0]>5'd28)?(random_num[4:0]-5'd3):((random_num[4:0] == 5'd0)?5'd1:random_num[4:0]);
								end   //判断随机数是否超出频幕坐标范围 将随机数转换为下个苹果的X Y坐标
							else
								add_cube <= 0;
						end
				end
		end
endmodule
