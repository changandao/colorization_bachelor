步骤：
1.将需要分割的图片放入corlorimage文件夹里
2.运行preprocess对图片进行重新采样以及左右翻转的预处理
3.最后运行demo对图片进行SLIC超像素分割
4.结果存放在superpixel‘k’的文件夹里，k是分割的超像素数量
Usage:
>put the test images into file '\test'
>run 'demo.m'
******************************************************************************************************************
Note: We observe that some images on the MSRA dataset are surrounded with artificial frames,
which will invalidate the used boundary prior. Thus, we run a pre-processing to remove such obvious frames.

Procedures:
1. compute a binary edge map of the image using the canny method.
2. if a rectangle is detected in a band of 30 pixels in width along the four sides of the edge map (i.e. we assume that the frame is not wider than 30 pixels), we will cut the aera outside the rectangle from the image.
           
The file 'removeframe.m' is the pre-processing code.

******************************************************************************************************************
We use the SLIC superpixel software to generate superpixels (http://ivrg.epfl.ch/supplementary_material/RK_SLICSuperpixels/index.html)
and some graph functions in the Graph Analysis Toolbox (http://eslab.bu.edu/software/graphanalysis/).

Note: The running time reported in our paper does not include the time of the pre-processing and the running time of the superpixel generation is computed by using the SLIC Windows GUI based executable.