clear all;
addpath('./others/');
%%------------------------set parameters---------------------%%
k = 100;%number of superpixels
k = num2str(k);
supdir=strcat('./superpixels',k,'/');% the superpixel label file path
imnames=dir([supdir '*.bmp']);

for ii=1:length(imnames)   
    disp(ii);
    imname=[supdir imnames(ii).name]; 
    [input_im,w]=removeframe(imname);% run a pre-processing to remove the image frame 
    [m,n,k] = size(input_im);
%%----------------------count superpixels--------------------%%
    %imname=[imname(1:end-4) '.bmp'];% the slic software support only the '.bmp' image    
    spname=[supdir imnames(ii).name(1:end-9)  '.dat'];
    superpixels=ReadDAT([m,n],spname); % superpixel label matrix
    spnum=max(superpixels(:));% the actual superpixel number
    
end