#ifndef _OV7725_7670_H
#define _OV7725_7670_H

#include "sccb.h"
#include <stdint.h>

#define OV7725 1
#define OV7670 2
#define OV5640 3
#define OV5642 4
#define UNKNOWN 255

/////////////////////////////////////////

unsigned char OV7xxx_Init(void);

#endif

