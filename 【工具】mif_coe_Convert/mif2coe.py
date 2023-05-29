import re
import os
import fnmatch

# 寻找.mif .coe文件
for file in os.listdir("."):
    if fnmatch.fnmatchcase(file, "*.mif"):
        # 打开.mif文件进行读取操作
        with open(file, "r", encoding="utf-8") as mif:
            # 处理找到的.mif文件
            print("找到.mif文件:", file)
            coe = open("BigPig.coe","w",encoding="utf-8")

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
        break
    elif fnmatch.fnmatchcase(file, "*.coe"):
            # 处理找到的.coe文件
            print("找到.coe文件:", file)
            mif = open("BigPig.mif","w",encoding="utf-8")
            with open(file, "r", encoding="utf-8") as coe:
                #1- 找到 数据进制 并统计数据个数
                coe_line = coe.readline()
                while coe_line:
                    if fnmatch.fnmatchcase(coe_line, "memory_initialization_radix"):
                        data_radix = int(coe_line.split("=")[-1].strip().replace(";", ""))
                    elif fnmatch.fnmatchcase(coe_line, "memory_initialization_vector"):
                        data_str = coe_line.split("=")[-1].strip().rstrip(";")
                        data_list = data_str.split(",")
                        data_num = len(data_list)
                    else :
                        coe_line = coe.readline()
                else:
                    # 未找到.mif文件
                    print("未找到coe文件头")
                    # 暂停程序以便查看提示信息
                    os.system("pause")
                    # 退出程序
                    exit()         
                        
                #2- 写入mif文件头
                mif.write("DEPTH = "+str(data_num)+"\n")
                mif.write("WIDTH = "+str(data_num)+"\n")

                #4- 写入分号回车 结束
                mif.write("END;\n")

                print("转换完成")
                mif.close()
                coe.close()
else:
    # 未找到.mif文件
    print("未找到.mif/coe文件")
    # 暂停程序以便查看提示信息
    os.system("pause")
    # 退出程序
    exit()