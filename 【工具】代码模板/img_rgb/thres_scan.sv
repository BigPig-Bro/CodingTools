module thres_scan(
	input 		 		clk, 			
	input 		[ 9:0]	loc_x, 			
	input 		[ 9:0]	loc_y,		
	input				thres_data,thres_de,

	output  reg [19:0]	thres_lt,thres_rd
	);
reg [ 9:0] thres_lt_x,thres_lt_y;
reg [ 9:0] thres_rd_x,thres_rd_y;

always@(posedge clk)
	if(loc_y == 10'd271 && loc_x == 10'd479)begin//数据统计
		thres_lt <= {thres_lt_x,thres_lt_y};
		thres_rd <= {thres_rd_x,thres_rd_y};

		thres_lt_x <= 10'd279;
		thres_lt_y <= 10'd471;
		thres_rd_x <= 10'd0;
		thres_rd_y <= 10'd0;
	end
	else begin
		if (thres_de) begin
			if(thres_data)begin
				if(loc_x > thres_rd_x) 		thres_rd_x <= loc_x;
				else if(loc_x < thres_lt_x) 	thres_lt_x <= loc_x;

				if(loc_y > thres_rd_y) 		thres_rd_y <= loc_y;
				else if(loc_y < thres_lt_y) 	thres_lt_y <= loc_y;
			end
		end
	end
endmodule
