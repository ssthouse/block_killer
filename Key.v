
	module Key//�������ģ�� ��ʱ����
(	input CLK_50M,
	input RSTn,
	
	input left,
	input right,
	input up,
	input down,
	
	output reg left_key_press,
	output reg right_key_press,
	output reg up_key_press,
	output reg down_key_press

);

/***************************************************************************/
	reg [31:0] clk_cnt;//32λ����������������100MS
	
	reg left_key_last;
	reg right_key_last;
	reg up_key_last;
	reg down_key_last;
	
	always@(posedge CLK_50M or negedge RSTn)
		begin
			if(!RSTn)
				begin
					clk_cnt <= 0;
					
					left_key_press <= 0;
					right_key_press <= 0;
					up_key_press <= 0;
					down_key_press <= 0;
					
					left_key_last <= 0;
					right_key_last <= 0;
					up_key_last <= 0;
					down_key_last <= 0;						
				end
			else 
				begin
					if(clk_cnt == 5_0000)//100MS����ʱ���������µ�ƽΪ0
						begin//�������ֲŻ���Ч������Ϊlast��ԭ�ź��ͺ�һ�����ڣ�������㷨�Ǽ�⵽lastΪ0��ԭ�źű�Ϊ1����˵���ղŰ���������
							clk_cnt <= 0;//����������
							
							left_key_last <= left;
							right_key_last <= right;
							up_key_last <= up;
							down_key_last <= down;
							
							if(left_key_last == 0 && left == 1)
								left_key_press <= 1;
							if(right_key_last == 0 && right == 1)
								right_key_press <= 1;
							if(up_key_last == 0 && up == 1)
								up_key_press <= 1;
							if(down_key_last == 0 && down == 1)
								down_key_press <= 1;	
						end
					else
						begin
							clk_cnt <= clk_cnt + 1;
							//���û�а������£��򱣳����������źŶ�Ϊ��
							left_key_press <= 0;
							right_key_press <= 0;
							up_key_press <= 0;
							down_key_press <= 0;
						end
				end	
		end				
	
endmodule
