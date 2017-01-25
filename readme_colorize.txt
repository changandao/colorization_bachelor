colorization着色算法
步骤：
###### S1.对测试图像进行SLIC超像素分割 ########
输入图像，经过一系列预处理之后生成标注的超像素分割。不同的superpixel用不同的数字来表示
具体的请参照S1_SLIC_Matlab里的readme说明

###### S2.自动生成scribble ################
输入灰度图像，自动生成scribble
new_guid.m 主文件
areaall 预切割图像
edged 提取图像边缘
seg 基于图论的区域分割
ins 产生scribble区域

###### S3.利用VGG提取图像特征 #############
generatecp.m首先对图像进行预处理，将灰度图像和scirbble二值图相结合，得到带有scribble的灰度图像
getfeature.m再提取原始灰度图像和带有scribble灰度图像的VGG的5层特征

###### S4.自动色彩蔓延 ############
在S4_colorization文件夹里，存在多种色彩蔓延方法
gettestdata.m 给图像改名，并在另一个新的文件夹里生成
levin.m **
solver=2使用matlab中\的方法进行色彩蔓延，主要基于levin灰度特征蔓延
solver=3使用matlab中\的方法进行色彩蔓延，主要基于VGG提取的特征蔓延
main_trytorun.m 失败的使用SLIC限制进行色彩蔓延
SLIC_colorization.m 使用SLIC限制进行色彩蔓延 **
colorization.m 对多张图片不使用SCIC限制，但是采用改进的scribble生成算法进行色彩蔓延 **
single_colorization.m对单张图片不使用SCIC限制，但是采用改进的scribble生成算法进行色彩蔓延
demo.m 生成使用SLIC进行限制色彩蔓延的中间结果，比如在100，200，300，400，500时的中间染色结果 **
others文件夹 SLIC调用工具
其中带有 **的文件表示有注释，其余的文件因为与这些相似，顾不再多余注释

###### S5.对结果进行分析 ######
res_evaluate.m 彩色化的PSNR分析，对RGB三个通道的PSNR取平均
BATCHres_evaluate.m 多张图片的彩色化的PSNR分析，对RGB三个通道的PSNR取平均
ssimres.m 图像的ssim指标分析，仅测试，并未加入到论文中的结果分析中。



imgRoot = '../dataset/newdata/‘;%原始图像文件总数
imgOrigin = '../dataset/graynewdata/‘;%测试图像存放文件夹
imgDest = '../dataset/sunscribble/‘;%图像的中间参数：比如scribble， VGG特征，
imnames=dir([imgRoot '*' '.bmp’]);扫描原始文件文件名