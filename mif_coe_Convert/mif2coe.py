
import re
import glob
import os

#0-寻找mif文件,未找到输出 未找到mif文件
for file in glob.glob("*.mif"):
    mif = open(file, "r", encoding="utf-8")
    print("找到mif文件")
    break
else:
	print("未找到mif文件")
	os.system("pause")
	exit()
    
coe = open(r"BigPig.coe","w",encoding="utf-8")

#1-寻找表头 进制数据
coe.write("memory_initialization_radix = ")

for i in range(30): #在前30行内寻找进制数据
	mif_line = mif.readline()
	print(mif_line)
	if re.search( "DATA_RADIX", mif_line) or re.search( "data_radix", mif_line) :
		if re.search( "UNS", mif_line) or re.search( "uns", mif_line) :
			coe.write("10;\n")
			break
		elif re.search( "HEX", mif_line) or re.search( "hex", mif_line) :
			coe.write("16;\n")
			break
		elif re.search( "OCT", mif_line) or re.search( "oct", mif_line) :
			coe.write("8;\n")
			break
		elif re.search( "BIN", mif_line) or re.search( "bin", mif_line) :
			coe.write("2;\n")
			break
		else: #输出 未找到DATA进制匹配
			print("未找到DATA进制匹配")
			mif.close()
			coe.close()
			os.system("pause")
			break

#2-截取mif数据
coe.write("memory_initialization_vector =\n")
for i in range(30): #寻找起点
	mif_line = mif.readline()
	if re.search( "BEGIN", mif_line) or re.search( "begin", mif_line) :
		break

mif_line = mif.readline()
while mif_line:
    colon_index = mif_line.find(":")
    semicolon_index = mif_line.find(";")
    if colon_index != -1 and semicolon_index != -1:
        value = mif_line[colon_index+1:semicolon_index].strip()
        coe.write(value)
        coe.write("\n")
    elif re.search( "END", mif_line) or re.search( "end", mif_line) :
        break
    mif_line = mif.readline()


#3-写入分号回车 结束
coe.write(";\n")

print("转换完成")
mif.close()
coe.close()
