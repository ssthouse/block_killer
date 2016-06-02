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

	//todo test user two side array
	reg [2:0] array[3:0][7:0];

	assign column_0[2:0] = array[0][7];
	assign column_0[5:3] = array[0][6];
	assign column_0[8:6] = array[0][5];
	assign column_0[11:9] = array[0][4];
	assign column_0[14:12] = array[0][3];
	assign column_0[17:15] = array[0][2];
	assign column_0[20:18] = array[0][1];
	assign column_0[23:21] = array[0][0];
	assign column_1[2:0] = array[1][7];
	assign column_1[5:3] = array[1][6];
	assign column_1[8:6] = array[1][5];
	assign column_1[11:9] = array[1][4];
	assign column_1[14:12] = array[1][3];
	assign column_1[17:15] = array[1][2];
	assign column_1[20:18] = array[1][1];
	assign column_1[23:21] = array[1][0];
	assign column_2[2:0] = array[2][7];
	assign column_2[5:3] = array[2][6];
	assign column_2[8:6] = array[2][5];
	assign column_2[11:9] = array[2][4];
	assign column_2[14:12] = array[2][3];
	assign column_2[17:15] = array[2][2];
	assign column_2[20:18] = array[2][1];
	assign column_2[23:21] = array[2][0];
	assign column_3[2:0] = array[3][7];
	assign column_3[5:3] = array[3][6];
	assign column_3[8:6] = array[3][5];
	assign column_3[11:9] = array[3][4];
	assign column_3[14:12] = array[3][3];
	assign column_3[17:15] = array[3][2];
	assign column_3[20:18] = array[3][1];
	assign column_3[23:21] = array[3][0];

	//clk count
	reg [31:0] clk_cnt;

	//current block place 0~31: up to down & left to right
	reg [4:0] block_pos;
	reg [1:0] current_block_x;
	reg [2:0] current_block_y; 
	
	// four state of game
	localparam STATE_START = 2'b00;
	localparam STATE_PLAY = 2'b01;
	localparam STATE_OVER = 2'b10;
	
	//press change signal
	reg left_press;
	reg right_press;

	always@(posedge CLK_50M or negedge RST_N)
	begin
		if(!RST_N)
			begin
				game_over <= 0;
				array[0][7] <= 3'b100;
				//todo init position is 0
				block_pos <= 0;
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
						//count clk to down the block
						if(clk_cnt == 32'd25_000_000) 
							begin
								clk_cnt <= 0;
								
								//react the keyboard input
								if(left_key_press == 1)
									begin
										//if not int most left && left block is black
										if((block_pos%4) > 0
											&& array[block_pos%4-1][block_pos/4] == 3'b000)
											begin
												array[block_pos%4][block_pos/4] = 3'b000;
												array[(block_pos-1)%4][(block_pos-1)/4] = 3'b100;
												block_pos = block_pos - 1;
											end
									end
								else if(right_key_press == 1)
									begin
										//if not int most left && left block is black
										if((block_pos%4) < 3
											&& array[block_pos%4+1][block_pos/4] == 3'b000)
											begin
												array[block_pos%4][block_pos/4] = 3'b000;
												array[(block_pos+1)%4][(block_pos+1)/4] = 3'b100;
												block_pos = block_pos + 1;
											end
									end
								if(down_key_press == 1)
									begin
										//todo test game over signal out
										game_over <= 1;
									end
								else
									begin
										game_over <= 0;
									end

								/*
								//todo down one block
								if(block_pos/4 < 7)
									begin
										array[block_pos%4][block_pos/4] = 3'b000;
										block_pos = block_pos + 4;
										array[block_pos%4][block_pos/4] = 3'b100;
									end
								else
									begin
										array[block_pos%4][block_pos/4] = 3'b000;
										block_pos = block_pos - 28;
										array[block_pos%4][block_pos/4] = 3'b100;
									end
									*/
							end
						else 
							clk_cnt <= clk_cnt + 32'd1;
							
					end
				STATE_OVER:
					begin
						
					end
			endcase
		end
	end

	//keyboard detect
	always@(posedge left_key_press or posedge right_key_press)
	begin
		if(left_key_press == 1)
			left_press <= 1;
		else if(left_key_press == 0)
			left_press <= 0;
			
		if(right_key_press == 1)
			right_press <= 1;
		else if(right_key_press == 0)
			right_press <= 0;
	end
endmodule

















