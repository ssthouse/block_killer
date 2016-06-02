module Display_Ctrl
(
	input CLK_50M,
	input RST_N,
	
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

	//color constant
	localparam COLOR_RED = 3'b100;
	localparam COLOR_GREEN = 3'b010;
	localparam COLOR_BLUE = 3'b001;


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
	
	
	/* no data input yet
	//**********************
	//get color value
	reg [2:0]block_x;
	reg [2:0]block_y;
	reg [47:0] temp_block;
	always@(*)
		begin
			//calcute block index
			 block_x <= x_pos/160;
			 block_y <= y_pos/60;
			case(block_x)
				0:
					begin
						temp_block <= column_0>>((7-block_y)*3);
						temp_color <= temp_block[2:0];
						temp_color <= COLOR_RED;
					end
				1:
					begin 
						temp_block <= column_1>>((7-block_y)*3);
						temp_color <= temp_block[2:0];
						temp_color <= COLOR_GREEN;
					end
				2:
					begin 
						temp_block <= column_2>>((7-block_y)*3);
						temp_color <= temp_block[2:0];
						temp_color <= COLOR_BLUE;
					end
				3:
					begin 
						temp_block <= column_3>>((7-block_y)*3);
						temp_color <= temp_block[2:0];
						temp_color <= COLOR_RED;
					end
			endcase
		end
	*/
	
	//todo test rect
	wire my_rec;
	assign my_rect = ((x_pos>=200)&&(x_pos<=220))&&((y_pos>=140)&&(y_pos<=460));
	
	reg [31:0] clk_count;
	reg [3:0] temp_color;
	always@(posedge CLK_25M or negedge RST_N)
	begin
		if(!RST_N)	
			begin
				clk_count <= 31'd0;
				temp_color <= 3'b000;
			end
		else 
			begin 
				if(clk_count == 31'd25_000_000)	
					begin
						clk_count <= 31'd0;
						temp_color <= temp_color + 3'd1;
					end
				else clk_count <= clk_count + 32'd1;
			end
	end
	
	assign vga_rgb = (my_rect==1)?temp_color:3'b000;
	
endmodule













