clear;
img='../dataset/i/i';

k = 500;
ks= num2str(k);
supdir =strcat('../SLIC/superpixels',ks,'/');% the superpixel label file path
spname=[supdir img(14:end) '.dat'];
%spimg =
%imnames=dir([supdir '*.bmp']);

areaall;
edged;
seg2;
ins2;