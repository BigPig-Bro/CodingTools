module display  (
	input 				key_sel,

	input				in1_hs,
	input				in1_vs,
	input				in1_de,
	input 	[15:0]		in1_data,


	input				in2_hs,
	input				in2_vs,
	input				in2_de,
	input 				in2_data,

	output reg 			out_hs,
	output reg 			out_vs,
	output reg 			out_de,
	output reg  	[23:0]	out_data
);

always@*begin 
	out_hs 	 	<= key_sel? in2_hs:in1_hs;
	out_vs 	 	<= key_sel? in2_vs:in1_vs;
	out_de 	 	<= key_sel? in2_de:in1_de;

	if(key_sel) 
		out_data <= in2_data ? 24'hffffff : 24'd0;
	else 
		out_data  <=	{in1_data[15:11],3'd0,in1_data[10:5],2'd0,in1_data[4:0],3'd0};							
end

endmodule