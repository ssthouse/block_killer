module NUMBER_Display
	(
		input iVGA_CLK,
		input iRST_n,
		input [9:0]iVGA_X,
		input [9:0]iVGA_Y,
		input [9:0]STRING_START_X,
		input [9:0]STRING_START_Y,
		input [11:0]iColor, 
		input [3:0]iNum,
		output reg [11:0]oRGB
		
	);
	
//parameter STRING_START_X = 332;
//parameter STRING_START_Y = 427;
parameter STRING_WIDTH   = 240;
parameter CHAR_WIDTH = 24;
parameter STRING_HEIGHT  = 48; 

wire [13:0] Addr;
reg  [13:0] Addr_Res;
assign Addr = Addr_Res;

wire Pixel_Out;

always@(posedge iVGA_CLK)
begin
	if(!iRST_n)
		begin
			oRGB <= 12'h000;
			Addr_Res <= 0;
		end
	else
		begin
			if((iVGA_X >= STRING_START_X && iVGA_X <= STRING_START_X + CHAR_WIDTH -1) 
			&&(iVGA_Y >= STRING_START_Y && iVGA_Y <= STRING_START_Y + STRING_HEIGHT - 1))
				begin
					Addr_Res <= (iVGA_X - STRING_START_X) + CHAR_WIDTH*iNum + (iVGA_Y - STRING_START_Y) * STRING_WIDTH;
					if(Pixel_Out) 
						oRGB <= iColor;
					else 
						oRGB <= 12'h000;
				end
			else
				begin
					Addr_Res <= 0;
					oRGB <= 12'h000;
				end	
		end
end
NUM_Rom NUM_Rom_Display
	(
		.address(Addr),
		.clock(iVGA_CLK),
		.q(Pixel_Out)
	);	 

endmodule