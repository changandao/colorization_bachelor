clear
addpath(genpath(pwd));

imgRoot = '../dataset/SUNDATABASE/';
imgOrigin = '../dataset/graysundatabase/';
imgMid = '../dataset/sunscribble/';
imgDest = '../dataset/demo/';
imnames=dir([imgRoot '*' 'r.bmp']);

for ii = 1:length(imnames)
   
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-5)]; 
    img = imname;
    
g_name=strcat(img,'g.bmp');
c_name=strcat(img,'r.bmp');
cl_name=strcat(imgMid,'scribble/',img(24:end),'p.bmp');
out_name=strcat(imgDest,img(24:end),'_slic.bmp');
e_name=strcat(img,'et.bmp');


edgeIm=double(imread(e_name));

edgeIm=round(edgeIm/26);
[height,width]=size(edgeIm);
time = 0;
tic();
eIm=zeros(height,width);
for ecnt=1:10
    tedge=(edgeIm==ecnt);
    if(ecnt==10)
        tedge=bwmorph(tedge,'close',1);
    end;
    eIm=eIm+tedge*ecnt;
end;
edgeIm=eIm;%得到边缘图像

gI=double(imread(g_name))/255;
cI=double(imread(c_name))/255;
%%==== 给scribble上色 ====%%
colorIm=double(imread(cl_name));
if(size(gI,3)==3)
    sgI=rgb2ntsc(gI);
else
    sgI=gI;
end;
scI=rgb2ntsc(cI);
ntscIm=scI;
ntscIm(:,:,1)=sgI(:,:,1);
ntscIm(:,:,2)=scI(:,:,2).*colorIm;
ntscIm(:,:,3)=scI(:,:,3).*colorIm;
%%========================%%

%%========图像预切割=======%%
max_d=floor(log(min(size(ntscIm,1),size(ntscIm,2)))/log(2)-2);
iu=floor(size(ntscIm,1)/(2^(max_d-1)))*(2^(max_d-1));
ju=floor(size(ntscIm,2)/(2^(max_d-1)))*(2^(max_d-1));
id=1; jd=1;
colorIm=colorIm(id:iu,jd:ju,:);
ntscIm=ntscIm(id:iu,jd:ju,:);
%%=====%%

lblInds=find(colorIm);

gfeatname=strcat(imgMid,'feature/',img(24:end),'_gfeatdata.mat');
cfeatname=strcat(imgMid,'feature/',img(24:end),'_cfeatdata.mat');
gfeat = load(gfeatname);
cfeat = load(cfeatname);

n=size(ntscIm,1); 
m=size(ntscIm,2);


%%========superpixels========%%
k = 500;%number of superpixels
k = num2str(k);
supdir=strcat('../SLIC/superpixels',k,'/');% the superpixel label file path
imnamessp=dir([supdir '*.bmp']);
%spname=[supdir imnamessp(ii).name(1:end-9)  '.dat'];
spname=[supdir img(24:end) '.dat'];
superpixels=ReadDAT([n,m],spname); 
spnum=max(superpixels(:));
%%===========================%%

imgSize=n*m;

nI=zeros(n,m,3);
nI(:,:,1)=ntscIm(:,:,1);

A = getsparse_revise(colorIm,ntscIm,edgeIm,cfeat,gfeat);%得到权重矩阵
b=zeros(size(A,1),1);


%%% 在每个superpixel里单独进行色彩蔓延
for sp = 1:spnum
    
    flag = superpixels==sp;
    mask = reshape(flag,imgSize,1);
for t=2:3
    curIm=ntscIm(:,:,t);
    b(lblInds)=curIm(lblInds);
    b = b.*mask;
    new_vals=A\b;   
    nI(:,:,t)=nI(:,:,t)+reshape(new_vals,n,m,1);    
end
    
end;

time = time + toc();
nI=ntsc2rgb(nI);
figure,imshow(nI);
imwrite(nI,out_name);
time
end