
//产生标准空白RGB视频流
wire 		rgb_clk;
wire 		rgb_vs,rgb_hs,rgb_de;
wire [ 9:0] rgb_x,rgb_y;
rgb_timing rgb_timing_m0(
	.rgb_clk	(rgb_clk		),	
	.rst_n		(rst_n			),	
	.rgb_hs		(rgb_hs			),
	.rgb_vs		(rgb_vs			),
	.rgb_de		(rgb_de			),
	.rgb_x		(rgb_x			),
	.rgb_y		(rgb_y			)
	);

//高斯滤波
wire                            gauss_hs;
wire                            gauss_vs;
wire                            gauss_de;
wire[15:0]                      gauss_data;
rgb_gauss #(
	.H_ACTIVE		(480			),
	.RGB_WIDTH 		(16 			)
) rgb_gauss_m0(
	.clk 			(video_clk 		),

	.in_hs 			(video_hs    	),
	.in_vs 			(video_vs    	),
	.in_de 			(video_de    	),
	.in_data 		(video_data  	),
		
	.out_hs 		(gauss_hs		),
	.out_vs 		(gauss_vs		),
	.out_de			(gauss_de 		),
	.out_data 		(gauss_data		)
	);
	
//RGB 2 YCBCR
wire                            ycbcr_hs;
wire                            ycbcr_vs;
wire                            ycbcr_de;
wire[23:0]                      ycbcr_data;
rgb2ycbcr rgb2ycbcr_m0(
	.clk 	 	(video_clk 					),
	.rgb_r 	 	({gauss_data[15:11],3'd0} 	),
	.rgb_g 	 	({gauss_data[10: 5],2'd0} 	),	
	.rgb_b 	 	({gauss_data[ 4: 0],3'd0} 	),
	.rgb_hs 	(gauss_hs 					),
	.rgb_vs 	(gauss_vs 					),
	.rgb_de 	(gauss_de 					),

	.ycbcr_y 	(ycbcr_data[23:16] 			),
	.ycbcr_cb 	(ycbcr_data[15: 8] 			),
	.ycbcr_cr 	(ycbcr_data[ 7: 0] 			),
	.ycbcr_hs 	(ycbcr_hs 					),
	.ycbcr_vs 	(ycbcr_vs 					),
	.ycbcr_de 	(ycbcr_de 					)
); 

//RGB二值化
wire thr_hs,thr_vs,thr_de,thr_data;
thrould_rgb thrould_rgb_m0(
	.clk 		(video_clk 	),

	.in_hs 		(rgb_hs		),
	.in_vs 		(rgb_vs		),
	.in_de 		(rgb_de		),
	.in_data 	(rgb_data	),

	.thr_hs 	(thr_hs		),
	.thr_vs 	(thr_vs		),
	.thr_de 	(thr_de		),
	.thr_data 	(thr_data	)
	);

wire thr_hs,thr_vs,thr_de,thr_data;
thrould_ycbcr thrould_ycbcr_m0(
	.clk 		(video_clk 		),

	.in_hs 		(ycbcr_hs		),
	.in_vs 		(ycbcr_vs		),
	.in_de 		(ycbcr_de		),
	.in_data 	(ycbcr_data 	),

	.thr_hs 	(thr_hs			),
	.thr_vs 	(thr_vs			),
	.thr_de 	(thr_de			),
	.thr_data 	(thr_data		)
	);

//形态学处理
wire        ero_hs,ero_vs,ero_de,ero_data;
thr_erode #(
	.H_ACTIVE		(800			)
) thr_erode_m0(
	.clk 			(video_clk 		),

	.in_hs 			(thr_hs    		),
	.in_vs 			(thr_vs    		),
	.in_de 			(thr_de    		),
	.in_data 		(thr_data  		),
		
	.out_hs 		(ero_hs			),
	.out_vs 		(ero_vs			),
	.out_de			(ero_de 		),
	.out_data 		(ero_data		)
	);

wire        dil_hs,dil_vs,dil_de,dil_data;
thr_dilate #(
	.H_ACTIVE		(800			)
) thr_dilate_m0(
	.clk 			(video_clk 		),

	.in_hs 			(ero_hs    		),
	.in_vs 			(ero_vs    		),
	.in_de 			(ero_de    		),
	.in_data 		(ero_data  		),
		
	.out_hs 		(dil_hs			),
	.out_vs 		(dil_vs			),
	.out_de			(dil_de 		),
	.out_data 		(dil_data		)
	);

//在标准RGB视频流中显示
 display display_m0(
	.key_sel		(key_sel		),

 	.in1_hs 		(video_hs		),
 	.in1_vs 		(video_vs		),
 	.in1_de 		(video_de		),
 	.in1_data 		(video_data 	),

 	.in2_hs 		(thr_hs			),
 	.in2_vs 		(thr_vs			),
 	.in2_de 		(thr_de			),
 	.in2_data 		(thr_data 		),
		
 	.out_hs 		(lcd_hs			),
 	.out_vs 		(lcd_vs			),
 	.out_de			(lcd_de 		),
 	.out_data 		(lcd_data		)
 	);
