clear
imgRoot = '../dataset/newdata/';
imgOrigin = '../dataset/graynewdata/';
imgDest = '../dataset/sunscribble/';
imnames=dir([imgRoot '*' '.bmp']);
addpath(genpath(pwd));

for ii = 1:length(imnames)
    
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-4)]; 
    img = imname;

%img = '../dataset//';
feat = strcat(imgDest,'feature/');
g_name=strcat(imgOrigin,img(24:end),'g.bmp');
c_name=strcat(imgOrigin,img(24:end),'cp.bmp');

gI=double(imread(g_name));
cI=double(imread(c_name));

[gx,gy,gz] = size(gI);
[cx,cy,cz] = size(gI);

gIM = gI;
cIM = cI;
if ismatrix(gI)
    count = 1;
    gIM = cat(3, gI, gI, gI);
elseif ismatrix(cI)
    cIM = cat(3, cI, cI, cI);   
end

indLayers = [37, 28, 19, 10, 5];   % The CNN layers Conv5-4, Conv4-4, and Conv3-4 Conv2-2 Conv1-2 in VGG Net
nweights  = [1, 0.5, 0.02]; % Weights for combining correlation filter responses
numLayers = length(indLayers);
time = 0;
tic();
gfeat = get_features(gIM, indLayers);
cfeat = get_features(cIM, indLayers);

meangfeat5 = mapminmax(mean(gfeat{1},3),0,1);
meangfeat4 = mapminmax(mean(gfeat{2},3),0,1);
meangfeat3 = mapminmax(mean(gfeat{3},3),0,1);
meangfeat2 = mapminmax(mean(gfeat{4},3),0,1);
meangfeat1 = mapminmax(mean(gfeat{5},3),0,1);


path5 = strcat(feat,'gray5.bmp');
path4 = strcat(feat,'gray4.bmp');
path3 = strcat(feat,'gray3.bmp');
path2 = strcat(feat,'gray2.bmp');
path1 = strcat(feat,'gray1.bmp');
imwrite(meangfeat5,path5);
imwrite(meangfeat4,path4);
imwrite(meangfeat3,path3);
imwrite(meangfeat2,path2);
imwrite(meangfeat1,path1);


meangceat5 = mapminmax(mean(cfeat{1},3),0,1);
meangceat4 = mapminmax(mean(cfeat{2},3),0,1);
meangceat3 = mapminmax(mean(cfeat{3},3),0,1);
meangceat2 = mapminmax(mean(cfeat{4},3),0,1);
meangceat1 = mapminmax(mean(cfeat{5},3),0,1);

figure
subplot(221)
imshow(meangfeat2)
subplot(222)
imshow(meangceat2)

resize_gfeat5 = imResample(meangfeat5,[gx,gy]);
resize_gfeat4 = imResample(meangfeat4,[gx,gy]);
resize_gfeat3 = imResample(meangfeat3,[gx,gy]);
resize_gfeat2 = imResample(meangfeat2,[gx,gy]);
resize_gfeat1 = imResample(meangfeat1,[gx,gy]);

path5 = strcat(feat,'regray5.bmp');
path4 = strcat(feat,'regray4.bmp');
path3 = strcat(feat,'regray3.bmp');
path2 = strcat(feat,'regray2.bmp');
path1 = strcat(feat,'regray1.bmp');
imwrite(resize_gfeat5,path5);
imwrite(resize_gfeat4,path4);
imwrite(resize_gfeat3,path3);
imwrite(resize_gfeat2,path2);
imwrite(resize_gfeat1,path1);

resize_cfeat5 = imResample(meangceat5,[gx,gy]);
resize_cfeat4 = imResample(meangceat4,[gx,gy]);
resize_cfeat3 = imResample(meangceat3,[gx,gy]);
resize_cfeat2 = imResample(meangceat2,[gx,gy]);
resize_cfeat1 = imResample(meangceat1,[gx,gy]);

subplot(223)
imshow(resize_gfeat1)
subplot(224)
imshow(resize_cfeat1)
gfeatname = strcat(imgDest,'feature/',img(24:end),'_gfeatdata');
cfeatname = strcat(imgDest,'feature/',img(24:end),'_cfeatdata');
save(gfeatname,'resize_gfeat5','resize_gfeat4','resize_gfeat3','resize_gfeat2','resize_gfeat1')
save(cfeatname,'resize_cfeat5','resize_cfeat4','resize_cfeat3','resize_cfeat2','resize_cfeat1')

time = time + toc();
time
end