module State_Ctrl
(
	//clk ret_n
	input CLK_50M,
	input RST_N,
	//input that affecs state
	input game_start,
	input game_over,
	input game_reset,
	// game signal
	output reg [1:0] game_state,
	
	//todo test
	output reg [2:0] led
);

	// four state of game
	localparam STATE_START = 2'b00;
	localparam STATE_PLAY = 2'b01;
	localparam STATE_OVER = 2'b10;
	
	//adder 
	reg [31:0] clk_cnt;
	
	always@(posedge CLK_50M or negedge RST_N)
	begin
		if(!RST_N)
			begin
				game_state <= STATE_START;
				led <= 3'b100;
				clk_cnt <= 0;
			end
		else
			begin
				//state change
				case(game_state)
					STATE_START:
						begin
							if(game_start)
								begin
									game_state <= STATE_PLAY;
									led <= 3'b010;
								end
						end
					STATE_PLAY:
						begin
							if(game_over)
								begin
									game_state <= STATE_OVER;
									led <= 3'b001;
								end
						end
					STATE_OVER:
						begin
							if(game_reset)
								begin
									game_state <= STATE_START;
									led <= 3'b100;
								end
						end
					2'b11:
						begin
							game_state <= STATE_START;
							led <= 3'b100;
						end
					endcase
			end
	end
	
endmodule