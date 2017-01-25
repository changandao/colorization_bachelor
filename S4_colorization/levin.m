clc
clear

img = 'dataset/k/k';
g_name=strcat(img,'g.bmp');
c_name=strcat(img,'.bmp');
l_name=strcat(img,'test_l.bmp');
out_name=strcat(img,'res_new.bmp');

%set solver=1 to use a multi-grid solver 
%and solver=2 to use an exact matlab "\" solver
solver=2; 
%{
gI=double(imread(g_name))/255;
cI=double(imread(c_name))/255;
gIM = cat(3, gI, gI, gI);
cIM = cI; 

%{

if ismatrix(gI)
    gIM = cat(3, gI, gI, gI);
elseif ismatrix(cI)
    cIM = cat(3, cI, cI, cI);   
end
%}

colorIm=(sum(abs(gIM-cIM),3)>0.0001);
colorIm=double(colorIm);
cI(:,:,1)=cI(:,:,1).*colorIm;
cI(:,:,2)=cI(:,:,2).*colorIm;
cI(:,:,3)=cI(:,:,3).*colorIm;

sgI=rgb2ntsc(gIM);
scI=rgb2ntsc(cIM);
   
ntscIm(:,:,1)=sgI(:,:,1);
ntscIm(:,:,2)=scI(:,:,2);
ntscIm(:,:,3)=scI(:,:,3);



%}

lI=double(imread(l_name))/255;
gI=double(imread(g_name))/255;
cI=double(imread(c_name))/255;

colorIm=lI;%(sum(abs(gI-cI),3)>0.01);
colorIm=double(colorIm);
cI(:,:,1)=cI(:,:,1).*colorIm;
cI(:,:,2)=cI(:,:,2).*colorIm;
cI(:,:,3)=cI(:,:,3).*colorIm;
sgI=gI;%rgb2ntsc(gI)
scI=rgb2ntsc(cI);
[height,width,depth]=size(gI);
ntscIm=zeros( height,width,3);  
ntscIm(:,:,1)=gI;%sgI(:,:,1);
ntscIm(:,:,2)=scI(:,:,2);
ntscIm(:,:,3)=scI(:,:,3);



max_d=floor(log(min(size(ntscIm,1),size(ntscIm,2)))/log(2)-2);
iu=floor(size(ntscIm,1)/(2^(max_d-1)))*(2^(max_d-1));
ju=floor(size(ntscIm,2)/(2^(max_d-1)))*(2^(max_d-1));
id=1; jd=1;
colorIm=colorIm(id:iu,jd:ju,:);
ntscIm=ntscIm(id:iu,jd:ju,:);

time = 0;
tic();
if (solver==1)
  nI=getVolColor(colorIm,ntscIm,[],[],[],[],5,1);
  nI=ntsc2rgb(nI);
  
elseif (solver == 2)
    nI=getColorExact(colorIm,ntscIm);
else
    nI=feat_getColorExact(colorIm,ntscIm,img);
end
time = time+toc();

figure, imshow(nI)

imwrite(nI,out_name)
   


 
%Reminder: mex cmd
%mex -O getVolColor.cpp fmg.cpp mg.cpp  tensor2d.cpp  tensor3d.cpp
