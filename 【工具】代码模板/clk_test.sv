module clk_test #(
	parameter 	FRE_IN 	= 50_000_000,
	parameter 	FRE_OUT = 50
	)(
	input 		clk_in,    // Clock
	
	output 		clk_out
);

reg [31:0] clk_cnt;
assign clk_out = clk_cnt > FRE_IN / FRE_OUT / 2;
always@(posedge clk_in) clk_cnt <= (clk_cnt >= FRE_IN / FRE_OUT)? 1: clk_cnt + 1;

endmodule