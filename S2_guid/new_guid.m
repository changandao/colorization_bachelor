clear
imgRoot = '../dataset/newdata/';%原始文件存放目录
imgOrigin = '../dataset/graynewdata/';%测试文件存放目录
imgDest = '../dataset/sunscribble/';%产生的scribble存放目录
imnames=dir([imgRoot '*' '.bmp']);

for ii = 1:length(imnames)
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-4)]; 
    img = imname;
    k = 500;
    ks= num2str(k);
    supdir =strcat('../SLIC/superpixels',ks,'/');% the superpixel label file path
    spname=[supdir img(24:end) '.dat'];
    superpixels=ReadDAT([256,320],spname);
    spnum=max(superpixels(:));
    
areaall;
edged;%分割边缘
seg;%基于图论的区域分割
ins;%产生cscribble

end