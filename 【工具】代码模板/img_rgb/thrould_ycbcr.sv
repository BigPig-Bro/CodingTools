module thrould_ycbcr(
	input 		 clk,

	input [23:0] in_data,
	input 		 in_hs,in_vs,in_de,

	output reg  thr_data,
	output reg 	thr_de,thr_vs,thr_hs );
	//以下为RGB阈值，需要通过逻辑分析仪调节
	parameter threshold1_y_min   = 8'd50;
	parameter threshold1_y_max   = 8'd200; //0 - 255
	parameter threshold1_cb_min  = 8'd133;
	parameter threshold1_cb_max  = 8'd173; //0 - 255
	parameter threshold1_cr_min  = 8'd77;
	parameter threshold1_cr_max  = 8'd127; //0 - 255

	
	always@(posedge clk)
	begin
		if(	  in_data[ 7: 0] <= threshold1_cr_max & in_data[ 7: 0] >= threshold1_cr_min 
			& in_data[15: 8] <= threshold1_cb_max & in_data[15: 8] >= threshold1_cb_min 
			& in_data[23:16] <= threshold1_y_max  & in_data[23:16] >= threshold1_y_min  )
		begin
			thr_data <= 1'b1;
		end
		else
		begin
			thr_data <= 1'b0;
		end

		thr_de <= in_de;
		thr_hs <= in_hs;
		thr_vs <= in_vs;
	end
	
endmodule 