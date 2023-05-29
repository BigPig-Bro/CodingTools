//改代码ing, line 47
module max7219#(
	parameter 	CLK_FRE = 50_000_000
)(
	input 			clk,
	
	input  [23:0] 	send_data,

	output reg 		seg_clk,
	output reg 		seg_cs,
	output reg 		seg_din
	);
//MAX7219最大时钟频率 10M，此处仿照单片机程序降到了100K左右，实际生成的seg_clk更低一点，能用就行
reg [7:0]	clk_div = 0;
wire 		clk_100K;
assign      clk_100K = clk_div[CLK_FRE / 7_000_000];
always@(posedge clk)
	clk_div <= clk_div + 8'd1;

reg [31:0]	clk_delay = 16'd0;
reg [4:0]	send_cnt = 0;
reg [7:0] 	send_data= 0;
reg [1:0] 	state = 2'd0; //总状态机
reg [4:0]	write_cnt= 0;

parameter 	SEG_ADDR	= 104'h090a0b0c0f_0102030405060708;
parameter	SEG_DATA	= 104'hff03070100_0102030405060708;

always@(posedge clk_100K)
	case(state)
		2'd0:begin//随便延时了一点点再发数据
			seg_cs 		<= 1'b1;
			seg_clk		<= 1'b1;
			seg_din		<= 1'b1;

			if(clk_delay == 32'd100_000)begin//随便做个延时
				state <= state + 2'b1;
				clk_delay <= 32'd0;
			end
			else
				clk_delay <= clk_delay + 32'd1;
		end

		2'd1:begin //读取数据/地址指令，准备发送到max7219
			seg_cs <= 1'b0;
			if(write_cnt[0])//判断是地址还是数据
				case() //发送数据 SEG_DATA[((13-write_cnt[4:1])*8 - 1)-:8]
			else //发送地址
				send_data <= SEG_ADDR[((13-write_cnt[4:1])*8 - 1)-:8];
			state <= state + 'd1;
		end

		2'd2:begin //发送数据
			send_cnt <= send_cnt + 5'd1;
			seg_clk  <= send_cnt[0];
			seg_din  <= send_cnt[0]?seg_din:send_data[7-send_cnt[3:1]];

			if( send_cnt[3:0]==4'd15)
				if(write_cnt == 5'd9) begin
					write_cnt <= write_cnt + 5'd1;
					state <= 'd0;	
				end
				else if(write_cnt == 5'd25) begin
					write_cnt 	<= 5'd0;
					state <= 2'd0;	
				end
				else 
					state <= state + 2'd1;
		end

		2'd3:begin
			write_cnt <= write_cnt + 5'd1;
			seg_cs 	  <= write_cnt[0];
			state  <= 2'd1;
		end 
	endcase
endmodule 