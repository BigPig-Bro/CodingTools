module key4x4 (
	input 				clk_slow 	,
	output reg [3:0] 	key_cal_out,
	input 	   [3:0]	key_row_in ,
	output   			key_en     ,
	output reg [3:0] 	key_value  
);

reg [1:0] state;
//扫描信号输出
always@(posedge clk_slow)
	state <= state + 1;
always@(posedge clk_slow)
	case(state)
		2'd0: key_cal_out <= 4'b0111;
		2'd1: key_cal_out <= 4'b1011;
		2'd2: key_cal_out <= 4'b1101;
		2'd3: key_cal_out <= 4'b1110;
	endcase

//键值输出
always@(posedge clk_slow)
	case({key_row_in,key_cal_out})
		8'b01110111: key_value <= 4'd7;
		8'b10110111: key_value <= 4'd8;
		8'b11010111: key_value <= 4'd9;
		8'b11100111: key_value <= 4'd10;// +
		8'b01111011: key_value <= 4'd4;
		8'b10111011: key_value <= 4'd5;
		8'b11011011: key_value <= 4'd6;
		8'b11101011: key_value <= 4'd11;// -
		8'b01111101: key_value <= 4'd1;
		8'b10111101: key_value <= 4'd2;
		8'b11011101: key_value <= 4'd3;
		8'b11101101: key_value <= 4'd12;// *
		8'b01111110: key_value <= 4'd0;
		8'b10111110: key_value <= 4'd13;//enter
		8'b11011110: key_value <= 4'd14;//delet
		8'b11101110: key_value <= 4'd15;// /
		default: key_value <= key_value;
	endcase
reg key_en_s;
//键使能输出
always@(posedge clk_slow)
	case({key_row_in,key_cal_out})
		8'b01110111, 
		8'b10110111, 
		8'b11010111, 
		8'b11100111, 
		8'b01111011, 
		8'b10111011, 
		8'b11011011, 
		8'b11101011, 
		8'b01111101, 
		8'b10111101, 
		8'b11011101, 
		8'b11101101, 
		8'b01111110, 
		8'b10111110, 
		8'b11011110, 
		8'b11101110:  key_en_s <= 1;
		default: key_en_s <= 0;
	endcase

reg [3:0] key_en_r;
always@(posedge clk_slow)
	key_en_r <= {key_en_r[2:0],key_en_s};

assign key_en = (key_en_r)?1'b1:1'b0;
endmodule