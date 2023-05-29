module time_top(
	input 				clk,
	input 				rst_n,

	output reg [47:0]  time_num
);
//初始时间
parameter 	START_SEC = 8'h00;//xx秒
parameter 	START_MIN = 8'h00;//xx分
parameter 	START_HOU = 8'h12;//xx时
parameter 	START_DAY = 8'h01;//xx日
parameter 	START_MON = 8'h01;//xx月
parameter 	START_YEA = 8'h23;//20xx年

/************************************************************************************/
/*************************  秒 ******************************************************/
/***********************************************************************************/
reg [31:0] clk_1s;
always@(posedge clk)
	if(!rst_n)
		time_num[7:0] <= START_SEC;
	else if(clk_1s == 9_000_000 - 1)begin
		clk_1s <= 0;

		if(time_num[3:0] == 9)begin
			if(time_num[7:4] == 5)begin
				time_num[7:4] = 0;
				time_num[3:0] = 0;
			end
			else begin
				time_num[7:4] = time_num[7:4] + 1;
				time_num[3:0] = 0;
			end
		end
		else begin
			time_num[3:0] = time_num[3:0] + 1;
		end
	end
	else
		clk_1s <= clk_1s + 1;

/************************************************************************************/
/*************************  分 ******************************************************/
/***********************************************************************************/
always@(posedge clk)
	if(!rst_n)
		time_num[15:8] <= START_MIN;
	else if(clk_1s == 9_000_000 - 1)
		if(time_num[7:0] == 8'h59)
			if(time_num[15: 8] == 8'h59)
					time_num[15:8] = 0;
			else if(time_num[12: 8] == 4'h9)begin
				time_num[15:12] = time_num[15:12] + 1;
				time_num[11: 8] = 0;
			end
			else 
				time_num[11: 8] = time_num[11: 8] + 1;

/************************************************************************************/
/*************************  时 ******************************************************/
/***********************************************************************************/
always@(posedge clk)
	if(!rst_n)
		time_num[23:16] <= START_HOU;
	else if(clk_1s == 9_000_000 - 1)
		if(time_num[7:0] == 8'h59 && time_num[15:8] == 8'h59 )
			if(time_num[23:16] == 8'H23)
				time_num[23:16] <= 8'h00;
			else if(time_num[19:16] == 4'h9)begin
				time_num[23:20] = time_num[23:20] + 1;
				time_num[19:16] = 0;
			end
			else 
				time_num[19:16] = time_num[19:16] + 1;

/************************************************************************************/
/*************************  日 ******************************************************/
/***********************************************************************************/
always@(posedge clk)
	if(!rst_n)
		time_num[31:24] <= START_DAY;
	else if(clk_1s == 9_000_000 - 1)
		if(time_num[7:0] == 8'h59 && time_num[15:8] == 8'h59  && time_num[23:16] == 8'h23 )
			case(time_num[39:32])
				8'h01,8'h03,8'h05,8'h07,8'h08,8'h10,8'h12:
					if(time_num[31:24] == 8'H31)
						time_num[31:24] <= 8'h00;
					else if(time_num[27:24] == 4'h9)begin
						time_num[31:28] = time_num[31:28] + 1;
						time_num[27:24] = 0;
					end
					else 
						time_num[27:24] = time_num[27:24] + 1;

				8'h04,8'h06,8'h09,8'h11:
					if(time_num[31:24] == 8'H30)
						time_num[31:24] <= 8'h00;
					else if(time_num[27:24] == 4'h9)begin
						time_num[31:28] = time_num[31:28] + 1;
						time_num[27:24] = 0;
					end
					else 
						time_num[27:24] = time_num[27:24] + 1;

				8'h02:begin
					if((time_num[47:44] * 10 + time_num[43:40]) % 4 == 0 && time_num[31:24] == 8'H28)
						time_num[31:24] <= 8'h00;
					else if((time_num[47:44] * 10 + time_num[43:40]) % 4 != 0 && time_num[31:24] == 8'H27)
						time_num[31:24] <= 8'h00;
					else if(time_num[27:24] == 4'h9)begin
						time_num[31:28] = time_num[31:28] + 1;
						time_num[27:24] = 0;
					end
					else 
						time_num[27:24] = time_num[27:24] + 1;
				end
			endcase

/************************************************************************************/
/*************************  月 ******************************************************/
/***********************************************************************************/
always@(posedge clk)
	if(!rst_n)
		time_num[39:32] <= START_MON;
	else if(clk_1s == 9_000_000 - 1)
		if(time_num[7:0] == 8'h59 && time_num[15:8] == 8'h59  && time_num[23:16] == 8'h23 )
			case(time_num[39:32])
				8'h01,8'h03,8'h05,8'h07,8'h08,8'h10,8'h12:
					if(time_num[31:24] == 8'H31)
						if(time_num[39:32] == 8'H12)
							time_num[39:32] <= 8'h00;
						else if(time_num[35:32] == 4'h9)begin
							time_num[39:36] = time_num[39:36] + 1;
							time_num[35:32] = 0;
						end
						else 
							time_num[35:32] = time_num[35:32] + 1;

				8'h04,8'h06,8'h09,8'h11:
					if(time_num[31:24] == 8'H30)
						if(time_num[35:32] == 4'h9)begin
							time_num[39:36] = time_num[39:36] + 1;
							time_num[35:32] = 0;
						end
						else 
							time_num[35:32] = time_num[35:32] + 1;

				8'h02:
					if(time_num[31:24] == 8'H28 || ((time_num[47:44] * 10 + time_num[43:40]) % 4 != 0  && time_num[31:24] == 8'H27))
						time_num[35:32] = time_num[35:32] + 1;

			endcase

/************************************************************************************/
/*************************  年 ******************************************************/
/***********************************************************************************/
always@(posedge clk)
	if(!rst_n)
		time_num[47:40] <= START_YEA;
	else if(clk_1s == 9_000_000 - 1)
		if(time_num[7:0] == 8'h59 && time_num[15:8] == 8'h59  && time_num[23:16] == 8'h23 && time_num[31:24] == 8'h31  && time_num[39:32] == 8'h12 )
			if(time_num[47:40] == 8'H99)
				time_num[47:40] <= 8'h00;
			else if(time_num[43:40] == 4'h9)begin
				time_num[47:44] = time_num[47:44] + 1;
				time_num[43:40] = 0;
			end
			else 
				time_num[43:40] = time_num[43:40] + 1;
endmodule 