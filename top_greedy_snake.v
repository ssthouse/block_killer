module top_greedy_snake
(
	//clock & reset
	input CLK_50M,
	input RSTn,
	
	//keyboard clk & data
	input ps2k_clk,
	input ps2k_data,

	//vga horizontal syn & vertical syn
	output hsync,
	output vsync,
	//vga data output
	output [2:0] color_out,//RGB
	
	//********************no use***************
	//output [7:0] seg_out,//数码管段选
	//output [3:0] sel,//数码管位选
	
	//led
	output [2:0] led_out
);


//****************************out code *****************************

	//game signal
	wire game_over;
	
	wire left;
	wire right;
	
	//btns
	wire left_key_down;
	wire right_key_down;
	wire down_key_down;
	//keyboard: p & r
	wire play_key_down;
	wire restart_key_down;

	//game state
	wire [1:0] game_state;
	
	//color data
	wire [23:0] column_0;
	wire [23:0] column_1;
	wire [23:0] column_2;
	wire [23:0] column_3;


	//todo: test
	wire [2:0] temp_led;
	
	State_Ctrl state_ctrl
	(
		//clk ret_n
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//input that affecs state
		.game_start(play_key_down),
		.game_over(game_over),
		.game_reset(restart_key_down),
		// game signal
		.game_state(game_state),
		//todo test
		.led(temp_led)
	);


	Keyboard_Ctrl keyboard_ctrl
	(
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//data & state,
		.ps2_byte(ps2_byte),
		.ps2_state(ps2_state),
		//左 右 下  回车
		.left_key_press(left_key_down),
		.right_key_press(right_key_down),
		.down_key_press(down_key_down),
		.play_key_press(play_key_down),
		.restart_key_press(restart_key_down)
	);

	//score
	wire [7:0] score;

	Display_Ctrl display_ctrl
	(
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//state & score
		.game_state(game_state),
		.score(score),
		//color data
		.column_0(column_0),
		.column_1(column_1),
		.column_2(column_2),
		.column_3(column_3),
		//vga out
		.hsync(hsync),
		.vsync(vsync),
		.vga_rgb(color_out)
	);

	//game core module
	Game_Ctrl game_ctrl
	(
		.led(led_out),
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//game state
		.game_state(game_state),
		//key control
		.left_key_press(left_key_down),
		.right_key_press(right_key_down),
		.down_key_press(down_key_down),
		//output color data
		.column_0(column_0),
		.column_1(column_1),
		.column_2(column_2),
		.column_3(column_3),
		//game signal
		.game_over(game_over),
		.score(score)
	);
	
//****************************our code *****************************


/***************************************************************************/
	
	wire [1:0] snake;
	
	//the  fist 5 bit block position   the latter 16 block 
	wire [9:0] x_pos;
	wire [9:0] y_pos;
	
	wire [5:0] apple_x;
	wire [4:0] apple_y;
	
	wire [5:0] head_x;
	wire [5:0] head_y;
	
	wire add_cube;
	
	wire[1:0] game_status;
	
	wire hit_wall;
	wire hit_body;
	
	wire die_flash;
	wire restart;
	wire [7:0] cube_num;
	
	wire left_key_press;
	wire right_key_press;
	wire up_key_press;
	wire down_key_press;
/***************************************************************************/


/***************************************************************************/
	
	
//	wire CLK_50M;
//	pll U1    //锁相环将输入的20M晶振倍频到50M
//	pll	pll_inst 
//	(S
//		.inclk0(CLK),
//		.c0(CLK_50M)
//	
//	);
	
	
	Game_Ctrl_Unit U2
	(
		.CLK_50M(CLK_50M),
		.RSTn(RSTn),
		.key1_press(left_key_press),
		.key2_press(right_key_press),
		.key3_press(up_key_press),
		.key4_press(down_key_press),
		.game_status(game_status),
		.hit_wall(hit_wall),
		.hit_body(hit_body),
		.die_flash(die_flash),
		.restart(restart)
		
	);
			
		Snake_Eatting_Apple U3
	(
		.CLK_50M(CLK_50M),
		.RSTn(RSTn),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube)
	);
	
	
	Snake U4
	(
		.CLK_50M(CLK_50M),
		.RSTn(RSTn),
		.left_press(left_key_press),
		.right_press(right_key_press),
		.up_press(up_key_press),
		.down_press(down_key_press),	
		.snake(snake),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.game_status(game_status),
		.cube_num_O(cube_num),
		.hit_body(hit_body),
		.hit_wall(hit_wall),
		.die_flash(die_flash)
	);
//wire [7:0]Score;	
	/*
	VGA_Control U5
	(
		.CLK_50M(CLK_50M),
		.RSTn(RSTn),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
		.color_out(color_out),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.Score(cube_num),
		.apple_x(apple_x),
		.apple_y(apple_y)
	
	);
	*/
/***************************************************************************/
Keyboard U6
	(
		.CLK_50M(CLK_50M),
		.RSTn(RSTn),
		.ps2_byte(ps2_byte),
		.ps2_state(ps2_state),
		.left_key_press(left_key_press),
		.right_key_press(right_key_press),
		.up_key_press(up_key_press),
		.down_key_press(down_key_press)		
	);


wire [7:0]ps2_byte;
wire ps2_state;
wire led;
wire [3:0]wei;
wire [7:0]seg;

ps2_top U7
	(
		.clk(CLK_50M),
		.rst(RSTn),
		.ps2k_clk(ps2k_clk),
		.ps2k_data(ps2k_data),
		.ps2_byte(ps2_byte),
		.ps2_state(ps2_state),
		.led(led),
		.wei(wei),
		.seg(seg)
	);

	
endmodule
