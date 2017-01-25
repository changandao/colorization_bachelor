clear
clear
imgRoot = '../dataset/newdata/';
imgOrigin = '../dataset/graynewdata/';
imnames=dir([imgRoot '*' '.bmp']);
for ii = 1:length(imnames)
    disp(ii);
    imname=[imgRoot imnames(ii).name]; 
    imgcolor = imread(imname);
    oriimg = [imgOrigin imnames(ii).name(1:end-4) 'r.bmp'];
    imwrite(imgcolor,oriimg);
    imggray = rgb2gray(imgcolor);
    grayimg = [imgOrigin imnames(ii).name(1:end-4) 'g.bmp'];    
    imwrite(imggray,grayimg);
    
end