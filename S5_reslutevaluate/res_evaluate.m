clear
img='../dataset/PSNR/m/m';
oriname = strcat(img, 'r.bmp');
myname = strcat(img ,'yz.bmp');

oriimg = double(imread(oriname));
myimg = double(imread(myname));

PSNR = PSNRcal(myimg,oriimg);