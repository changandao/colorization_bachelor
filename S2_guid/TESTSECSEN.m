clear;
I = im2double(imread('testScene.bmp'));
x=58; y=341;
J = regiongrowing(I,x,y,0.2); 
figure, imshow(I+J);