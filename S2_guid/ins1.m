path=strcat(img,'g.bmp');%gray image
gI=double(imread(path))/255;
[height,width]=size(gI);
% path=strcat(img,'s.bmp');
segI=showI;%double(imread(path))/255;
path=strcat(img,'et.bmp');
edgeI=double(imread(path))/255;
path=strcat(img,'e.bmp');
etI=double(imread(path));
fse90 = strel('line', 5, 90);
fse0 = strel('line', 5, 0);
fI = imdilate(etI, [fse90 fse0]);

[height,width,depth]=size(gI);
BWsdil2=zeros(height,width);
colorI=zeros(height,width);
WT=getWT(colorI,gI);
data=reshape(gI,height*width,1);
tmpI=WT*data;
err=abs(reshape(tmpI,height,width));

cnt=1;
plotI=zeros(height,width);
while(length(find(abs(segI-0.05*cnt)<0.01))>0)
    pI=abs(segI-0.05*cnt)<0.01;
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    pI = imdilate(pI, [se90 se0]);
    pI = imerode(pI, [se90 se0]);
    pI = imerode(pI, [se90 se0]);
%     if(sum(sum(pI))>3000)
%         pI = imerode(pI, [se90 se0]);
%     end;
    plen=sum(sum(pI));
    errpI=pI.*err;
    [nx,ny]=find(errpI);
    nz=find(errpI);
    value=errpI(nz);
    %value=value/sum(value);
    rsval = sortrows([value';nx';ny']',1);
    tlen=length(nz);
    if(tlen<=0)
        cnt=cnt+1;
        continue;
    end;
    glen=min(floor(plen/500)+10,tlen);
    %length(find(value>0.001));
    
    x=rsval(tlen-glen+1:tlen,2);
    y=rsval(tlen-glen+1:tlen,3);
       xb = x(1:6:end);
       pp = ppfit(x,y,xb);
       xx = linspace(min(x),max(x),200);
       yy = ppval(pp,xx);
       %yb = ppval(pp,xb);
       %plot(x,y,'bo',xx,yy,'r',xb,yb,'r.')
    tI=zeros(height,width);
    tI=bitmapplot(xx,yy,tI);  
    tI = imdilate(tI, [se90 se0]);
    tI=tI.*pI;
    expI=tI>0;
%     while(length(find(expI))>0)
%          [xl,yl]=find(expI~=0);      
%          x=xl(1);
%          y=yl(1);
%          J = regiongrowing(expI,x,y,0.04); 
%          expI=expI.*(~J);
%              if(length(find(J))>100)
%                 plotI=plotI+J*cnt*0.05;
%              end;
%     end;
    
    plotI=plotI+tI;
    %imshow(pI-plotI);
    cnt=cnt+1;

tt=gI+plotI;
imshow(tt)
    plotI=plotI.*(~fI);
    scribI=plotI>0;
    gtI=gI.*scribI;

    colorI=(gtI~=0);

    W=getW(colorI,gI,edgeI);
    lblInds=find(colorI);

    b=zeros(size(W,1),1);
    b(lblInds)=gI(lblInds);
    rsI=W\b;   
    rsI=reshape(rsI,height,width);
    err=abs(gI-rsI);
    

    
    
ttcnt=1;  
threthhold=sum(sum(err))/height/width;
while(length(abs(err)>threthhold)>100 && ttcnt>0)
    threth=sum(sum(err))/height/width;
    tcnt=1;
    expI=(abs(err)>threth);
    [height,width]=size(expI);
    showI=zeros(height,width);
    
    thr=(max(max(expI))-min(min(expI)))/20;
    while(length(find(expI))>100)
         [xl,yl]=find(expI~=0);      
         x=xl(1);
         y=yl(1);
         J = regiongrowing(expI,x,y,thr); 
         expI=expI.*(~J);
             if(length(find(J))>ttcnt*25)
                showI=showI+J*tcnt*0.05;
                tcnt=tcnt+1;
             end;
    end; 
    segI=showI;
    cnt=1;
    
while(cnt<=tcnt)
    pI=abs(segI-0.05*cnt)<0.01;
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    pI = imdilate(pI, [se90 se0]);
    pI = imerode(pI, [se90 se0]);
    pI = imerode(pI, [se90 se0]);
    pI = imerode(pI, [se90 se0]);

    errpI=pI.*err;
    [nx,ny]=find(errpI);
    nz=find(errpI);
    value=errpI(nz);
    %value=value/sum(value);
    rsval = sortrows([value';nx';ny']',1);
    tlen=length(nz);
    if(tlen<=0)
        cnt=cnt+1;
        continue;
    end;
    glen=min(ttcnt*10,tlen);
    %length(find(value>0.001));
    
    x=rsval(tlen-glen+1:tlen,2);
    y=rsval(tlen-glen+1:tlen,3);
       xb = x(1:6:end);
       pp = ppfit(x,y,xb);
       xx = linspace(min(x),max(x),200);
       yy = ppval(pp,xx);
       if(sum(isnan(yy))>0)
           cnt=cnt+1;
           continue;
       end;
       %yb = ppval(pp,xb);
       %plot(x,y,'bo',xx,yy,'r',xb,yb,'r.')
    tI=zeros(height,width);
    tI=bitmapplot(xx,yy,tI);  
    tI = imdilate(tI, [se90 se0]);
    tI=tI.*pI;
    plotI=plotI+tI;
    %imshow(pI-plotI);
    ttI=abs(segI-0.05*cnt)<0.01;
    cnt=cnt+1;
end;


    scribI=plotI>0;
    gtI=gI.*scribI;

    colorI=(gtI~=0);

    W=getW(colorI,gI,edgeI);
    lblInds=find(colorI);

    b=zeros(size(W,1),1);
    b(lblInds)=gI(lblInds);
    rsI=W\b;   
    rsI=reshape(rsI,height,width);
    err=abs(gI-rsI);
    ttcnt=ttcnt-1;
end;
end
%imwrite((plotI>0),path);
    




