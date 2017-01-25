clear
addpath(genpath(pwd));

all = [];
psnrlist= [];%��űȽϺõĽ��
badlist = [];%��űȽϲ�Ľ��
goodname = [];%��űȽϺõĽ�����ļ���
badname = [];%��űȽϲ�Ľ�����ļ���
newcount=0;
count = 0;

imgnewRoot = '../dataset/newdata/';
imgnewOrigin = '../dataset/graynewdata/';
imgDest = '../dataset/newdataresult/';
imnewnames=dir([imgnewRoot '*' '.bmp']);

for ii = 1:length(imnames)
    disp(ii);
    imnewname=[imgnewOrigin imnewnames(ii).name(1:end-4)]; 
    imgnew = imnewname;
    oriname = strcat(imgnew, 'r.bmp');
    mynewname_slic = strcat(imgDest,imgnew(24:end) ,'_slic.bmp');
    
    oriimg = double(imread(oriname));
    mynewimg_slci = double(imread(mynewname_slic));
    PSNR_slic = PSNRcal(mynewimg_slci,oriimg);%����PSNR
    if PSNR_slic<25
        badlist = [badlist, PSNR_slic];
        badname = [badname, imgnew(24:end) ','];
        newcount = newcount +1;
        continue
    end
    psnrlist = [psnrlist, PSNR_slic];
    goodname = [goodname, imgnew(24:end)];
end
newcount

imgRoot = '../dataset/resdata/';
imgOrigin = '../dataset/grayorigin/';
imgDest = '../dataset/originresult/';
imnames=dir([imgRoot '*' '.bmp']);
for ii = 1:length(imnames)
    disp(ii);
    imname=[imgOrigin imnames(ii).name(1:end-4)]; 
    img = imname;
    oriname = strcat(img, 'r.bmp');
    myname_slic = strcat(imgDest,img(23:end) ,'_slic.bmp');
    
    oriimg = double(imread(oriname));
    myimg_slci = double(imread(myname_slic));
    PSNR_slic = PSNRcal(myimg_slci,oriimg);%����PSNR
    if PSNR_slic<25
        badlist = [badlist, PSNR_slic];
        badname = [badname, img(23:end) ','];
        count = count+1;
        continue
    end
    
    psnrlist = [psnrlist PSNR_slic];
    goodname = [goodname img(23:end) ','];
   
end
count

%%=====������ֱ��ͼ======%%
figure,
bar(all);
axis([0 66 0 45])
xlabel('No.'),ylabel('PSNR')  %����x���y�������
legend('SLIC','VGG')  %

%%=====�ȽϺõĽ��ֱ��ͼ======%%
figure,
bar(psnrlist);
axis([0 61 0 45])
xlabel('No.'),ylabel('PSNR')  %����x���y�������
legend('SLIC','VGG')  %

%%=====�Ƚϲ�Ľ��ֱ��ͼ======%%
figure,
bar(badlist);
%axis([0 15 0 45])
xlabel('No.'),ylabel('PSNR')  %����x���y�������
legend('SLIC','VGG')  %

%%===ssim���===%%
%{
figure,
bar(ssimlist);
axis([0 26 0.5 1.2])
xlabel('No.'),ylabel('SSIM')  %����x���y�������
legend('SLIC','VGG')  %
%}
