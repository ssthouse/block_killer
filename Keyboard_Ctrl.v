module Keyboard_Ctrl
(
	//base
	input CLK_50M,
	input RST_N,
	//data & state
	input [7:0] ps2_byte,
	input ps2_state,
	//×ó ÓÒ ÏÂ  »Ø³µ
	output reg left_key_press,
	output reg right_key_press,
	output reg down_key_press,
	output reg play_key_press,
	output reg restart_key_press
);

always@(posedge CLK_50M or negedge RST_N)
begin
	if(!RST_N)
		begin 
			left_key_press <= 0;
			right_key_press <= 0;
			down_key_press <= 0;
			play_key_press <= 0;
			restart_key_press <= 0;
		end
	else
		begin
			if(ps2_state)
				begin
					if(ps2_byte == "A")
						left_key_press <= 1;
					else 
						left_key_press <= 0;
			
					if(ps2_byte == "D") 
						right_key_press <= 1;
					else 
						right_key_press <= 0;
			
					if(ps2_byte == "S") 
						down_key_press <= 1;
					else 
						down_key_press <= 0;
			
					if(ps2_byte == "P") 
						play_key_press <= 1;
					else
						play_key_press <= 0;
						
					if(ps2_byte == "R")
						restart_key_press <= 1;
					else 
						restart_key_press <=0;
				end
			else
				begin
					left_key_press <= 0;
					right_key_press <= 0;
					down_key_press <= 0;
					play_key_press <= 0;
					restart_key_press <= 0;
				end
		end
end

endmodule 