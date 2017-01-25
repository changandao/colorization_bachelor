clear
addpath('./others/');
img = 'dataset/i/i';
g_name=strcat(img,'g.bmp');
c_name=strcat(img,'o.bmp');
cl_name=strcat(img,'l.bmp');
out_name=strcat(img,'_bad.bmp');
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

colorIm=double(imread(cl_name))/255;
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

gfeatname=strcat(img,'_gfeatdata.mat');
cfeatname=strcat(img,'_cfeatdata.mat');
gfeat = load(gfeatname);
cfeat = load(cfeatname);

n=size(ntscIm,1); 
m=size(ntscIm,2);


%%========superpixels========%%
k = 500;%number of superpixels
k = num2str(k);
supdir=strcat('./SLIC/superpixels',k,'/');% the superpixel label file path
imnames=dir([supdir '*.bmp']);
spname=[supdir imnames(5).name(1:end-9)  '.dat'];
superpixels=ReadDAT([n,m],spname); 
spnum=max(superpixels(:));
%%===========================%%

imgSize=n*m;

nI=zeros(n,m,3);
nI(:,:,1)=ntscIm(:,:,1);


A = getsparse(superpixels,colorIm,ntscIm,edgeIm,cfeat,gfeat);
b=zeros(size(A,1),1);

for t=2:3
    curIm=ntscIm(:,:,t);
    b(lblInds)=curIm(lblInds);
    new_vals=A\b;   
    nI(:,:,t)=reshape(new_vals,n,m,1);    
end

time = time + toc();
time
snI=nI;
nI=ntsc2rgb(nI);
imshow(nI);
imwrite(nI,out_name);
