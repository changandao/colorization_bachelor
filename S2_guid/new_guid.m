clear
imgRoot = '../dataset/newdata/';%ԭʼ�ļ����Ŀ¼
imgOrigin = '../dataset/graynewdata/';%�����ļ����Ŀ¼
imgDest = '../dataset/sunscribble/';%������scribble���Ŀ¼
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
edged;%�ָ��Ե
seg;%����ͼ�۵�����ָ�
ins;%����cscribble

end