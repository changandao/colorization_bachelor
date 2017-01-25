clear
addpath(genpath(pwd));

imgRoot = '../dataset/demo/testimg/';
imgOrigin = '../dataset/demo/testimg/';
imgMid = '../dataset/sunscribble/';
imgDest = '../dataset/demo/testresult';
imnames=dir([imgRoot '*' 'r.bmp']);

for ii = 4:4%length(imnames)
   
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-5)]; 
    img = imname;
    
g_name=strcat(img,'g.bmp');
c_name=strcat(img,'r.bmp');
cl_name=strcat(imgMid,'scribble/',img(25:end),'p.bmp');
out_name1=strcat(imgDest,img(25:end),'_100.bmp');
out_name2=strcat(imgDest,img(25:end),'_200.bmp');
out_name3=strcat(imgDest,img(25:end),'_300.bmp');
out_name4=strcat(imgDest,img(25:end),'_400.bmp');
out_name5 =strcat(imgDest,img(25:end),'_500.bmp');
e_name=strcat(img,'et.bmp');


edgeIm=double(imread(e_name));

edgeIm=round(edgeIm/26);
[height,width]=size(edgeIm);
%edgeIm=bwmorph(edgeIm,'close',1);
time = 0;
tic();
eIm=zeros(height,width);
for ecnt=1:10
    tedge=(edgeIm==ecnt);
    if(ecnt==10)
        tedge=bwmorph(tedge,'close',1);
    end;
    %imshow(tedge);
    eIm=eIm+tedge*ecnt;
end;
edgeIm=eIm;

gI=double(imread(g_name))/255;
cI=double(imread(c_name))/255;

colorIm=double(imread(cl_name));
%se90 = strel('line', 2, 90);
%se0 = strel('line', 2, 0);
%colorIm = imdilate(colorIm, [se90 se0]);
%colorIm=bwmorph(colorIm,'dilate',1);
%imshow(colorIm);
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

max_d=floor(log(min(size(ntscIm,1),size(ntscIm,2)))/log(2)-2);
iu=floor(size(ntscIm,1)/(2^(max_d-1)))*(2^(max_d-1));
ju=floor(size(ntscIm,2)/(2^(max_d-1)))*(2^(max_d-1));
id=1; jd=1;
colorIm=colorIm(id:iu,jd:ju,:);
ntscIm=ntscIm(id:iu,jd:ju,:);

lblInds=find(colorIm);

gfeatname=strcat(imgMid,'feature/',img(25:end),'_gfeatdata.mat');
cfeatname=strcat(imgMid,'feature/',img(25:end),'_cfeatdata.mat');
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
spname=[supdir img(25:end) '.dat'];
superpixels=ReadDAT([n,m],spname); 
spnum=max(superpixels(:));
%%===========================%%

imgSize=n*m;

nI=zeros(n,m,3);
nI(:,:,1)=ntscIm(:,:,1);

A = getsparse_revise(colorIm,ntscIm,edgeIm,cfeat,gfeat);
b=zeros(size(A,1),1);

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
%%=====得到中间结果=====%%
    if sp == 100
        mid100= nI;
    end
    if sp == 200
        mid200= nI;
    end
    if sp == 300
        mid300= nI;
    end
    if sp == 400
        mid400= nI;
    end
    if sp == spnum
        mid500= nI;
    end
    %%=========%%
end;

time = time + toc();
smid100 = ntsc2rgb(mid100);
smid200 = ntsc2rgb(mid200);
smid300 = ntsc2rgb(mid300);
smid400 = ntsc2rgb(mid400);
smid500 = ntsc2rgb(mid500);
nI=ntsc2rgb(nI);

figure,imshow(nI);
imwrite(smid100,out_name1);
imwrite(smid200,out_name2);
imwrite(smid300,out_name3);
imwrite(smid400,out_name4);
imwrite(smid500,out_name5);

time
end