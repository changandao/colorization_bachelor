
g_name='ig.bmp';
c_name='i2.bmp';
out_name='ir.bmp';



%set solver=1 to use a multi-grid solver 
%and solver=2 to use an exact matlab "\" solver
solver=2; 
featurelen=9;
% gI=double(imread(g_name))/255;
% %gI=rgb2gray(gI);
% cI=double(imread(c_name))/255;
% ct=rgb2ntsc(cI);
% %colorIm=(((ct(:,:,2)~=0)+(ct(:,:,3)~=0))~=0);
% colorIm=(abs(ct(:,:,2))>0.1);
% colorIm=double(colorIm);

gI=double(imread(g_name))/255;
cI=double(imread(c_name))/255;
colorIm=(sum(abs(gI-cI),3)>0.01);
colorIm=double(colorIm);

% colorIm=imread('gc.jpg');
% colorIm=rgb2gray(colorIm);
% colorIm=double(colorIm>0);
imshow(colorIm);
sgI=rgb2ntsc(gI);
%sgI=gI;
scI=rgb2ntsc(cI);

ntscIm=scI;
ntscIm(:,:,1)=sgI(:,:,1);
ntscIm(:,:,2)=scI(:,:,2);
ntscIm(:,:,3)=scI(:,:,3);


max_d=floor(log(min(size(ntscIm,1),size(ntscIm,2)))/log(2)-2);
iu=floor(size(ntscIm,1)/(2^(max_d-1)))*(2^(max_d-1));
ju=floor(size(ntscIm,2)/(2^(max_d-1)))*(2^(max_d-1));
id=1; jd=1;
colorIm=colorIm(id:iu,jd:ju,:);
ntscIm=ntscIm(id:iu,jd:ju,:);
[height,width,depth]=size(ntscIm);
colordata=zeros(500,2);
colorcnt=1;

classIm=colorIm;
for i=1:height
    for j=1:width   
%             for ii=max(1,i-1):min(i+1,height)
%                for jj=max(1,j-1):min(j+1,width)
%                    featureIm(i,j,(ii-i+1)*3+jj-j+1+1)=ntscIm(ii,jj,1);
%                end;
%             end;      
            if(colorIm(i,j)==1)
                for k=1:colorcnt
                    if((ntscIm(i,j,2)-colordata(k,1))^2+(ntscIm(i,j,3)-colordata(k,2))^2<0.01)
                        classIm(i,j,1)=k;
                        break;
                    end;
                end;
                if(k==colorcnt)
                     colordata(k,1)=ntscIm(i,j,2);
                     colordata(k,2)=ntscIm(i,j,3);
                     colorcnt=colorcnt+1;
                     classIm(i,j,1)=colorcnt;
                end;
            end;
    end;
end;
[featureIm,featurelen]=featureExtract(ntscIm,1);
% fIm=featureIm;
% for cnt=1:9
%     featureIm(:,:,cnt)=featureIm(:,:,cnt)-mean(fIm,3);
% end;
lblInds=find(colorIm);
[nonzerocnt,line]=size(lblInds);
data=zeros(nonzerocnt,featurelen);
chunks=zeros(nonzerocnt,1);
t_feature=reshape(featureIm,width*height,featurelen);
data=t_feature(lblInds,:);
% lblInds2=find(t_feature);
chunks=classIm(lblInds);
ct=chunks';
% data2=data';
% datad=zeros(colorcnt*10,featurelen);
% chunkd=zeros(colorcnt*10,1);
% chunklen=1;
% for k=1:colorcnt 
%     t_chunk=(chunks==k);
%     t_lblInds=find(t_chunk);
%     for cnt=1:min(10,length(t_lblInds))
%        datad(chunklen,:)=t_feature(t_lblInds(int32(1+(length(t_lblInds)-1)*rand)),:); 
%        chunkd(chunklen)=k;
%        chunklen=chunklen+1;
%     end;
% end 
% datacur=datad(1:chunklen-1,:);
% chunkcur=chunkd(1:chunklen-1);
% datain=datacur';
% chunkin=chunkcur';
%[Tmx,Z]=LFDA(datain,chunkcur);

% [ Bmx, Tmx,newData] =RCA(data,ct);
% fIm=featureIm;
% for i=1:height
%     for j=1:width   
%         %featureIm(i,j,:)=featureIm(i,j,:)*Tmx;
%         featureIm(i,j,:)=reshape(featureIm(i,j,:),1,featurelen)*Tmx;
%         if(sum(featureIm(i,j,:))~=0)
%             featureIm(i,j,:)=featureIm(i,j,:)/sum(featureIm(i,j,:));
%         end;
%     end;
% end;

 %ntscIm(:,:,1)=mean(featureIm,3);
% for cnt=1:featurelen
%     featureIm(:,:,cnt)=featureIm(:,:,cnt)+mean(fIm,3);
% end;
% ntscIm(:,:,1)=featureIm(:,:,1);
% imshow(ntscIm(:,:,1))

% lnonzero=find(colorIm);
% tC=reshape(ntscIm(:,:,2),1,height*width);
% tG=reshape(featureIm,featurelen,height*width);
% C=tC(lnonzero);
% G=tG(:,lnonzero);
% W=lgce(C,G,featurelen);
% nI2=getColorExactyz(C,G,W,featureIm,colorIm);
% 
% 
% lnonzero=find(colorIm);
% tC=reshape(ntscIm(:,:,3),1,height*width);
% tG=reshape(featureIm,featureLen,height*width);
% C=tC(lnonzero);
% G=tG(:,lnonzero);
% W=lgce(C,G,featurelen);
% nI3=getColorExactyz(C,G,W,featureIm,colorIm);
%featureIm(:,:,1)=ntscIm(:,:,1);
nI=getColorExact3(colorIm,ntscIm,featureIm);
% if (solver==1)
%   nI=getVolColor(colorIm,ntscIm,[],[],[],[],5,1);
%   nI=ntsc2rgb(nI);
% else
%   nI=getColorExact(colorIm,ntscIm,featureIm);
% end
%nI=getColorExact(colorIm,ntscIm,featureIm);
figure, imshow(nI)

imwrite(nI,out_name)
   
  

%Reminder: mex cmd
%mex -O getVolColor.cpp fmg.cpp mg.cpp  tensor2d.cpp  tensor3d.cpp
