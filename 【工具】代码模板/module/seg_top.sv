module seg_top(
	input  				 	clk,//普通时钟信号
	input  		[31:0]  	data_in,
	output reg  [ 5:0]  	sel,
	output reg  [ 7:0]  	dig);//段选和位选信号
	
	reg [31:0] data_r;
	reg [7:0] temp;//扫描间隔计时器
	reg [3:0] cnt;//计数数字
	reg [2:0] count_sel;//位选协助
	reg [9:0] timer;//时间计数
	reg [7:0] sel_r;
		
	always@(posedge timer[9])
		case(count_sel)
			3'd0: data_r = data_in/10;
			3'D1,3'D2,3'D3,3'D4,3'D5,3'D6,3'D7: data_r=data_r/10;
		endcase

	always@(posedge clk)//显示模块
	begin
		case(count_sel)
			3'd0:
			begin
				cnt = data_in % 32'd10;
				sel_r<=6'b011111;
			end
			
			3'd1:
			begin
				cnt = data_r % 32'd10;
				sel_r<=6'b101111;
			end
			
			3'd2:
			begin
				cnt = data_r % 32'd10;
				sel_r<=6'b110111;	
			end
			
			3'd3:
			begin
				cnt = data_r % 32'd10;
				sel_r<=6'b111011;	
			end
			
			3'd4:
			begin
				cnt = data_r % 32'd10;
				sel_r<=6'b111101;	
			end
			
			3'd5:
			begin
				cnt = data_r % 32'd10;
				sel_r<=6'b111110;	
			end
			
		endcase

		sel <= sel_r;
	end
	
	always@*
	    case(cnt)//以下为共阳数码管的编码
			0:dig=8'b1100_0000;
			1:dig=8'b1111_1001;
			2:dig=8'b1010_0100;
			3:dig=8'b1011_0000;
			4:dig=8'b1001_1001;
			5:dig=8'b1001_0010;
			6:dig=8'b1000_0010;
			7:dig=8'b1111_1000;
			8:dig=8'b1000_0000;
			9:dig=8'b1001_0000;
			default:dig=8'b0000_0000;
		endcase

	always@(posedge clk)//扫描模块
		timer = timer + 32'd1;

	always@(posedge timer[9])
		count_sel <= count_sel + 3'd1;

endmodule
