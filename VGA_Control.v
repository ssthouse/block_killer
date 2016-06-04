// VGA����ģ��  ���ݵ�ǰɨ�赽�ĵ�����һ���������Ӧ��ɫ
module VGA_Control
(
	input CLK_50M,
	input RSTn,
	
	input [1:0] snake,
	
	input [5:0] apple_x,
	input [4:0] apple_y,
	
	input [7:0] Score,
	
	output reg [9:0] x_pos,
	output reg [9:0] y_pos,
	
	output reg hsync,
	output reg vsync,
	output reg [2:0] color_out
	
);

/***************************************************************************/
	reg [9:0] clk_cnt;
	reg [9:0] line_cnt;
	
	reg clk_25M;
	
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam HEAD_COLOR = 3'b010;
	localparam BODY_COLOR = 3'b011;
	
	
/***************************************************************************/
/***************************************************************************/
	
	reg [3:0] lox;
	reg [3:0] loy;
	
	always@(posedge CLK_50M)
		begin
			clk_25M <= ~clk_25M;  //��25M����VGA����ģ��
		end
		
always@(*)
begin
	lox <= x_pos[3:0] ;
	loy <= y_pos[3:0] ;
	
	
	if(x_pos[9:4]  == apple_x&&y_pos[9:4]  == apple_y)
		case({loy,lox})
			8'b0000_0000:
				color_out <= 3'b000;//�����Ч���ǣ�ÿһ������ĵ�ַΪ��0,0���ĵط����Ǹ��ڵ㣬�����ܿ�����һ��һ����ɵ�����
			default:
				color_out <= 3'b001;//��ɫ
		endcase	
	else if(snake == NONE)
			color_out <= 3'b111;//��ɫ
	else if(snake == WALL)
			color_out <= 3'b111;//��ɫ
	else if(snake == HEAD|snake == BODY)//���ݵ�ǰɨ�赽�ĵ�����һ���������Ӧ��ɫ
			begin
				case({lox,loy})
					8'b0000_0000:
						color_out <= 3'b000;
					default:
						color_out <= (snake == HEAD)?HEAD_COLOR:BODY_COLOR;
				endcase
			end
	else 
		color_out <= 3'b000;
			
	if(x_pos >= iDisplay_SCORE_X_Res && x_pos <= iDisplay_SCORE_X_Res + 119
	&&y_pos >= iDisplay_SCORE_Y_Res && y_pos <= iDisplay_SCORE_Y_Res + 47)
		color_out <= oRGB_SCORE;
		
	if(x_pos >= iDisplay_S_T_X_Res && x_pos <= iDisplay_S_T_X_Res + 23
	&&y_pos >= iDisplay_S_T_Y_Res && y_pos <= iDisplay_S_T_Y_Res + 47)
		color_out <= {oRGB_Score_Tens[11],oRGB_Score_Tens[7],oRGB_Score_Tens[3]};
		
	if(x_pos >= iDisplay_S_T_X_Res +24 && x_pos <= iDisplay_S_T_X_Res + 47
	&&y_pos >= iDisplay_S_T_Y_Res && y_pos <= iDisplay_S_T_Y_Res + 47)
		color_out <= {oRGB_Score_Units[11],oRGB_Score_Units[7],oRGB_Score_Units[3]};
end
//*/

/****************'SCORE' display***********************/
wire CLK_25M_RES;
assign CLK_25M_RES = clk_25M;
wire [9:0]iVGA_X;
wire [9:0]iVGA_Y;
assign iVGA_X = x_pos;
assign iVGA_Y = y_pos; 
reg  [9:0] iDisplay_SCORE_X_Res;
reg  [9:0] iDisplay_SCORE_Y_Res;

wire [9:0] iDisplay_SCORE_X;
wire [9:0] iDisplay_SCORE_Y;

wire [2:0] oRGB_SCORE;

assign iDisplay_SCORE_X = iDisplay_SCORE_X_Res;
assign iDisplay_SCORE_Y = iDisplay_SCORE_Y_Res;


SCORE_Display SCORE_Display_1
	(
		.iVGA_CLK(clk_25M),
		.iRST_n(RSTn),
		.iVGA_X(iVGA_X),
		.iVGA_Y(iVGA_Y),
		.STRING_START_X(iDisplay_SCORE_X),
		.STRING_START_Y(iDisplay_SCORE_Y),
		.oRGB(oRGB_SCORE)	
	);
	
/*****************Score display****************/
//wire [7:0]Score;
//assign Score = 
reg  [9:0] iDisplay_S_T_X_Res;
reg  [9:0] iDisplay_S_T_Y_Res;

wire [9:0] iDisplay_S_T_X;
wire [9:0] iDisplay_S_T_Y;

wire [11:0] oRGB_Score_Tens;

assign iDisplay_S_T_X = iDisplay_S_T_X_Res;
assign iDisplay_S_T_Y = iDisplay_S_T_Y_Res;

wire [11:0] oRGB_Score_Units;
NUMBER_Display NUMBER_Display_S_T
	(
		.iVGA_CLK(clk_25M),
		.iRST_n(RSTn),
		.iVGA_X(iVGA_X),
		.iVGA_Y(iVGA_Y),	
		.STRING_START_X(iDisplay_S_T_X),
		.STRING_START_Y(iDisplay_S_T_Y),
		.iColor(12'hf00),
		.iNum(Score[7:4]),
		.oRGB(oRGB_Score_Tens)
	);
NUMBER_Display NUMBER_Display_S_U
	(
		.iVGA_CLK(clk_25M),
		.iRST_n(RSTn),
		.iVGA_X(iVGA_X),
		.iVGA_Y(iVGA_Y),	
		.STRING_START_X(iDisplay_S_T_X + 24),
		.STRING_START_Y(iDisplay_S_T_Y),
		.iColor(12'hf00),
		.iNum(Score[3:0]),
		.oRGB(oRGB_Score_Units)
	);              

		
endmodule
	