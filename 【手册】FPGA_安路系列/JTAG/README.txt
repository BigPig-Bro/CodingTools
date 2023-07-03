1、按照schematic目录下的原理图焊接器件,IC3使用STM32/GD32均可。

2、使用STVP/ST-FLASH从SWD口刷入位于firmware目录下的固件，或断接BOOT0到3.3V，使用FlyMCU/STM32FLASH从串口（位于JTAG口处）刷入固件。

3、在Anlogic官网www.anlogic.com申请TD授权，即可开发FPGA/CPLD器件。

4、固件更新地址在https://github.com/AnlogicInfo/anlogic-usbjtag/