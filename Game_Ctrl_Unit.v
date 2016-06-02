module Game_Ctrl_Unit//��Ϸ����ģ�� ������Ϸ״̬������Ӧ�����ź�	

(
	input CLK_50M,
	input RSTn,
	
	input key1_press,//4������
	input key2_press,
	input key3_press,
	input key4_press,
	
	output reg [1:0] game_status,//4����Ϸ״̬
	
	input hit_wall,//ײǽ
	input hit_body,//�����Լ�������
	
	output reg die_flash,//ʧ�ܳ��ֵ�FLASH
	output reg restart//���¿�ʼ
		
);
		
	localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;
	
	reg [31:0] clk_cnt;//32λ�ļ�����
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			begin
				game_status <= START;//��λ��ʱ����START״̬
				clk_cnt <= 0;
				die_flash <= 1;
				restart <= 0;
			end
		else
			begin
				case(game_status)//ѡ����Ϸ״̬
					RESTART:
							begin//��RESTART״̬��
								 if(clk_cnt <= 5)//���������С�ڵ���5
									begin
										clk_cnt <= clk_cnt + 1;
										restart <= 1;
									end
								 else 
									begin
										game_status <= START;
										clk_cnt <= 0;
										restart <= 0;
									end
							end
	
					START:
						  begin//��START״̬�������һ���������£�����PLAY״̬
								if(key1_press|
									key2_press|
									key3_press|
									key4_press)
									
									game_status <= PLAY;
								else
									game_status <= game_status;
						  end
		
					PLAY://PLAY״̬�����ײǽ���������Լ����壬��DIE״̬
							begin
								if(hit_wall|hit_body)
									game_status <= DIE;
								else
									game_status <= game_status;
							end
			/*************************************/
		
					DIE:
						begin//DIE״̬
							if(clk_cnt <= 200_000_000)
								begin
									clk_cnt <= clk_cnt + 1'b1;
									if(clk_cnt == 25_000_000)//ʱ��ﵽ0.5S
										die_flash <= 0;
									else if(clk_cnt == 50_000_000)//ʱ��ﵽ1.0S
										die_flash <= 1'b1;
									else if(clk_cnt == 75_000_000)//�Դ�����
										die_flash <= 1'b0;
									else if(clk_cnt == 100_000_000)
										die_flash <= 1'b1;
									else if(clk_cnt == 125_000_000)
										die_flash <= 1'b0;
									else if(clk_cnt == 150_000_000)
										die_flash <= 1'b1;
									else
										die_flash <= 1'd1;//~~~
								end                    //Ŀ����ʹ������˸Ч��	
							else
								begin
									die_flash <= 1;
									clk_cnt <= 0;
									game_status <= RESTART;
								end
						end
				endcase
		   end
	end
	
	endmodule
	
