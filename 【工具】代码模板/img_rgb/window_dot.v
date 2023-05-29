module window_dot(x_in,y_in,de_in,data_in,win);
	input [9:0] x_in,y_in;
	input data_in;
	input de_in;
	output reg [79:0] win;
	
	//
	parameter end_x = 12'd1;
	parameter end_y = 12'd1;
	
	reg [79:0] win_reg;// (XY)up  down  left  right
	initial win_reg = {10'd1023,10'd1023, 10'd0,10'd0, 10'd1023,10'd1023, 10'd0,10'd0};
	
	always@(*)
	begin
		if(x_in == end_x & y_in == end_y)
		begin
			win = win_reg;
			win_reg = {10'd1023,10'd1023, 10'd0,10'd0, 10'd1023,10'd1023, 10'd0,10'd0};
		end
		else if(de_in)
			if(y_in < win_reg[69:60])
				win_reg[79:60] = {x_in,y_in};
			else if(y_in > win_reg[49:40])
				win_reg[59:40] = {x_in,y_in};
			else if(x_in > win_reg[19:10])
				win_reg[19:0] = {x_in,y_in};
			else if(x_in < win_reg[39:30])
				win_reg[39:20] = {x_in,y_in};
		else
		begin
			win_reg = win_reg;
		end
	end
	
endmodule 