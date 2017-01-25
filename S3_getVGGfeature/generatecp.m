clear;
addpath(genpath(pwd));
imgRoot = '../dataset/newdata/';
imgOrigin = '../dataset/graynewdata/';
imgDest = '../dataset/sunscribble/';
imnames=dir([imgRoot '*' '.bmp']);
addpath(genpath(pwd));

for ii = 51:length(imnames)
    
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-4)]; 
    img = imname;
    
%img = 'dataset/f/f';
c_name=strcat(img,'r.bmp');
cl_name=strcat(imgDest,'scribble/',img(24:end),'newp.bmp');
out_name=strcat(img,'cp.bmp');

cI=double(imread(c_name))/255;
colorIm=double(imread(cl_name));

scI = rgb2ntsc(cI);
%scI(:,:,1)= scI(:,:,1).*colorIm;
scI(:,:,2)= scI(:,:,2).*colorIm;
scI(:,:,3)= scI(:,:,3).*colorIm;
cp = ntsc2rgb(scI);
imshow(cp)
imwrite(cp,out_name);

end