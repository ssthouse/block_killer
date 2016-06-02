//数码管计分模块
module Seg_Display
(
	input CLK_50M,
	input RSTn,
	
	input add_cube,
	
	output reg [7:0] seg_out,
	output reg [3:0] sel
);
/***************************************************************************/
	reg [15:0] point;
	reg [31:0] clk_cnt;
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			begin
				seg_out <= 0;
				clk_cnt <= 0;
				sel <= 0;	
			end
		else
			begin
				if(clk_cnt <= 20_0000)	
					begin
						clk_cnt <= clk_cnt + 1;
						
						if(clk_cnt==5_0000)
							begin
								sel <= 4'b1110;
								case(point[3:0])
									4'b0000:
												seg_out <= 8'b1100_0000;
									4'b0001:
												seg_out <= 8'b1111_1001;
									4'b0010:
												seg_out <= 8'b1010_0100;
									
									4'b0011:
												seg_out <= 8'b1011_0000;
									4'b0100:
												seg_out <= 8'b1001_1001;
									4'b0101:
												seg_out <= 8'b1001_0010;
									
									4'b0110:
												seg_out <= 8'b1000_0010;
									4'b0111:
												seg_out <= 8'b1111_1000;
									4'b1000:
												seg_out <= 8'b1000_0000;
									4'b1001:
												seg_out <= 8'b1001_0000;
									default;
								endcase
							end
						else if(clk_cnt==10_0000)
								begin
									sel <= 4'b1101;
									
									case(point[7:4])
										4'b0000:
														seg_out <= 8'b1100_0000;
										4'b0001:
														seg_out <= 8'b1111_1001;
										4'b0010:
														seg_out <= 8'b1010_0100;
										
										4'b0011:
														seg_out <= 8'b1011_0000;
										4'b0100:
														seg_out <= 8'b1001_1001;
										4'b0101:
														seg_out <= 8'b1001_0010;
										
										4'b0110:
														seg_out <= 8'b1000_0010;
										4'b0111:
														seg_out <= 8'b1111_1000;
										4'b1000:
														seg_out <= 8'b1000_0000;
										4'b1001:
														seg_out <= 8'b1001_0000;
						//				default;							
									endcase
								end
						
						else if(clk_cnt==15_0000)
								begin
									sel <= 4'b1011;
									case(point[11:8])
										4'b0000:
													seg_out <= 8'b1100_0000;
										4'b0001:
													seg_out <= 8'b1111_1001;
										4'b0010:
													seg_out <= 8'b1010_0100;
										
										4'b0011:
													seg_out <= 8'b1011_0000;
										4'b0100:
													seg_out <= 8'b1001_1001;
										4'b0101:
													seg_out <= 8'b1001_0010;
										
										4'b0110:
													seg_out <= 8'b1000_0010;
										4'b0111:
													seg_out <= 8'b1111_1000;
										4'b1000:
													seg_out <= 8'b1000_0000;
										4'b1001:
													seg_out <= 8'b1001_0000;
							//			default;					
									endcase
								end
						
						else if(clk_cnt==20_0000)
								begin
									case(point[15:12])
										4'b0000:
													seg_out <= 8'b1100_0000;
										4'b0001:
													seg_out <= 8'b1111_1001;
										4'b0010:
													seg_out <= 8'b1010_0100;
										
										4'b0011:
													seg_out <= 8'b1011_0000;
										4'b0100:
													seg_out <= 8'b1001_1001;
										4'b0101:
													seg_out <= 8'b1001_0010;
										
										4'b0110:
													seg_out <= 8'b1000_0010;
										4'b0111:
													seg_out <= 8'b1111_1000;
										4'b1000:
													seg_out <= 8'b1000_0000;
										4'b1001:
													seg_out <= 8'b1001_0000;
							//			default;					
									endcase
								end				
					end
				else
					clk_cnt <= 0;
			end	
	end
	
	
	reg addcube_state;
	
	always@(posedge CLK_50M or negedge RSTn)
		begin
			if(!RSTn)
				begin
					point <= 0;
					addcube_state <= 0;
				end
			else //这里可以用个CASE写
				begin
					case(addcube_state)
						0:
							begin
								if(add_cube)
									begin
										if(point[3:0]<9)//这里把每个4位分开管理了，因为要显示9,1001，所以每四个位分别控制个，时，百。。。
											point[3:0] <= point[3:0] + 4'd1;
										else
											begin
												point[3:0] <= 0;
												if(point[7:4]<9)
													point[7:4] <= point[7:4] + 4'd1;
												else
													begin
														point[7:4] <= 0;
														if(point[11:8]<9)
															point[11:8] <= point[11:8] + 4'd1;
														else 
															begin
																point[11:8] <= 0;
																point[15:12] <= point[15:12] + 4'd1;
															end
													end
											end								//BCD码转换
											addcube_state <= 1;
									end
							end
						1:
							if(!add_cube)
								addcube_state <= 0;	
					endcase
				end							
		end	
		
endmodule
