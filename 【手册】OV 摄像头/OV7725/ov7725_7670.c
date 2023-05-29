#include <stdint.h>
#include "ov5642cfg.h"
#include "ov7725_7670.h"
#include "sccb.h"
#include "unistd.h"

uint8_t OV7xxx_Init(void)
{

	uint16_t VER;
	uint8_t PID;
	uint16_t CMOS_ID;
	uint16_t i=0;
	uint8_t CMOS_MODEL;
	SCCB_Init(40000, 0);        		//初始化SCCB 的IO
// 	if(SCCB_WR_Reg(0x12,0x80))return 1;	//复位SCCB
//	usleep(50000);
//	//读取产品型号
	VER=SCCB_RD_Reg(0x30,0x0a);
	PID=SCCB_RD_Reg(0x30,0x0b);
	CMOS_ID = (VER<<8)|PID;
	if(CMOS_ID == 0x5642)
	{
		CMOS_MODEL = OV5642;
		//初始化序列
		for(i=0;i<sizeof(ov5642_init_reg_tbl)/sizeof(ov5642_init_reg_tbl[0]);i++)
		{
			SCCB_WR_Reg(ov5642_init_reg_tbl[i][0],ov5642_init_reg_tbl[i][1],ov5642_init_reg_tbl[i][2]);
			usleep(2000);
		}

	}
	else
		CMOS_MODEL = UNKNOWN;

   	return CMOS_MODEL; 	//ok
}
