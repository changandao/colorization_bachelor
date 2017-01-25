clear;
img = '../dataset/i/i';
path=strcat(img,'g.bmp');
out_name = strcat(img,'new_s.bmp');
gI=double(imread(path))/255;
n = size(gI,1);
m = size(gI,2);

k = 100;%number of superpixels
ks = num2str(k);
supdir=strcat('../SLIC/superpixels',ks,'/');% the superpixel label file path
imnames=dir([supdir '*.bmp']);
spname=[supdir imnames(5).name(1:end-9)  '.dat'];
superpixels=ReadDAT([n,m],spname); 
spnum=max(superpixels(:));

step = 1/k;
showI = zeros(n,m);
for i = 1:spnum
    J = (superpixels==i);
    showI=showI+J*i*step;
end
figure,imshow(showI);
imwrite(showI,out_name);

