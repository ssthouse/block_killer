// ok
module Display_Ctrl
(
	input CLK_50M,
	input RST_N,
	//game state & score num
	input [1:0]game_state,
	input [7:0] score,
	
	//screen data : four column   (color 3bit)XXX_XXX(index in column)
	input [23:0]column_0,
	input [23:0]column_1,
	input [23:0]column_2,
	input [23:0]column_3,
	
	//vga out
	output reg hsync,
	output reg vsync,
	output [2:0] vga_rgb
);

	// three state of game
	localparam STATE_START = 2'b00;
	localparam STATE_PLAY = 2'b01;
	localparam STATE_OVER = 2'b10;

	//color constant
	localparam BLUE = 3'b001;
	localparam GREEN = 3'b010;
	localparam RED = 3'b100;
	localparam WHITE = 3'b111;
	localparam BLACK = 3'b000;
	
	//color : score test && score number
	wire[2:0] score_txt_color;
	wire[2:0] score_num_color;
	//reg [2:0] score_txt_color_r;
	//reg [2:0] score_num_color_r;
	//assign score_txt_color = score_txt_color_r;
	//assign score_num_color = score_num_color_r;
	//*************************divide to 25m
	reg CLK_25M;
	always@(posedge CLK_50M)
	begin
		CLK_25M <= ~CLK_25M;
	end
	
	//**************************vga position x>>>y
	reg[10:0] x_cnt;//x count
	reg[9:0]  y_cnt;//y count

	always@(posedge CLK_50M or negedge RST_N)
		if(!RST_N) x_cnt <= 11'd0;
		else if(x_cnt == 11'd1039) x_cnt <= 11'd0;
		else x_cnt <= x_cnt + 1'b1;
		
	always@(posedge CLK_50M or negedge RST_N)
		if(!RST_N) y_cnt <= 10'd0;
		else if(y_cnt == 10'd665) y_cnt <= 10'd0;
		else if(x_cnt == 11'd1039) y_cnt <= y_cnt + 1'b1;
		
		
	wire valid;//is in display
	assign valid=(x_cnt >= 11'd187)&&(x_cnt < 11'd987)&&(y_cnt >= 10'd31)&&(y_cnt < 10'd631);

	wire[9:0] x_pos,y_pos;//x,y position
	assign x_pos = x_cnt - 11'd187;
	assign y_pos = y_cnt - 10'd31;

	always@(posedge CLK_50M or negedge RST_N)
		if(!RST_N) hsync <= 1'b1;
		else if(x_cnt == 11'd0) hsync <= 1'b0;
		else if(x_cnt == 11'd120) hsync <= 1'b1;
		
	always@(posedge CLK_50M or negedge RST_N)
		if(!RST_N) vsync <= 1'b1;
		else if(y_cnt == 10'd0) vsync <= 1'b0;
		else if(y_cnt == 10'd6) vsync <= 1'b1;
	
	
	///* no data input yet
	//**********************
	//get color value
	reg [1:0]block_x;
	reg [2:0]block_y;
	reg [23:0] temp_block;
	reg [2:0] temp_color;
						
	assign vga_rgb = (x_pos/200 == 0) ? temp_color :
						(x_pos/200 == 1)? temp_color :
						(x_pos/200 == 2)? temp_color :
						(x_pos/200 == 3)? temp_color : BLACK;
						
	always@(posedge CLK_50M or negedge RST_N)
	begin
		if(!RST_N)begin
			temp_color <= BLACK;
			iDisplay_S_T_X <= 100;
			iDisplay_S_T_Y <= 100;
		end
		else begin
			//game state 
			case(game_state)
				STATE_START: begin
					iDisplay_S_T_X <= 100;
					iDisplay_S_T_Y <= 100;
				end
				STATE_PLAY:begin
					//calcute block index
					block_x = x_pos/200;
					block_y = y_pos/75;
					case(x_pos/200)
						0:
							begin
								temp_block = column_0>>((7-block_y)*3);
								temp_color = temp_block[2:0];
							end
						1:
							begin 
								temp_block = column_1>>((7-block_y)*3);
								temp_color = temp_block[2:0];
							end
						2:
							begin 
								temp_block = column_2>>((7-block_y)*3);
								temp_color = temp_block[2:0];
							end
						3:
							begin 
								temp_block = column_3>>((7-block_y)*3);
								temp_color = temp_block[2:0];
							end
					endcase
				end
				STATE_OVER: begin
					if(x_pos < 119 && y_pos < 48)begin
						temp_color <= score_txt_color;
					end 
					else begin
						temp_color <= BLACK;
					end
				end
			endcase
		end
	end
	
	//0.5s clk count***************************************
	reg [31:0] clk_count;
	always@(posedge CLK_25M or negedge RST_N)
	begin
		if(!RST_N)	
			begin
				clk_count <= 31'd0;
			end
		else 
			begin 
				if(clk_count == 31'd25_000_000)	
					begin
						clk_count <= 31'd0;
					end
				else clk_count <= clk_count + 32'd1;
			end
	end
	
	
	
	//**************show score string**************
	reg [9:0] iDisplay_S_T_X;
	reg [9:0] iDisplay_S_T_Y;
	SCORE_Display SCORE_Display_1
	(
		.iVGA_CLK(CLK_50M),
		.iRST_n(RST_N),
		.iVGA_X(x_pos),
		.iVGA_Y(y_pos),
		.STRING_START_X(iDisplay_SCORE_X),
		.STRING_START_Y(iDisplay_SCORE_Y),
		.oRGB(score_txt_color)	
	);
endmodule














