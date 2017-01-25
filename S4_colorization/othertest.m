clear
addpath(genpath(pwd));

imgRoot = '../dataset/othertest/';
imgOrigin = '../dataset/demo/testimg/';
imgMid = '../dataset/sunscribble/';
imgDest = '../dataset/othertest';
imnames=dir([imgRoot '*' '.bmp']);

for ii = 1:4%length(imnames)
   
    disp(ii);
    imname=[imgRoot imnames(ii).name(1:end-4)]; 
    img = imname;
    c_name=strcat(img,'.bmp');
    cimg = imread(c_name);
    gray = rgb2gray(cimg);
    out_name = strcat(img,'g.bmp');
    imwrite(gray,out_name);
end