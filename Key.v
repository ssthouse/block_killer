
	module Key//按键检测模块 延时消抖
(	input CLK_50M,
	input RSTn,
	
	input left,
	input right,
	input up,
	input down,
	
	output reg left_key_press,
	output reg right_key_press,
	output reg up_key_press,
	output reg down_key_press

);

/***************************************************************************/
	reg [31:0] clk_cnt;//32位计数器，用来计数100MS
	
	reg left_key_last;
	reg right_key_last;
	reg up_key_last;
	reg down_key_last;
	
	always@(posedge CLK_50M or negedge RSTn)
		begin
			if(!RSTn)
				begin
					clk_cnt <= 0;
					
					left_key_press <= 0;
					right_key_press <= 0;
					up_key_press <= 0;
					down_key_press <= 0;
					
					left_key_last <= 0;
					right_key_last <= 0;
					up_key_last <= 0;
					down_key_last <= 0;						
				end
			else 
				begin
					if(clk_cnt == 5_0000)//100MS的延时，按键按下电平为0
						begin//按键松手才会有效果，因为last比原信号滞后一个周期，这里的算法是检测到last为0，原信号变为1，则说明刚才按键按下了
							clk_cnt <= 0;//计数器清零
							
							left_key_last <= left;
							right_key_last <= right;
							up_key_last <= up;
							down_key_last <= down;
							
							if(left_key_last == 0 && left == 1)
								left_key_press <= 1;
							if(right_key_last == 0 && right == 1)
								right_key_press <= 1;
							if(up_key_last == 0 && up == 1)
								up_key_press <= 1;
							if(down_key_last == 0 && down == 1)
								down_key_press <= 1;	
						end
					else
						begin
							clk_cnt <= clk_cnt + 1;
							//如果没有按键按下，则保持上下左右信号都为低
							left_key_press <= 0;
							right_key_press <= 0;
							up_key_press <= 0;
							down_key_press <= 0;
						end
				end	
		end				
	
endmodule
