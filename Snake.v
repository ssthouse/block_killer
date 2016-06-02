module Snake//蛇运动情况控制模块
(
	input CLK_50M,
	input RSTn,
	
	input left_press,
	input right_press,
	input up_press,
	input down_press,
	
	output reg [1:0] snake,//用于表示当前扫描扫描的部件 四种状态 00：无 01：头 10：身体 11：墙
	
	input [9:0] x_pos,//低4位表示一个格子内像素的坐标，高5位表示格坐标
	input [9:0] y_pos,//扫描坐标  单位：“像素点”
	
	output [5:0] head_x,	//头部那一格的X坐标
	output [5:0] head_y,//头部那一格的Y坐标
	
	input add_cube,//身体长度增加信号
	
	input [1:0] game_status,//四种游戏状态

	
	output reg [7:0] cube_num_O,
	
	output reg hit_body,
	output reg hit_wall,
	input die_flash
);
/***************************************************************************/
	reg [7:0]cube_num;
	localparam UP = 2'b00;
	localparam DOWN = 2'b01;
	localparam LEFT = 2'b10;
	localparam RIGHT = 2'b11;
	
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam PLAY = 2'b10;
	
/***************************************************************************/
/***************************************************************************/
	reg [31:0] cnt;
	
	wire [1:0] direct;
	reg [1:0] direct_r;
	
	assign direct = direct_r;
	
	reg [1:0] direct_next;
	
	reg change_to_left;
	reg change_to_right;
	reg change_to_up;
	reg change_to_down;
	
	reg [5:0] cube_x [15:0];//这种格式是二维数组的意思，地址为0~15，每个地址为6bits
	reg [5:0] cube_y [15:0];//体长坐标 单位：“格子” ，16*16像素组成的格子
	reg [15:0] is_exist;//这用来控制蛇体亮暗，1为亮，0为暗
	
	reg [2:0] color;//RGB三个位
	
	assign head_x = cube_x[0];//cube_x，cube_y表示一整条大蟒蛇身体各节的格坐标

	assign head_y = cube_y[0];
	//cube[0]表示head这个格，（就是上面蓝色的头部）head是我们主要要控制的地方，它涉及到DIE .EattingApple.
	//还有身体运动轨迹等……所以head单独提取出来作为输出信号head_x和head_y用于后面的模块。

/***************************************************************************/
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			direct_r <= RIGHT;//默认一出来就是向右前进
		else
			direct_r <= direct_next;//？？
	end
	
/***************************************************************************/
/***************************************************************************/
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			begin
				cnt <= 0;
				//X从左到右递增，Y从上到下递增
				cube_x[0] <= 10;//蛇头默认出现的X坐标是10
				cube_y[0] <= 5;//蛇头默认出现的Y坐标是5
				
				cube_x[1] <= 9;//第一节身体的X坐标是9
				cube_y[1] <= 5;//第一节身体的Y坐标还是5
				
				cube_x[2] <= 8;//第二节身体的X坐标是8
				cube_y[2] <= 5;//第二节身体的Y坐标还是5
				
				
				//后面的身体暂时还没有，所以没有所谓的坐标，都为0，最多是16节身体
				cube_x[3] <= 0;
				cube_y[3] <= 0;
				
				cube_x[4] <= 0;
				cube_y[4] <= 0;
				
				cube_x[5] <= 0;
				cube_y[5] <= 0;
				
				cube_x[6] <= 0;
				cube_y[6] <= 0;
				
				cube_x[7] <= 0;
				cube_y[7] <= 0;
				
				cube_x[8] <= 0;
				cube_y[8] <= 0;
				
				cube_x[9] <= 0;
				cube_y[9] <= 0;
				
				cube_x[10] <= 0;
				cube_y[10] <= 0;
				
				cube_x[11] <= 0;
				cube_y[11] <= 0;
				
				cube_x[12] <= 0;
				cube_y[12] <= 0;
				
				cube_x[13] <= 0;
				cube_y[13] <= 0;
				
				cube_x[14] <= 0;
				cube_y[14] <= 0;
				
				cube_x[15] <= 0;
				cube_y[15] <= 0;
				
				
				hit_wall <= 0;
				
				hit_body <= 0;
			end
		else
			begin//这里强调一下，begin end里面的语句是顺序执行的
				cnt <= cnt + 1;//这里用一个ELSE放到后面去
				
				if(cnt == 12_500_000) //0.02us*12'500'000 = 0.25s   每秒移动四次
					begin
						cnt <= 0;
						
						if(game_status == PLAY)
							begin
							//撞墙有四种情况，上下左右，撞到上，Y = 1；撞到下边，Y = 28；撞到左边，X = 1；撞到右边，X = 38；画个图就知道了~
								if((direct == UP&&cube_y[0] == 1)|(direct == DOWN&&cube_y[0] == 28)|(direct == LEFT&&cube_x[0] == 1)|(direct == RIGHT&&cube_x[0] == 38))
									hit_wall <= 1;
								
								else if((cube_y[0] == cube_y[1]&&cube_x[0] == cube_x[1]&&is_exist[1] == 1)|
										(cube_y[0] == cube_y[2]&&cube_x[0] == cube_x[2]&&is_exist[2] == 1)|
										(cube_y[0] == cube_y[3]&&cube_x[0] == cube_x[3]&&is_exist[3] == 1)|
										(cube_y[0] == cube_y[4]&&cube_x[0] == cube_x[4]&&is_exist[4] == 1)|
										(cube_y[0] == cube_y[5]&&cube_x[0] == cube_x[5]&&is_exist[5] == 1)|
										(cube_y[0] == cube_y[6]&&cube_x[0] == cube_x[6]&&is_exist[6] == 1)|
										(cube_y[0] == cube_y[7]&&cube_x[0] == cube_x[7]&&is_exist[7] == 1)|
										(cube_y[0] == cube_y[8]&&cube_x[0] == cube_x[8]&&is_exist[8] == 1)|
										(cube_y[0] == cube_y[9]&&cube_x[0] == cube_x[9]&&is_exist[9] == 1)|
										(cube_y[0] == cube_y[10]&&cube_x[0] == cube_x[10]&&is_exist[10] == 1)|
										(cube_y[0] == cube_y[11]&&cube_x[0] == cube_x[11]&&is_exist[11] == 1)|
										(cube_y[0] == cube_y[12]&&cube_x[0] == cube_x[12]&&is_exist[12] == 1)|
										(cube_y[0] == cube_y[13]&&cube_x[0] == cube_x[13]&&is_exist[13] == 1)|
										(cube_y[0] == cube_y[14]&&cube_x[0] == cube_x[14]&&is_exist[14] == 1)|
										(cube_y[0] == cube_y[15]&&cube_x[0] == cube_x[15]&&is_exist[15] == 1))
										
										hit_body <= 1;//头的Y坐标 = 任一位身体的Y坐标 且 头的X坐标 = 任一位身体的X坐标 且 身体的该长度位存在  碰到身体
								else
									 begin//下面的代码是产生跟随现象，后面一节身体跟着前面一节身体的地址~
										cube_x[1] <= cube_x[0];
										cube_y[1] <= cube_y[0];
										
										cube_x[2] <= cube_x[1];
										cube_y[2] <= cube_y[1];
										
										cube_x[3] <= cube_x[2];
										cube_y[3] <= cube_y[2];
										
										cube_x[4] <= cube_x[3];
										cube_y[4] <= cube_y[3];
										
										cube_x[5] <= cube_x[4];
										cube_y[5] <= cube_y[4];
										
										cube_x[6] <= cube_x[5];
										cube_y[6] <= cube_y[5];
										
										cube_x[7] <= cube_x[6];
										cube_y[7] <= cube_y[6];
										
										cube_x[8] <= cube_x[7];
										cube_y[8] <= cube_y[7];
										
										cube_x[9] <= cube_x[8];
										cube_y[9] <= cube_y[8];
										
										cube_x[10] <= cube_x[9];
										cube_y[10] <= cube_y[9];
										
										cube_x[11] <= cube_x[10];
										cube_y[11] <= cube_y[10];
										
										cube_x[12] <= cube_x[11];
										cube_y[12] <= cube_y[11];
										
										cube_x[13] <= cube_x[12];
										cube_y[13] <= cube_y[12];
										
										cube_x[14] <= cube_x[13];
										cube_y[14] <= cube_y[13];
										
										cube_x[15] <= cube_x[14];
										cube_y[15] <= cube_y[14];
										//身体运动算法 本长度位移动的下个坐标为下一个长度位当前坐标 运动节拍按分频后的节奏
										case(direct)//这里选择的是按键，在墙边的时候							
											UP:
												begin
													if(cube_y[0] == 1)
														hit_wall <= 1;
													else
														cube_y[0] <= cube_y[0] - 6'd1;//注意坐标系，这里是 - 1，因为最上面是0，所以向上走的话，Y是 - 1的。
												end
											
											DOWN:
												begin
													if(cube_y[0] == 28)
														hit_wall <= 1;
													else
														cube_y[0] <= cube_y[0] + 6'd1;
												end
											LEFT:
												begin
													if(cube_x[0] == 1)
														hit_wall <= 1;
													else
														cube_x[0] <= cube_x[0] - 6'd1;//注意坐标系，这里是 + 1，因为最左面是0，所以向左走的话，X是 - 1的。	
												end
											
											RIGHT:
												begin
													if(cube_x[0] == 38)
														hit_wall <= 1;
													else
														cube_x[0] <= cube_x[0] + 6'd1;
														//根据按下按键判断是否撞墙 否则按规律改变头部坐标
												end
										endcase																	
									 end					
							end
					end 
			end 
	end
/***************************************************************************/
	
	always@(*)//这里也是电平触发
	begin   //根据当前运动状态即按下键位判断下一步运动情况，不在墙边的情况
		direct_next = direct;
		
		case(direct)
			UP://根据按键进行三个方向的选择
				begin
					if(change_to_left)
						direct_next = LEFT;
					else if(change_to_right)
						direct_next = RIGHT;
					else
						direct_next = UP;
				end
			
			DOWN:
				begin
					if(change_to_left)
						direct_next = LEFT;
					else if(change_to_right)
						direct_next = RIGHT;
					else
						direct_next = DOWN;
				end		
			LEFT:
				begin
					if(change_to_up)
						direct_next = UP;
					else if(change_to_down)
						direct_next = DOWN;
					else
						direct_next = LEFT;
				end
			
			RIGHT:
				begin
					if(change_to_up)
						direct_next = UP;
					else if(change_to_down)
						direct_next = DOWN;
					else
						direct_next = RIGHT;
				end		
		endcase
	end
/***************************************************************************/
	
	always@(posedge CLK_50M)//给四个按键赋值
	begin
		if(left_press == 1)
				change_to_left <= 1;
		else if(right_press == 1)
				change_to_right <= 1;
		else if(up_press == 1)
				change_to_up <= 1;
		else if(down_press == 1)
				change_to_down <= 1;			
		else 
			begin
				change_to_left <= 0;
				change_to_right <= 0;
				change_to_up <= 0;
				change_to_down <= 0;
			end
	end
/***************************************************************************/
	reg addcube_state;//吃苹果状态
	
	always@(posedge CLK_50M or negedge RSTn)//吃下苹果没？，吃下则add_cube == 1，显示体长增加一位，"is_exixt[cube_num] <= 1",让第cube_num位“出现”
		begin
			if(!RSTn)
				begin
					is_exist <= 16'd7;//0111
					cube_num <= 3;
					cube_num_O <= 0;
					addcube_state <= 0;//初始显示长度为3，is_exist = 0000_0000_0111
				end		
		   else 
				begin//判断蛇头与苹果坐标重合？？？？
					case(addcube_state)
						0:
							begin
								if(add_cube)
									begin
										cube_num <= cube_num + 7'd1;
										cube_num_O <= cube_num_O + 1;
										if(cube_num_O[3:0] == 9)
										begin
											cube_num_O[3:0] <= 0;
											cube_num_O[7:4] <= cube_num_O[7:4] + 1;
										end
										is_exist[cube_num] <= 1;
										addcube_state <= 1;//“吃下”信号
									end
								else
									begin
										cube_num <= cube_num;
										is_exist[cube_num] <= is_exist[cube_num];
										addcube_state <= addcube_state;
									end 
						   end
						1:
							begin
								if(!add_cube)//add_cube哪里改变了？？？
									addcube_state <= 0;
								else
									addcube_state <= addcube_state;
						   end
					endcase
			   end
		end
	
	reg [3:0] lox;
	reg [3:0] loy;
	
	always@(x_pos or y_pos or is_exist or die_flash)//注意，这里是电平触发，所以用的是阻塞赋值“=”
		begin
			if(x_pos >= 0&&x_pos<640&&y_pos >= 0&&y_pos<480)
				begin
					if(x_pos[9:4] == 0|y_pos[9:4] == 0|x_pos[9:4] == 39|y_pos[9:4] == 29)
						snake = WALL;//扫描墙
					else if(x_pos[9:4] == cube_x[0]&&y_pos[9:4] == cube_y[0]&&is_exist[0] == 1)//扫描头
							snake = (die_flash == 1)?HEAD:NONE;//？？？
					else if((x_pos[9:4] == cube_x[1]&&y_pos[9:4] == cube_y[1]&&is_exist[1] == 1)|
							 (x_pos[9:4] == cube_x[2]&&y_pos[9:4] == cube_y[2]&&is_exist[2] == 1)|
							 (x_pos[9:4] == cube_x[3]&&y_pos[9:4] == cube_y[3]&&is_exist[3] == 1)|
							 (x_pos[9:4] == cube_x[4]&&y_pos[9:4] == cube_y[4]&&is_exist[4] == 1)|
							 (x_pos[9:4] == cube_x[5]&&y_pos[9:4] == cube_y[5]&&is_exist[5] == 1)|
							 (x_pos[9:4] == cube_x[6]&&y_pos[9:4] == cube_y[6]&&is_exist[6] == 1)|
							 (x_pos[9:4] == cube_x[7]&&y_pos[9:4] == cube_y[7]&&is_exist[7] == 1)|
							 (x_pos[9:4] == cube_x[8]&&y_pos[9:4] == cube_y[8]&&is_exist[8] == 1)|
							 (x_pos[9:4] == cube_x[9]&&y_pos[9:4] == cube_y[9]&&is_exist[9] == 1)|
							 (x_pos[9:4] == cube_x[10]&&y_pos[9:4] == cube_y[10]&&is_exist[10] == 1)|
							 (x_pos[9:4] == cube_x[11]&&y_pos[9:4] == cube_y[11]&&is_exist[11] == 1)|
							 (x_pos[9:4] == cube_x[12]&&y_pos[9:4] == cube_y[12]&&is_exist[12] == 1)|
							 (x_pos[9:4] == cube_x[13]&&y_pos[9:4] == cube_y[13]&&is_exist[13] == 1)|
							 (x_pos[9:4] == cube_x[14]&&y_pos[9:4] == cube_y[14]&&is_exist[14] == 1)|
							 (x_pos[9:4] == cube_x[15]&&y_pos[9:4] == cube_y[15]&&is_exist[15] == 1))
													
							snake = (die_flash == 1)?BODY:NONE;//扫描身体
					else 
							snake = NONE;
				end
			else
			snake = NONE;
		end
	
endmodule
