img = 'dataset/r/r';
name=strcat(img,'.bmp');
cI=double(imread(name))/255;
ct=rgb2ntsc(cI);
colorIm=(((ct(:,:,2)~=0)+(ct(:,:,3)~=0))~=0);
colorIm=double(colorIm);
path=strcat(img,'test_l.bmp');
imwrite(colorIm,path);