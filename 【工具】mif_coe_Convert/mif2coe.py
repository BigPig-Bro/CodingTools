import re
import os
import fnmatch
import sys

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
                if re.search( "data_radix", mif_line.lower()) :
                    if re.search( "uns", mif_line) :
                        coe.write("10;\n")
                        break
                    elif re.search( "hex", mif_line.lower()) :
                        coe.write("16;\n")
                        break
                    elif  re.search( "oct", mif_line.lower()) :
                        coe.write("8;\n")
                        break
                    elif re.search( "bin", mif_line.lower()) :
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
                if re.search( "begin", mif_line.lower()) :
                    break
                
            mif_line = mif.readline()
            while mif_line:
                colon_index = mif_line.find(":")
                semicolon_index = mif_line.find(";")
                if colon_index != -1 and semicolon_index != -1:
                    value = mif_line[colon_index+1:semicolon_index].strip()
                    coe.write(value)
                    coe.write("\n")
                elif re.search( "end", mif_line.lower()) :
                    break
                mif_line = mif.readline()


            #3-写入分号回车 结束
            coe.write(";\n")

            print("转换完成")
            mif.close()
            coe.close()
            sys.exit()
        break
    elif fnmatch.fnmatchcase(file, "*.coe"):
            # 处理找到的.coe文件
            print("找到.coe文件:", file)
            mif = open("BigPig.mif","w",encoding="utf-8")
            with open(file, "r", encoding="utf-8") as coe:
                #1- 找到 数据进制 并统计数据个数
                coe_line = coe.readline()
                while coe_line: #找文件头
                    if fnmatch.fnmatchcase(coe_line.lower(), "memory_initialization_radix*"):
                        data_radix = int(coe_line.split("=")[-1].strip().replace(";", ""))
                        if data_radix == 2 :
                            data_wid =  'BIN' 
                        elif data_radix == 8 :
                            data_wid =  'OCT'
                        elif data_radix == 10 :
                            data_wid =  'DEC'
                        elif data_radix == 16 :
                            data_wid =  'HEX'
                        else :
                            print("数据进制错误")
                            # 暂停程序以便查看提示信息
                            os.system("pause")
                            # 退出程序
                            sys.exit()  
                        coe_line = coe.readline()
                    elif fnmatch.fnmatchcase(coe_line.lower(), "memory_initialization_vector*"):
                        coe_line = coe.readline()
                        break
                    else :
                        coe_line = coe.readline()
                else:
                    # 未找到.coe文件
                    print("未找到coe文件头")
                    # 暂停程序以便查看提示信息
                    os.system("pause")
                    # 退出程序
                    sys.exit()  

                data_list=[]
                data_cnt = 0
                while coe_line:  # 循环读取一行中的数据直到该行结束
                    # 截取逗号前数据字符串
                    data_str = coe_line.split(",")[0].strip()
                    while data_str != "":
                        data_cnt += 1
                        data_list.append(data_str)
                        # 在本行内继续截取下一个匹配数据
                        coe_line = coe_line[len(data_str) + 1:].strip()
                        data_str = coe_line.split(",")[0].strip()
                    else:
                        # 读取下一行
                        coe_line = coe.readline()

                #2- 写入mif文件头
                mif.write("DEPTH = "+str(len(data_list))+";"+"\n")
                mif.write("WIDTH = "+str(data_radix)+";"+"\n")
                mif.write("ADDRESS_RADIX=UNS;\n")
                mif.write("DATA_RADIX="+str(data_wid)+";"+"\n")
                mif.write("CONTENT\n BEGIN \n")

                #3- 写入数据
                data_cnt = 0
                #读取data list 按照 cnt : XX ;写入
                for data in data_list:
                    if data == data_list[-1]:
                        mif.write(str(data_cnt) + " : " + data + "\n")
                    else:
                        mif.write(str(data_cnt) + " : " + data + ";\n")
                    data_cnt += 1

                #4- 写入分号回车 结束
                mif.write("END;\n")

                print("转换完成")
                mif.close()
                coe.close()
                sys.exit()
else:
    # 未找到.mif文件
    print("未找到.mif/coe文件")
    # 暂停程序以便查看提示信息
    os.system("pause")
    # 退出程序
    sys.exit()