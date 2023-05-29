module spi_top#(
	parameter CLK_FRE = 50,
	parameter SPI_FRE = 200  //SPI SCK 步进x10Khz
	) (
	input 			  	clk,rst_n,

	output  			spi_cs   ,   
	output  			spi_dc   ,   
	output  			spi_sck  ,  
	input 				spi_miso , 
	output  			spi_mosi  
);

parameter DELAY_100MS = CLK_FRE * 1000 * 100;
parameter RS_DAT = 1;
parameter RS_CMD = 0;

parameter INIT_CMD_NUM 	=  ;

enum {STATE_RESET ,STATE_INIT  ,STATE_CLEAR ,STATE_WRITE ,STATE_WAIT} STATE;

logic [ 2:0] pre_state = 0;
logic [ 2:0] state_main = 0;
logic [ 2:0] state_sub = 0;
logic [31:0] clk_delay = 0;

logic [10:0] send_cnt = 0;
logic [27:0][ 7:0] init_cmd = { };
//注意使用readmem要单独给时钟
wire 		send_busy ;	
reg 		send_en 	= 'd0;   	
reg  	  	send_dc 	= 'd0;   	
reg [ 7:0] 	send_data 	= 'd0;

always@(posedge clk,negedge rst_n)
	if(!rst_n)begin 
		state_main <= 0;
		state_sub  <= 0;
	end
	else
		case (state_main)
			STATE_RESET://reset
				if(clk_delay == DELAY_100MS)begin
					clk_delay <= 'd0;
					state_main <= STATE_INIT;
				end
				else  
					clk_delay ++;

			STATE_INIT://initial SPI
				if (send_cnt == INIT_CMD_NUM) //初始化完成
				begin 
					send_en <= 0;
					send_cnt <= 0;
					state_sub <= 0;

					state_main ++;
				end
				else if(!send_busy)begin 		  //spi空闲
					send_en <= 1;
					send_dc <= SPI_CMD;
					send_data <= init_cmd[INIT_CMD_NUM - 1 - send_cnt];
					send_cnt ++;

					pre_state <= state_main;
					state_main <= STATE_WAIT;
				end
				else
					send_en <= 0;
			
			STATE_WRITE://write data
					
			STATE_WAIT://WAIT FOR BUSY 
				if(send_busy) state_main <= pre_state;

			default : begin
				state_main <= 'd0;
				state_sub  <= 'd0;
			end
		endcase

spi_master#(
	.CLK_FRE (CLK_FRE	 ),
	.SPI_FRE (SPI_FRE 	 )
	) spi_master_m0(
	.clk 	  (clk 			),
	.send_busy(send_busy 	),

	.send_en  (send_en 		),
	.send_dc  (send_dc 	 	),
	.send_data(send_data 	),
	.recv_data(  	 	 	),

	.spi_cs   (spi_cs   	),
	.spi_dc   (spi_dc   	),
	.spi_sck  (spi_sck  	),
	.spi_miso (spi_miso 	),
	.spi_mosi (spi_mosi 	)
	);

endmodule