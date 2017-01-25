clear
imgRoot = './colorimage/';
imgTest='./test/';
imnames=dir([imgRoot '*' 'jpg']);
for ii = 1:length(imnames)
    disp(ii);
    is = num2str(ii);
    imname=[imgRoot imnames(ii).name]; 
    img = imread(imname);
    %imggray = rgb2gray(img);
    img2 = imResample(img,[256,256]);%后面一个参数是生成图片的尺寸大小
    img_flip = flip(img2,2);%将图片左右翻转
    outname = [imgTest 'new_' is '.bmp'];
    imwrite(img_flip,outname);
end