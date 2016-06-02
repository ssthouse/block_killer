module Snake//���˶��������ģ��
(
	input CLK_50M,
	input RSTn,
	
	input left_press,
	input right_press,
	input up_press,
	input down_press,
	
	output reg [1:0] snake,//���ڱ�ʾ��ǰɨ��ɨ��Ĳ��� ����״̬ 00���� 01��ͷ 10������ 11��ǽ
	
	input [9:0] x_pos,//��4λ��ʾһ�����������ص����꣬��5λ��ʾ������
	input [9:0] y_pos,//ɨ������  ��λ�������ص㡱
	
	output [5:0] head_x,	//ͷ����һ���X����
	output [5:0] head_y,//ͷ����һ���Y����
	
	input add_cube,//���峤�������ź�
	
	input [1:0] game_status,//������Ϸ״̬

	
	output reg [7:0] cube_num_O,
	
	output reg hit_body,
	output reg hit_wall,
	input die_flash
);
/***************************************************************************/
	reg [7:0]cube_num;
	localparam UP = 2'b00;
	localparam DOWN = 2'b01;
	localparam LEFT = 2'b10;
	localparam RIGHT = 2'b11;
	
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam PLAY = 2'b10;
	
/***************************************************************************/
/***************************************************************************/
	reg [31:0] cnt;
	
	wire [1:0] direct;
	reg [1:0] direct_r;
	
	assign direct = direct_r;
	
	reg [1:0] direct_next;
	
	reg change_to_left;
	reg change_to_right;
	reg change_to_up;
	reg change_to_down;
	
	reg [5:0] cube_x [15:0];//���ָ�ʽ�Ƕ�ά�������˼����ַΪ0~15��ÿ����ַΪ6bits
	reg [5:0] cube_y [15:0];//�峤���� ��λ�������ӡ� ��16*16������ɵĸ���
	reg [15:0] is_exist;//��������������������1Ϊ����0Ϊ��
	
	reg [2:0] color;//RGB����λ
	
	assign head_x = cube_x[0];//cube_x��cube_y��ʾһ����������������ڵĸ�����

	assign head_y = cube_y[0];
	//cube[0]��ʾhead����񣬣�����������ɫ��ͷ����head��������ҪҪ���Ƶĵط������漰��DIE .EattingApple.
	//���������˶��켣�ȡ�������head������ȡ������Ϊ����ź�head_x��head_y���ں����ģ�顣

/***************************************************************************/
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			direct_r <= RIGHT;//Ĭ��һ������������ǰ��
		else
			direct_r <= direct_next;//����
	end
	
/***************************************************************************/
/***************************************************************************/
	
	always@(posedge CLK_50M or negedge RSTn)
	begin
		if(!RSTn)
			begin
				cnt <= 0;
				//X�����ҵ�����Y���ϵ��µ���
				cube_x[0] <= 10;//��ͷĬ�ϳ��ֵ�X������10
				cube_y[0] <= 5;//��ͷĬ�ϳ��ֵ�Y������5
				
				cube_x[1] <= 9;//��һ�������X������9
				cube_y[1] <= 5;//��һ�������Y���껹��5
				
				cube_x[2] <= 8;//�ڶ��������X������8
				cube_y[2] <= 5;//�ڶ��������Y���껹��5
				
				
				//�����������ʱ��û�У�����û����ν�����꣬��Ϊ0�������16������
				cube_x[3] <= 0;
				cube_y[3] <= 0;
				
				cube_x[4] <= 0;
				cube_y[4] <= 0;
				
				cube_x[5] <= 0;
				cube_y[5] <= 0;
				
				cube_x[6] <= 0;
				cube_y[6] <= 0;
				
				cube_x[7] <= 0;
				cube_y[7] <= 0;
				
				cube_x[8] <= 0;
				cube_y[8] <= 0;
				
				cube_x[9] <= 0;
				cube_y[9] <= 0;
				
				cube_x[10] <= 0;
				cube_y[10] <= 0;
				
				cube_x[11] <= 0;
				cube_y[11] <= 0;
				
				cube_x[12] <= 0;
				cube_y[12] <= 0;
				
				cube_x[13] <= 0;
				cube_y[13] <= 0;
				
				cube_x[14] <= 0;
				cube_y[14] <= 0;
				
				cube_x[15] <= 0;
				cube_y[15] <= 0;
				
				
				hit_wall <= 0;
				
				hit_body <= 0;
			end
		else
			begin//����ǿ��һ�£�begin end����������˳��ִ�е�
				cnt <= cnt + 1;//������һ��ELSE�ŵ�����ȥ
				
				if(cnt == 12_500_000) //0.02us*12'500'000 = 0.25s   ÿ���ƶ��Ĵ�
					begin
						cnt <= 0;
						
						if(game_status == PLAY)
							begin
							//ײǽ������������������ң�ײ���ϣ�Y = 1��ײ���±ߣ�Y = 28��ײ����ߣ�X = 1��ײ���ұߣ�X = 38������ͼ��֪����~
								if((direct == UP&&cube_y[0] == 1)|(direct == DOWN&&cube_y[0] == 28)|(direct == LEFT&&cube_x[0] == 1)|(direct == RIGHT&&cube_x[0] == 38))
									hit_wall <= 1;
								
								else if((cube_y[0] == cube_y[1]&&cube_x[0] == cube_x[1]&&is_exist[1] == 1)|
										(cube_y[0] == cube_y[2]&&cube_x[0] == cube_x[2]&&is_exist[2] == 1)|
										(cube_y[0] == cube_y[3]&&cube_x[0] == cube_x[3]&&is_exist[3] == 1)|
										(cube_y[0] == cube_y[4]&&cube_x[0] == cube_x[4]&&is_exist[4] == 1)|
										(cube_y[0] == cube_y[5]&&cube_x[0] == cube_x[5]&&is_exist[5] == 1)|
										(cube_y[0] == cube_y[6]&&cube_x[0] == cube_x[6]&&is_exist[6] == 1)|
										(cube_y[0] == cube_y[7]&&cube_x[0] == cube_x[7]&&is_exist[7] == 1)|
										(cube_y[0] == cube_y[8]&&cube_x[0] == cube_x[8]&&is_exist[8] == 1)|
										(cube_y[0] == cube_y[9]&&cube_x[0] == cube_x[9]&&is_exist[9] == 1)|
										(cube_y[0] == cube_y[10]&&cube_x[0] == cube_x[10]&&is_exist[10] == 1)|
										(cube_y[0] == cube_y[11]&&cube_x[0] == cube_x[11]&&is_exist[11] == 1)|
										(cube_y[0] == cube_y[12]&&cube_x[0] == cube_x[12]&&is_exist[12] == 1)|
										(cube_y[0] == cube_y[13]&&cube_x[0] == cube_x[13]&&is_exist[13] == 1)|
										(cube_y[0] == cube_y[14]&&cube_x[0] == cube_x[14]&&is_exist[14] == 1)|
										(cube_y[0] == cube_y[15]&&cube_x[0] == cube_x[15]&&is_exist[15] == 1))
										
										hit_body <= 1;//ͷ��Y���� = ��һλ�����Y���� �� ͷ��X���� = ��һλ�����X���� �� ����ĸó���λ����  ��������
								else
									 begin//����Ĵ����ǲ����������󣬺���һ���������ǰ��һ������ĵ�ַ~
										cube_x[1] <= cube_x[0];
										cube_y[1] <= cube_y[0];
										
										cube_x[2] <= cube_x[1];
										cube_y[2] <= cube_y[1];
										
										cube_x[3] <= cube_x[2];
										cube_y[3] <= cube_y[2];
										
										cube_x[4] <= cube_x[3];
										cube_y[4] <= cube_y[3];
										
										cube_x[5] <= cube_x[4];
										cube_y[5] <= cube_y[4];
										
										cube_x[6] <= cube_x[5];
										cube_y[6] <= cube_y[5];
										
										cube_x[7] <= cube_x[6];
										cube_y[7] <= cube_y[6];
										
										cube_x[8] <= cube_x[7];
										cube_y[8] <= cube_y[7];
										
										cube_x[9] <= cube_x[8];
										cube_y[9] <= cube_y[8];
										
										cube_x[10] <= cube_x[9];
										cube_y[10] <= cube_y[9];
										
										cube_x[11] <= cube_x[10];
										cube_y[11] <= cube_y[10];
										
										cube_x[12] <= cube_x[11];
										cube_y[12] <= cube_y[11];
										
										cube_x[13] <= cube_x[12];
										cube_y[13] <= cube_y[12];
										
										cube_x[14] <= cube_x[13];
										cube_y[14] <= cube_y[13];
										
										cube_x[15] <= cube_x[14];
										cube_y[15] <= cube_y[14];
										//�����˶��㷨 ������λ�ƶ����¸�����Ϊ��һ������λ��ǰ���� �˶����İ���Ƶ��Ľ���
										case(direct)//����ѡ����ǰ�������ǽ�ߵ�ʱ��							
											UP:
												begin
													if(cube_y[0] == 1)
														hit_wall <= 1;
													else
														cube_y[0] <= cube_y[0] - 6'd1;//ע������ϵ�������� - 1����Ϊ��������0�����������ߵĻ���Y�� - 1�ġ�
												end
											
											DOWN:
												begin
													if(cube_y[0] == 28)
														hit_wall <= 1;
													else
														cube_y[0] <= cube_y[0] + 6'd1;
												end
											LEFT:
												begin
													if(cube_x[0] == 1)
														hit_wall <= 1;
													else
														cube_x[0] <= cube_x[0] - 6'd1;//ע������ϵ�������� + 1����Ϊ��������0�����������ߵĻ���X�� - 1�ġ�	
												end
											
											RIGHT:
												begin
													if(cube_x[0] == 38)
														hit_wall <= 1;
													else
														cube_x[0] <= cube_x[0] + 6'd1;
														//���ݰ��°����ж��Ƿ�ײǽ ���򰴹��ɸı�ͷ������
												end
										endcase																	
									 end					
							end
					end 
			end 
	end
/***************************************************************************/
	
	always@(*)//����Ҳ�ǵ�ƽ����
	begin   //���ݵ�ǰ�˶�״̬�����¼�λ�ж���һ���˶����������ǽ�ߵ����
		direct_next = direct;
		
		case(direct)
			UP://���ݰ����������������ѡ��
				begin
					if(change_to_left)
						direct_next = LEFT;
					else if(change_to_right)
						direct_next = RIGHT;
					else
						direct_next = UP;
				end
			
			DOWN:
				begin
					if(change_to_left)
						direct_next = LEFT;
					else if(change_to_right)
						direct_next = RIGHT;
					else
						direct_next = DOWN;
				end		
			LEFT:
				begin
					if(change_to_up)
						direct_next = UP;
					else if(change_to_down)
						direct_next = DOWN;
					else
						direct_next = LEFT;
				end
			
			RIGHT:
				begin
					if(change_to_up)
						direct_next = UP;
					else if(change_to_down)
						direct_next = DOWN;
					else
						direct_next = RIGHT;
				end		
		endcase
	end
/***************************************************************************/
	
	always@(posedge CLK_50M)//���ĸ�������ֵ
	begin
		if(left_press == 1)
				change_to_left <= 1;
		else if(right_press == 1)
				change_to_right <= 1;
		else if(up_press == 1)
				change_to_up <= 1;
		else if(down_press == 1)
				change_to_down <= 1;			
		else 
			begin
				change_to_left <= 0;
				change_to_right <= 0;
				change_to_up <= 0;
				change_to_down <= 0;
			end
	end
/***************************************************************************/
	reg addcube_state;//��ƻ��״̬
	
	always@(posedge CLK_50M or negedge RSTn)//����ƻ��û����������add_cube == 1����ʾ�峤����һλ��"is_exixt[cube_num] <= 1",�õ�cube_numλ�����֡�
		begin
			if(!RSTn)
				begin
					is_exist <= 16'd7;//0111
					cube_num <= 3;
					cube_num_O <= 0;
					addcube_state <= 0;//��ʼ��ʾ����Ϊ3��is_exist = 0000_0000_0111
				end		
		   else 
				begin//�ж���ͷ��ƻ�������غϣ�������
					case(addcube_state)
						0:
							begin
								if(add_cube)
									begin
										cube_num <= cube_num + 7'd1;
										cube_num_O <= cube_num_O + 1;
										if(cube_num_O[3:0] == 9)
										begin
											cube_num_O[3:0] <= 0;
											cube_num_O[7:4] <= cube_num_O[7:4] + 1;
										end
										is_exist[cube_num] <= 1;
										addcube_state <= 1;//�����¡��ź�
									end
								else
									begin
										cube_num <= cube_num;
										is_exist[cube_num] <= is_exist[cube_num];
										addcube_state <= addcube_state;
									end 
						   end
						1:
							begin
								if(!add_cube)//add_cube����ı��ˣ�����
									addcube_state <= 0;
								else
									addcube_state <= addcube_state;
						   end
					endcase
			   end
		end
	
	reg [3:0] lox;
	reg [3:0] loy;
	
	always@(x_pos or y_pos or is_exist or die_flash)//ע�⣬�����ǵ�ƽ�����������õ���������ֵ��=��
		begin
			if(x_pos >= 0&&x_pos<640&&y_pos >= 0&&y_pos<480)
				begin
					if(x_pos[9:4] == 0|y_pos[9:4] == 0|x_pos[9:4] == 39|y_pos[9:4] == 29)
						snake = WALL;//ɨ��ǽ
					else if(x_pos[9:4] == cube_x[0]&&y_pos[9:4] == cube_y[0]&&is_exist[0] == 1)//ɨ��ͷ
							snake = (die_flash == 1)?HEAD:NONE;//������
					else if((x_pos[9:4] == cube_x[1]&&y_pos[9:4] == cube_y[1]&&is_exist[1] == 1)|
							 (x_pos[9:4] == cube_x[2]&&y_pos[9:4] == cube_y[2]&&is_exist[2] == 1)|
							 (x_pos[9:4] == cube_x[3]&&y_pos[9:4] == cube_y[3]&&is_exist[3] == 1)|
							 (x_pos[9:4] == cube_x[4]&&y_pos[9:4] == cube_y[4]&&is_exist[4] == 1)|
							 (x_pos[9:4] == cube_x[5]&&y_pos[9:4] == cube_y[5]&&is_exist[5] == 1)|
							 (x_pos[9:4] == cube_x[6]&&y_pos[9:4] == cube_y[6]&&is_exist[6] == 1)|
							 (x_pos[9:4] == cube_x[7]&&y_pos[9:4] == cube_y[7]&&is_exist[7] == 1)|
							 (x_pos[9:4] == cube_x[8]&&y_pos[9:4] == cube_y[8]&&is_exist[8] == 1)|
							 (x_pos[9:4] == cube_x[9]&&y_pos[9:4] == cube_y[9]&&is_exist[9] == 1)|
							 (x_pos[9:4] == cube_x[10]&&y_pos[9:4] == cube_y[10]&&is_exist[10] == 1)|
							 (x_pos[9:4] == cube_x[11]&&y_pos[9:4] == cube_y[11]&&is_exist[11] == 1)|
							 (x_pos[9:4] == cube_x[12]&&y_pos[9:4] == cube_y[12]&&is_exist[12] == 1)|
							 (x_pos[9:4] == cube_x[13]&&y_pos[9:4] == cube_y[13]&&is_exist[13] == 1)|
							 (x_pos[9:4] == cube_x[14]&&y_pos[9:4] == cube_y[14]&&is_exist[14] == 1)|
							 (x_pos[9:4] == cube_x[15]&&y_pos[9:4] == cube_y[15]&&is_exist[15] == 1))
													
							snake = (die_flash == 1)?BODY:NONE;//ɨ������
					else 
							snake = NONE;
				end
			else
			snake = NONE;
		end
	
endmodule
