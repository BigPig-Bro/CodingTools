module rgb_timing(
	input               rgb_clk,           //pixel clock
	input               rst_n,         //reset signal high active
	output  reg         rgb_hs,            //horizontal synchronization
	output  reg         rgb_vs,            //vertical synchronization
	output            	rgb_de,            //video valid

	output reg [10:0] 	rgb_x,              //video x position 
	output reg [10:0] 	rgb_y               //video y position 
	);

//74.25M
`ifdef  VIDEO_1280_720
parameter H_ACTIVE 	= 16'd1280;           //horizontal active time (pixels)
parameter H_FP 		= 16'd110;                //horizontal front porch (pixels)
parameter H_SYNC 	= 16'd40;               //horizontal sync time(pixels)
parameter H_BP 		= 16'd220;                //horizontal back porch (pixels)
parameter V_ACTIVE  = 16'd720;            //vertical active Time (lines)
parameter V_FP   	= 16'd5;                 //vertical front porch (lines)
parameter V_SYNC  	= 16'd5;               //vertical sync time (lines)
parameter V_BP   	= 16'd20;                //vertical back porch (lines)
parameter HS_POL  	= 'b1;                 //horizontal sync polarity, 1 : POSITIVE,0 : NEGATIVE;
parameter VS_POL  	= 'b1;                 //vertical sync polarity, 1 : POSITIVE,0 : NEGATIVE;
`endif

//480x272 9Mhz
`ifdef  VIDEO_480_272
parameter H_ACTIVE = 16'd480; 
parameter H_FP = 16'd2;       
parameter H_SYNC = 16'd41;    
parameter H_BP = 16'd2;       
parameter V_ACTIVE = 16'd272; 
parameter V_FP  = 16'd2;     
parameter V_SYNC  = 16'd10;   
parameter V_BP  = 16'd2;     
parameter HS_POL = 'b0;
parameter VS_POL = 'b0;
`endif

//640x480 25.175Mhz
`ifdef  VIDEO_640_480
parameter H_ACTIVE = 16'd640; 
parameter H_FP = 16'd16;      
parameter H_SYNC = 16'd96;    
parameter H_BP = 16'd48;      
parameter V_ACTIVE = 16'd480; 
parameter V_FP  = 16'd10;    
parameter V_SYNC  = 16'd2;    
parameter V_BP  = 16'd33;    
parameter HS_POL = 'b0;
parameter VS_POL = 'b0;
`endif

//800x480 33Mhz
`ifdef  VIDEO_800_480
parameter H_ACTIVE = 16'd800; 
parameter H_FP = 16'd40;      
parameter H_SYNC = 16'd128;   
parameter H_BP = 16'd88;      
parameter V_ACTIVE = 16'd480; 
parameter V_FP  = 16'd1;     
parameter V_SYNC  = 16'd3;    
parameter V_BP  = 16'd21;    
parameter HS_POL = 'b0;
parameter VS_POL = 'b0;
`endif

//800x600 40Mhz
`ifdef  VIDEO_800_600
parameter H_ACTIVE = 16'd800; 
parameter H_FP = 16'd40;      
parameter H_SYNC = 16'd128;   
parameter H_BP = 16'd88;      
parameter V_ACTIVE = 16'd600; 
parameter V_FP  = 16'd1;     
parameter V_SYNC  = 16'd4;    
parameter V_BP  = 16'd23;    
parameter HS_POL = 'b1;
parameter VS_POL = 'b1;
`endif

//1024x768 65Mhz
`ifdef  VIDEO_1024_768
parameter H_ACTIVE = 16'd1024;
parameter H_FP = 16'd24;      
parameter H_SYNC = 16'd136;   
parameter H_BP = 16'd160; 
    
parameter V_ACTIVE = 16'd768; 
parameter V_FP  = 16'd3;      
parameter V_SYNC  = 16'd6;    
parameter V_BP  = 16'd29;     
parameter HS_POL = 'b0;
parameter VS_POL = 'b0;
`endif

//1920x1080 148.5Mhz
`ifdef  VIDEO_1920_1080
parameter H_ACTIVE = 16'd1920;
parameter H_FP = 16'd88;
parameter H_SYNC = 16'd44;
parameter H_BP = 16'd148; 
parameter V_ACTIVE = 16'd1080;
parameter V_FP  = 16'd4;
parameter V_SYNC  = 16'd5;
parameter V_BP  = 16'd36;
parameter HS_POL = 'b1;
parameter VS_POL = 'b1;
`endif

parameter H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;//horizontal total time (pixels)
parameter V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;//vertical total time (lines)

reg[11:0] h_cnt;                 //horizontal counter
reg[11:0] v_cnt;                 //vertical counter

reg h_active;                    //horizontal video active
reg v_active;                    //vertical video active
assign rgb_de = h_active & v_active;

always@(posedge rgb_clk)begin 
//显示计数
	if(h_cnt >= H_FP + H_SYNC + H_BP)
		rgb_x <= h_cnt - (H_FP[11:0] + H_SYNC[11:0] + H_BP[11:0]);
	else
		rgb_x <= rgb_x;
	if(v_cnt >= V_FP + V_SYNC + V_BP)
		rgb_y <= v_cnt - (V_FP[11:0] + V_SYNC[11:0] + V_BP[11:0]);
	else
		rgb_y <= rgb_y;
end

always@(posedge rgb_clk ,negedge rst_n)begin 
//列计数
	if(rst_n == 'b0)
		h_cnt <= 12'd0;
	else if(h_cnt == H_TOTAL - 1)//horizontal counter maximum value
		h_cnt <= 12'd0;
	else
		h_cnt <= h_cnt + 12'd1;
//行计数
	if(rst_n == 'b0)
		v_cnt <= 12'd0;
	else if(h_cnt == H_FP  - 1)//horizontal sync time
		if(v_cnt == V_TOTAL - 1)//vertical counter maximum value
			v_cnt <= 12'd0;
		else
			v_cnt <= v_cnt + 12'd1;
	else
		v_cnt <= v_cnt;
//HS生成
	if(rst_n == 'b0)
		rgb_hs <= 'b0;
	else if(h_cnt == H_FP - 1)//horizontal sync begin
		rgb_hs <= HS_POL;
	else if(h_cnt == H_FP + H_SYNC - 1)//horizontal sync end
		rgb_hs <= ~rgb_hs;
	else
		rgb_hs <= rgb_hs;
//列有效
	if(rst_n == 'b0)
		h_active <= 'b0;
	else if(h_cnt == H_FP + H_SYNC + H_BP - 1)//horizontal active begin
		h_active <= 'b1;
	else if(h_cnt == H_TOTAL - 1)//horizontal active end
		h_active <= 'b0;
	else
		h_active <= h_active;
//VS生成
	if(rst_n == 'b0)
		rgb_vs <= 'd0;
	else if((v_cnt == V_FP - 1) && (h_cnt == H_FP - 1))//vertical sync begin
		rgb_vs <= VS_POL;
	else if((v_cnt == V_FP + V_SYNC - 1) && (h_cnt == H_FP - 1))//vertical sync end
		rgb_vs <= ~rgb_vs;  
	else
		rgb_vs <= rgb_vs;
//行有效
	if(rst_n == 'b0)
		v_active <= 'd0;
	else if((v_cnt == V_FP + V_SYNC + V_BP - 1) && (h_cnt == H_FP - 1))//vertical active begin
		v_active <= 'b1;
	else if((v_cnt == V_TOTAL - 1) && (h_cnt == H_FP - 1)) //vertical active end
		v_active <= 'b0;   
	else
		v_active <= v_active;
end
endmodule 