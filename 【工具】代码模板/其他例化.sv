wire test_clk;
clk_test #(
    .FRE_IN     (50_000_000     ),
    .FRE_OUT    (50             )
)clk_test_m0(
    .clk_in     (clk            ),
    .clk_out    (test_clk       )  
);

//按键消抖
wire fuc_state;
key #(
	.CLK_FRE	(50   				),
	.CNT  		(1 					)
)key_m0(
	.clk 		(clk 				),
	.key_in 	(key_fuc 			),
	.key_cnt	(fuc_state 			)
	);
 
//串口收发
uart_top #(
	.CLK_FRE 	(CLK_FRE	),
	.UART_RATE 	(UART_RATE	)
	) uart_top_m0(
 	.clk			(clk			),
 	
 	.uart_tx		(uart_tx		),
 	.uart_rx		(uarr_rx		)
	);

//IIC
iic_top #(
	.CLK_FRE 			(CLK_FRE	),
	.IIC_FRE 			(UART_RATE	),
	.IIC_SLAVE_ADDR_EX 	(0			),
	.IIC_SLAVE_REG_EX 	(0			),
	.IIC_SLAVE_ADDR 	(8'HE8 		)
	)iic_top_m0(
 	.clk			(clk			),
 	.rst_n			(rst_n			),	

 	.iic_scl 		(iic_scl 		),
 	.iic_sda 		(iic_sda 		)
	);

//SPI 驱动 工作模式0
spi_master#(
	.CLK_FRE (CLK_FRE	 	),
	.SPI_FRE (SPI_FRE 	 	)
) spi_master_m0(
	.clk 	  	(clk 			),

	.spi_busy	(spi_busy 		),
	.spi_start  (spi_start 		),
	.send_dc  	(send_dc 	 	),
	.send_data	(send_data 		),
	.recv_data	(recv_data  	),

	.spi_cs   	(spi_cs   	 	),
	.spi_dc   	(	   			),
	.spi_sck  	(spi_sck  		),
	.spi_miso 	(spi_miso 		),
	.spi_mosi 	(spi_mosi 		)
);

//PWM 生成
pwm_ctr #(
	.CLK_FRE 			(CLK_FRE	)
	)pwm_ctr_m0(
 	.clk			(clk			),

	.pwm_duty 		(pwm_duty 		),
	.pwm_rate 		(pwm_rate 		),
	.pwm_out 		(pwm_out 		)
	);

//数码管
seg_top seg_top_m0(
	.clk 	 (clk 		),

	.data_in (seg_data 	),
	.sel 	 (seg_sel 	),
	.dig 	 (seg_dig 	)
	);