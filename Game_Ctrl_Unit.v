module Game_Ctrl_Unit//游戏控制模块 根据游戏状态产生相应控制信号	

(
	input CLK_50M,
	input RSTn,
	
	input key1_press,//4个按键
	input key2_press,
	input key3_press,
	input key4_press,
	
	output reg [1:0] game_status,//4个游戏状态
	
	input hit_wall,//撞墙
	input hit_body,//碰到自己的身体
	
	output reg die_flash,//失败出现的FLASH
	output reg restart//重新开始
		
);
		
	localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;
	
	reg [31:0] clk_cnt;//32位的计数器
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			begin
				game_status <= START;//复位的时候，送START状态
				clk_cnt <= 0;
				die_flash <= 1;
				restart <= 0;
			end
		else
			begin
				case(game_status)//选择游戏状态
					RESTART:
							begin//在RESTART状态里
								 if(clk_cnt <= 5)//如果计数器小于等于5
									begin
										clk_cnt <= clk_cnt + 1;
										restart <= 1;
									end
								 else 
									begin
										game_status <= START;
										clk_cnt <= 0;
										restart <= 0;
									end
							end
	
					START:
						  begin//在START状态里，有任意一个按键按下，则送PLAY状态
								if(key1_press|
									key2_press|
									key3_press|
									key4_press)
									
									game_status <= PLAY;
								else
									game_status <= game_status;
						  end
		
					PLAY://PLAY状态，如果撞墙或者碰到自己身体，送DIE状态
							begin
								if(hit_wall|hit_body)
									game_status <= DIE;
								else
									game_status <= game_status;
							end
			/*************************************/
		
					DIE:
						begin//DIE状态
							if(clk_cnt <= 200_000_000)
								begin
									clk_cnt <= clk_cnt + 1'b1;
									if(clk_cnt == 25_000_000)//时间达到0.5S
										die_flash <= 0;
									else if(clk_cnt == 50_000_000)//时间达到1.0S
										die_flash <= 1'b1;
									else if(clk_cnt == 75_000_000)//以此类推
										die_flash <= 1'b0;
									else if(clk_cnt == 100_000_000)
										die_flash <= 1'b1;
									else if(clk_cnt == 125_000_000)
										die_flash <= 1'b0;
									else if(clk_cnt == 150_000_000)
										die_flash <= 1'b1;
									else
										die_flash <= 1'd1;//~~~
								end                    //目的是使出现闪烁效果	
							else
								begin
									die_flash <= 1;
									clk_cnt <= 0;
									game_status <= RESTART;
								end
						end
				endcase
		   end
	end
	
	endmodule
	
