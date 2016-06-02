module Snake_Eatting_Apple//ƻ����������ģ��
(
	input CLK_50M,
	input RSTn,
	
	input [5:0] head_x,
	input [5:0] head_y,
	
	output reg [5:0] apple_x,
	output reg [4:0] apple_y,

	output reg add_cube
);
/***************************************************************************/
	reg [31:0] clk_cnt;
	reg [10:0] random_num;
	
	always@(posedge CLK_50M)
		random_num <= random_num + 11'd927;  //�üӷ����������  
		//�������5λΪƻ��X���� ��5λΪƻ��Y����
	
	always@(posedge CLK_50M or negedge RSTn)
		begin
			if(!RSTn)
				begin
					clk_cnt <= 0;
					
					apple_x <= 24;//����Ĭ�ϳ��ֵ�ƻ����λ��
					apple_y <= 10;
					
					add_cube <= 0;
				end
			else
				begin
					clk_cnt <= clk_cnt + 1;
					if(clk_cnt == 250_000)//0.5���ʱ
						begin
							clk_cnt <= 0;
							if(apple_x == head_x&&apple_y == head_y)//��ͷ�Ե�ƻ��
								begin
									add_cube <= 1;
									apple_x <= (random_num[10:5]>6'd38)?(random_num[10:5]-6'd25):((random_num[10:5] == 6'd0)?6'd1:random_num[10:5]);
									apple_y <= (random_num[4:0]>5'd28)?(random_num[4:0]-5'd3):((random_num[4:0] == 5'd0)?5'd1:random_num[4:0]);
								end   //�ж�������Ƿ񳬳�ƵĻ���귶Χ �������ת��Ϊ�¸�ƻ����X Y����
							else
								add_cube <= 0;
						end
				end
		end
endmodule
