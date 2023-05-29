module gra_heart(data_in,de_in,x_in,y_in,win);
	input data_in,de_in;
	input [9:0] x_in,y_in;
	
	output reg [19:0] win;
	
	reg [19:0] win_reg;
	
	initial win_reg = {10'd0,10'd0};
	
	always@(*)
	begin
		if(x_in == end_x & y_in == end_y)
		begin
			win = win_reg;
			win_reg = {10'd0,10'd0};
			
			first_dot = 1'b1;
		end
		else if(de_in&data_in&first_dot)
		begin
				win_reg[9:0] = x_in;
				win_reg[19:10] = y_in;
				
				first_dot = 1'b0;
		end
		else if(de_in&data_in)
			win_reg[9:0] = (x_in + win_reg[9:0])/2;
			win_reg[19:10] = (y_in + win_reg[19:10])/2;
		else
		else
		begin
			win_reg = win_reg;
		end
	end
endmodule 