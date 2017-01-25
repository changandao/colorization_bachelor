clear
addpath(genpath(pwd));

imgRoot = '../dataset/origin/';
imgOrigin = '../dataset/grayorigin/';
imgDest = '../dataset/originresult/';
imnames=dir([imgRoot '*' '.bmp']);
psnrlist= [];

for ii = 1:10%length(imnames)
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-4)]; 
    img = imname;
    oriname = strcat(img, 'r.bmp');
    myname_slic = strcat(imgDest,img(23:end) ,'_slic.bmp');
    
    oriimg = double(imread(oriname));
    myimg_slci = double(imread(myname_slic));
    %ssimval =ssim(myimg_slci,oriimg);
    [FSIM,FSIMC] = FeatureSIM(oriimg,myimg_slci);
    FSIMC
end