%function instrument(img)
path=strcat(img,'g.bmp');
%gI=double(imread(img))/255;
gI=double(imread(path))/255;
path=strcat(img,'e.bmp');
eI=imread(path);

se90 = strel('line', 5, 90);
se0 = strel('line', 5, 0);
BWsdil = imdilate(eI, [se90 se0]);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil2 = imdilate(eI, [se90 se0]);
%figure, imshow(BWsdil), title('dilated gradient mask');
ttI=BWsdil-BWsdil2;

if size(gI,3)==3
    gI = rgb2gray(gI);
end
grayI=gI;
gI=gI.*ttI;
%[edge_gx,edge_gy, edge_norm,ss_canny,life_time_map, best_scale_nb] = make_scale_spaces(img, 10);
[height,width]=size(gI);
colorI=(gI~=0);

    W=getW(colorI,gI,BWsdil2);
    lblInds=find(colorI);

    b=zeros(size(W,1),1);
    b(lblInds)=gI(lblInds);
    rsI=W\b;   
    rsI=reshape(rsI,height,width);
    errorI=grayI-rsI;

    expI=rsI;
    showI=zeros(height,width);
    cnt=1;
    ccnt=1;
    threth=(max(max(expI))-min(min(expI)))/20;
    while(length(find(expI))>100)
         [xl,yl]=find(expI~=0);      
         x=xl(1);
         y=yl(1);
         J = regiongrowing(expI,x,y,threth); 
         expI=expI.*(~J);
             if(length(find(J))>300)
                showI=showI+J*cnt*0.05;
                %imshow(J);
                cnt=cnt+1;
             end;
    end;
    path=strcat(imgDest,'segment/',img(24:end),'s.bmp');
    imwrite(showI,path);
%[rI,colorI]=getRI(colorI,t_edge,gI,rI,thred);
% for i=10:1
%     t_edge=(life_time_map==i);
%     t_edge=ss_canny(:,:,i);
%     [rI,colorI]=getRI(colorI,t_edge,gI,rI,thred);
% end;
