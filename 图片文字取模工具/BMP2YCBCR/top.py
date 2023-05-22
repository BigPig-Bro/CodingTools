import os
import cv2

# 获取当前工作目录
current_dir = os.getcwd()

# 获取当前目录下所有的 BMP 文件
bmp_files = [file for file in os.listdir(current_dir) if file.endswith('.bmp')]

# 遍历 BMP 文件并转化为 YCBCR 三个通道
for bmp_file in bmp_files:
    # 读取 BMP 文件
    img = cv2.imread(bmp_file)

    # 将图像转换为 YCBCR 颜色空间
    img_ycbcr = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)

    # 分离 YCBCR 三个通道
    y, cb, cr = cv2.split(img_ycbcr)

    # 保存 Y、CB、CR 三个通道
    cv2.imwrite('{}_Y.bmp'.format(bmp_file[:-4]), y)
    cv2.imwrite('{}_CB.bmp'.format(bmp_file[:-4]), cb)
    cv2.imwrite('{}_CR.bmp'.format(bmp_file[:-4]), cr)