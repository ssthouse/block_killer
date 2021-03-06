module Keyboard 
	(
		input CLK_50M,
		input RSTn,
		input [7:0] ps2_byte,
		input ps2_state,
		output reg left_key_press,
		output reg right_key_press,
		output reg up_key_press,
		output reg down_key_press		
	);
	
always@(posedge CLK_50M)
begin
	if(!RSTn)
		begin
			left_key_press <= 0;
			right_key_press <= 0;
			up_key_press <= 0;
			down_key_press <= 0;
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
			
					if(ps2_byte == "W") 
						up_key_press <= 1;
					else
						up_key_press <= 0;
			
					if(ps2_byte == "S") 
						down_key_press <= 1;
					else 
						down_key_press <= 0;
				end
			else
				begin
					left_key_press <= 0;
					right_key_press <= 0;
					up_key_press <= 0;
					down_key_press <= 0;
				end
		end
end
	
endmodule