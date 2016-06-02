module Game_Ctrl
(
	input CLK_50M,
	input RST_N,
	
	//game state
	input [1:0] game_state,
	
	//key control
	input left_key_press,
	input right_key_press,
	input down_key_press,
	
	//output color data
	output reg [23:0]column_0,
	output reg [23:0]column_1,
	output reg [23:0]column_2,
	output reg [23:0]column_3,
	
	//game signal
	output reg game_over
);

	//clk count
	reg [31:0] clk_cnt;

	//current block place 0~31: up to down & left to right
	reg [4:0] current_block_pos;
	reg[1:0] current_block_x;
	reg[2:0] current_block_y; 
	
	// four state of game
	localparam STATE_START = 2'b00;
	localparam STATE_PLAY = 2'b01;
	localparam STATE_OVER = 2'b10;

	always@(posedge CLK_50M or negedge RST_N)
	begin
		if(!RST_N)
			begin
				game_over <= 0;
				column_0 <= 24'd0;
				column_1 <= 24'd0;
				column_2 <= 24'd0;
				column_3 <= 24'd0;
				//todo init position is 0
				current_block_pos <= 0;
				//clear count
				clk_cnt <= 0;
			end
		else 
			begin
			case(game_state)
				STATE_START:
					begin
							
					end
				STATE_PLAY:
					begin
						//count clk 
						if(clk_cnt == 32'd25_000_000) 
							begin
								clk_cnt <= 0;
								//todo down one block
							end
						else clk_cnt <= clk_cnt + 32'd1;
						
						if(left_key_press == 1)
							begin
								//game_over <= 1;
							end
						else if(right_key_press == 1)
							begin
							
							end
						else if(down_key_press == 1)
							begin
								//todo test game over signal out
								game_over <= 1;
							end
						else
							begin
								game_over <= 0;
							end
					end
				STATE_OVER:
					begin
						
					end
			endcase
		end
	end

endmodule

















