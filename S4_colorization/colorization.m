clear
addpath(genpath(pwd));

imgRoot = '../dataset/newdata/';
imgOrigin = '../dataset/graynewdata/';
imgMid = '../dataset/sunscribble/';
imgDest = '../dataset/newdataresult/';
imnames=dir([imgRoot '*' '.bmp']);

for ii = 1:length(imnames)
    
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-4)]; 
    img = imname;
g_name=strcat(img,'g.bmp');
c_name=strcat(img,'r.bmp');
cl_name=strcat(imgMid,'scribble/',img(24:end),'newp.bmp');
out_name=strcat(imgDest,img(23:end),'nNEW.bmp');
e_name=strcat(img,'et.bmp');

%%=====得到边缘图像=======%%
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
    %imshow(tedge);
    eIm=eIm+tedge*ecnt;
end;
edgeIm=eIm;
%%=======================%%


%%=====给scribble上色====%%
gI=double(imread(g_name))/255;
cI=double(imread(c_name))/255;

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
%%=======================%%

%%========图像预切割=======%%
max_d=floor(log(min(size(ntscIm,1),size(ntscIm,2)))/log(2)-2);
iu=floor(size(ntscIm,1)/(2^(max_d-1)))*(2^(max_d-1));
ju=floor(size(ntscIm,2)/(2^(max_d-1)))*(2^(max_d-1));
id=1; jd=1;
colorIm=colorIm(id:iu,jd:ju,:);
ntscIm=ntscIm(id:iu,jd:ju,:);
%%========================%%

gfeatname=strcat(imgMid,'feature/',img(24:end),'_gfeatdata.mat');
cfeatname=strcat(imgMid,'feature/',img(24:end),'_cfeatdata.mat');
gfeat = load(gfeatname);
cfeat = load(cfeatname);

n=size(ntscIm,1); 
m=size(ntscIm,2);

imgSize=n*m;

nI=zeros(n,m,3);
nI(:,:,1)=ntscIm(:,:,1);

%%=======得到权重矩阵======%%
indsM=reshape([1:imgSize],n,m);
lblInds=find(colorIm);

wd=1; 

len=0;
consts_len=0;
col_inds=zeros(imgSize*(2*wd+1)^2,1);
row_inds=zeros(imgSize*(2*wd+1)^2,1);
vals=zeros(imgSize*(2*wd+1)^2,1);
gvals=zeros(1,(2*wd+1)^2);
fvals=zeros(1,(2*wd+1)^2);
evals=zeros(1,(2*wd+1)^2);
%se90 = strel('line', 2, 90);
%se0 = strel('line', 2, 0);
%colorIm = imdilate(colorIm, [se90 se0]);
%colorIm=bwmorph(colorIm,'dilate',1);
%t_feature=reshape(featureIm,width*height,featurelen);
for j=1:m
   for i=1:n
      consts_len=consts_len+1;
      
      if (~colorIm(i,j))
          tlen=0;
          for ti=max(1,i-wd):min(i+wd,n)
              for tj=max(1,j-wd):min(j+wd,m)
                  
                  if (ti~=i)|(tj~=j)
                      len=len+1;
                      tlen=tlen+1;
                      row_inds(len)= indsM(i,j);
                      col_inds(len)=indsM(ti,tj);
                  end;
              end;
          end;
          ttlen=0;
          
          gcur=0;
          edgecur=0;
          xlen=min(i+wd,n)-max(1,i-wd);
          ylen=min(j+wd,m)-max(1,j-wd);
          for ii=max(1,i-wd):min(i+wd,n)
              for jj=max(1,j-wd):min(j+wd,m)
                  if (ii~=i)|(jj~=j)
                      ttlen=ttlen+1;
                      featdif3 = 0;
                      featdif4 = 0;
                      featdif5 = 0;
                      
                      featdif1 = abs(cfeat.resize_cfeat1(ii,jj)-gfeat.resize_gfeat1(ii,jj));
                      featdif2 = abs(cfeat.resize_cfeat2(ii,jj)-gfeat.resize_gfeat2(ii,jj));
                      featdif3 = abs(cfeat.resize_cfeat3(ii,jj)-gfeat.resize_gfeat3(ii,jj));
                      featdif4 = abs(cfeat.resize_cfeat4(ii,jj)-gfeat.resize_gfeat4(ii,jj));
                      featdif5 = abs(cfeat.resize_cfeat5(ii,jj)-gfeat.resize_gfeat5(ii,jj));
                      ggfeat1=gfeat.resize_gfeat1(ii,jj);
                      ggfeat2=gfeat.resize_gfeat2(ii,jj);
                      ggfeat3=gfeat.resize_gfeat3(ii,jj);
                      ggfeat4=gfeat.resize_gfeat4(ii,jj);
                      ggfeat5=gfeat.resize_gfeat5(ii,jj);
                      ccfeat1=cfeat.resize_cfeat1(ii,jj);
                      ccfeat2=cfeat.resize_cfeat2(ii,jj);
                      ccfeat3=cfeat.resize_cfeat3(ii,jj);
                      ccfeat4=cfeat.resize_cfeat4(ii,jj);
                      ccfeat5=cfeat.resize_cfeat5(ii,jj);
                      ggfeat = (ggfeat5+ggfeat1+ggfeat4+ggfeat2)/4;
                      ccfeat = (ccfeat5+ccfeat1+ccfeat4+ccfeat2)/4;
                      %ggfeat = ggfeat5;
                      
                      %featdif =(featdif1+featdif2++featdif4+featdif5)/4;
                      fvals(ttlen) = ccfeat;%ggfeat;%featdif;
                      evals(ttlen)=double(edgeIm(ii,jj));
                      gvals(ttlen,1)=ntscIm(ii,jj,1);
                  else
                      ecur=double(edgeIm(i,j));
                      fcur = abs(cfeat.resize_cfeat1(i,j)-gfeat.resize_gfeat1(i,j));
                      gcur=ntscIm(i,j,1);
                  end;
              end
          end
          edge = evals';
          
          
          if(tlen==8)
              if(edge(2,1)>0 && edge(4,1)>0 && ecur==0 && edge(1,1)==0)
                  edge(1,1)=(edge(2,1)+edge(4,1))/2;
              end;
              if(edge(4,1)>0 && edge(7,1)>0 && ecur==0 && edge(6,1)==0)
                  edge(6,1)=(edge(4,1)+edge(7,1))/2;
              end;
              if(edge(2,1)>0 && edge(5,1)>0 && ecur==0 && edge(3,1)==0)
                  edge(3,1)=(edge(2,1)+edge(5,1))/2;
              end;
              if(edge(5,1)>0 && edge(7,1)>0 && ecur==0 && edge(8,1)==0)
                  edge(8,1)=(edge(5,1)+edge(7,1))/2;
              end;
          end;
          
          evals=edge';
          evals(1+tlen) = ecur;
          ec_var=mean((evals(1:tlen+1)-mean(evals(1:tlen+1))).^2);
          ecsig=ec_var*0.6;
          mgv=min((evals(1:tlen)-ecur).^2);
          if (ecsig<(-mgv/log(0.01)))
              ecsig=-mgv/log(0.01);
          end
          if (ecsig<0.000002)
              ecsig=0.000002;
          end
          
          evals(1:tlen)=exp(-(evals(1:tlen)-ecur).^2/ecsig*10);
          
          
          fvals(tlen+1)=fcur;
          fc_val=mean((fvals(1:tlen)-fcur).^2);
          fcsig=fc_val*0.6;
          
          mgv=min((fvals(1:tlen)-fcur).^2);
          if (fcsig<(-mgv/log(0.01)))
              fcsig=-mgv/log(0.01);
          end
          
          if (fcsig<0.000002)
              fcsig=0.000002;
          end
          fvals(1:tlen)=exp(-(fvals(1:tlen)-fcur).^2/fcsig);
          
          if(tlen==8)
              if(evals(1)<0.000001 && evals(2)<0.000001 && evals(3)<0.000001)
                  evals(1)=evals(1)+0.000001;
                  evals(2)=evals(2)+0.000001;
                  evals(3)=evals(3)+0.000001;
              end;
              if(evals(1)<0.000001 && evals(4)<0.000001 && evals(6)<0.000001)
                  evals(1)=evals(1)+0.000001;
                  evals(4)=evals(4)+0.000001;
                  evals(6)=evals(6)+0.000001;
              end;
              if(evals(3)<0.000001 && evals(5)<0.000001 && evals(8)<0.000001)
                  evals(3)=evals(3)+0.000001;
                  evals(5)=evals(5)+0.000001;
                  evals(8)=evals(8)+0.000001;
              end;
              if(evals(6)<0.000001 && evals(7)<0.000001 && evals(8)<0.000001)
                  evals(6)=evals(6)+0.000001;
                  evals(7)=evals(7)+0.000001;
                  evals(8)=evals(8)+0.000001;
              end;
          end;
          %wvals=fvals1.*e_vals.*g_vals;
          if(ecur>0)
              wvals=gvals;
          else
              %                         if(sum(isnan(fvals1)==1)>=1)
              %                             wvals=e_vals.*g_vals;
              %                         else
              wvals=fvals.*evals;%.*gvals;
              %                        end;
          end;
                    
%                
                    wvals(1:tlen)=wvals(1:tlen)/sum(wvals(1:tlen)); 
                    vals(len-tlen+1:len)=-wvals(1:tlen);
      end
        
      len=len+1;
      row_inds(len)= indsM(i,j);
      col_inds(len)=indsM(i,j);
      vals(len)=1; 

   end
end
  
vals=vals(1:len);
col_inds=col_inds(1:len);
row_inds=row_inds(1:len);

A=sparse(row_inds,col_inds,vals,consts_len,imgSize);
%%=======================%%

b=zeros(size(A,1),1);

    for t=2:3
        curIm=ntscIm(:,:,t);
        b(lblInds)=curIm(lblInds);
        new_vals=A\b;   
        nI(:,:,t)=reshape(new_vals,n,m,1);    
    end

%snI=nI;
snI=ntsc2rgb(nI);
time = time+toc();
time

figure, imshow(snI)

imwrite(snI,out_name)
end
