module thr_dilate#(
	parameter H_ACTIVE = 480
)(
	input			clk ,			

	input			in_hs, 			
	input			in_vs, 			
	input			in_de, 			
	input			in_data, 		
		
	output 			out_hs, 		
	output 			out_vs, 		
	output 			out_de,			
	output 			out_data 		
);

reg out_data_r;//结果
wire w1,w2,w3;//三行数据输出

linebuffer_Wapper#//缓存三行的模块
(
	.no_of_lines 		(3 			),
	.samples_per_line 	(H_ACTIVE	),
	.data_width 		(1 			)
)
 linebuffer_Wapper_test(
	.ce         (1'b1   		),
	.wr_clk     (clk   			),
	.wr_en      (in_de   		),
	.wr_rst     (1'b1    		),
	.data_in    (in_data  		),
	.rd_en      (in_de   		),
	.rd_clk     (clk    		),
	.rd_rst     (1'b1    		),
	.data_out   ({w3,w2,w1}   	)
   );
	
reg [2:0] [15:0] p1,p2,p3;
always@(posedge clk)
begin//形成3*3算子
	p1 <= {p1[1:0],w1};
	p2 <= {p2[1:0],w2};
	p3 <= {p3[1:0],w3};
end	

always@(posedge clk)
begin
	if(p1[0] | p1[1] | p1[2] | p2[0] | p2[1] | p2[2] | p3[0] | p3[1] | p3[2])
		out_data_r <= 1'b1;
	else
		out_data_r <= 1'b0;
end

assign out_data   = out_data_r;//数据输出

assign out_de 	  = de_r[4];//DE输出
assign out_vs 	  = vs_r[4];//VS输出
assign out_hs 	  = hs_r[4];//HS输出

reg[4:0] vs_r,hs_r,de_r;
always@(posedge clk )//根据数据处理延迟4个时钟
begin
	vs_r        <= {vs_r[3:0],in_vs};
	hs_r		<= {hs_r[3:0],in_hs};
	de_r		<= {de_r[3:0],in_de};
end
endmodule 

