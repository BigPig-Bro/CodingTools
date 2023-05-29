`timescale  1ns/1ns 
module top_tb ();
reg clk = 0,rst_n = 1;
top m0(
	.clk		(clk	),
	.resetn		(rst_n	),
	.lcd_resetn	(	),	
	.lcd_clk	(	),	
	.lcd_cs		(	),
	.lcd_rs		(	),
	.lcd_data	(	),	
	.lcd_bl		(	)
	);
initial #100000000 $stop;
always #5 clk = ~clk;
endmodule