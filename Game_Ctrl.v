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
	output wire [23:0]column_0,
	output wire [23:0]column_1,
	output wire [23:0]column_2,
	output wire [23:0]column_3,
	
	//game signal
	output reg game_over
);


	//todo: test use reg array to save color data
	//column_0
	reg [2:0] array_0[7:0];
	assign column_0[2:0] = array_0[7];
	assign column_0[5:3] = array_0[6];
	assign column_0[8:6] = array_0[5];
	assign column_0[11:9] = array_0[4];
	assign column_0[14:12] = array_0[3];
	assign column_0[17:15] = array_0[2];
	assign column_0[20:18] = array_0[1];
	assign column_0[23:21] = array_0[0];
	//column_1
	reg [2:0] array_1[7:0];
	assign column_1[2:0] = array_1[0];
	assign column_1[5:3] = array_1[1];
	assign column_1[8:6] = array_1[2];
	assign column_1[11:9] = array_1[3];
	assign column_1[14:12] = array_1[4];
	assign column_1[17:15] = array_1[5];
	assign column_1[20:18] = array_1[6];
	assign column_1[23:21] = array_1[7];
	//column_2
	reg [2:0] array_2[7:0];
	assign column_2[2:0] = array_2[0];
	assign column_2[5:3] = array_2[1];
	assign column_2[8:6] = array_2[2];
	assign column_2[11:9] = array_2[3];
	assign column_2[14:12] = array_2[4];
	assign column_2[17:15] = array_2[5];
	assign column_2[20:18] = array_2[6];
	assign column_2[23:21] = array_2[7];
	//column_3
	reg [2:0] array_3[7:0];
	assign column_3[2:0] = array_3[0];
	assign column_3[5:3] = array_3[1];
	assign column_3[8:6] = array_3[2];
	assign column_3[11:9] = array_3[3];
	assign column_3[14:12] = array_3[4];
	assign column_3[17:15] = array_3[5];
	assign column_3[20:18] = array_3[6];
	assign column_3[23:21] = array_3[7];

	//clk count
	reg [31:0] clk_cnt;

	//current block place 0~31: up to down & left to right
	reg [4:0] current_block_pos;
	reg [1:0] current_block_x;
	reg [2:0] current_block_y; 
	
	// four state of game
	localparam STATE_START = 2'b00;
	localparam STATE_PLAY = 2'b01;
	localparam STATE_OVER = 2'b10;

	always@(posedge CLK_50M or negedge RST_N)
	begin
		if(!RST_N)
			begin
				game_over <= 0;
				/*array_0[0] <= 3'b000;
				array_0[1] <= 3'b000;
				array_0[2] <= 3'b000;
				array_0[3] <= 3'b000;
				array_0[4] <= 3'b000;*/
				//column_1 <= 24'b111_111_111;
				//column_2 <= 24'd0;
				//column_3 <= 24'd0;
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
								if(current_block_pos/4 < 7)
									begin
										//turn current color to black
										case(current_block_pos%4)
											0:array_0[current_block_pos/4] = 3'b000;
											1:array_1[current_block_pos/4] = 3'b000;
											2:array_2[current_block_pos/4] = 3'b000;
											3:array_3[current_block_pos/4] = 3'b000;
										endcase
										current_block_pos = current_block_pos + 4;
										
										case(current_block_pos%4)
											0:array_0[current_block_pos/4] = 3'b100;
											1:array_1[current_block_pos/4] = 3'b100;
											2:array_2[current_block_pos/4] = 3'b100;
											3:array_3[current_block_pos/4] = 3'b100;
										endcase
										//change color
									end
								else
									begin
										//todo: generate 0~3 number
										case(current_block_pos%4)
											0:array_0[current_block_pos/4] = 3'b000;
											1:array_1[current_block_pos/4] = 3'b000;
											2:array_2[current_block_pos/4] = 3'b00;
											3:array_3[current_block_pos/4] = 3'b000;
										endcase
										current_block_pos = current_block_pos - 28;
										
										case(current_block_pos%4)
											0:array_0[current_block_pos/4] = 3'b100;
											1:array_1[current_block_pos/4] = 3'b100;
											2:array_2[current_block_pos/4] = 3'b100;
											3:array_3[current_block_pos/4] = 3'b100;
										endcase
									end
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

















