%Gradient using first order derivative of Gaussian.
%  [gx,gy]=gaussgradient(IM,sigma) outputs the gradient image gx and gy of
%  image IM using a 2-D Gaussian kernel. Sigma is the standard deviation of
%  this kernel along both directions.
%
%  Based on the implementation of Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.

function [gx,gy]=gaussgradient(IM,sigma)

%determine the appropriate size of kernel. 
halfsize=3*ceil(sigma);
size=2*halfsize+1;
%generate a Gaussian kernel along x direction
for i=1:size
    %original model: generate a 2D gaussian kernel
    %for j=1:size
     %   u=[i-halfsize-1 j-halfsize-1];
      %  hx(i,j)=gauss(u(1),sigma)*dgauss(u(2),sigma);
    %end

    %simplified model: generate a 1D gaussian kernel
    hx(i)=dgauss(i-halfsize-1,sigma);
end
%generate a Gaussian kernel along y direction
hy=hx';
%2-D filtering
gx=imfilter(IM,hx,'replicate','conv');
gy=imfilter(IM,hy,'replicate','conv');

function y = gauss(x,sigma)
%Gaussian
y = exp(-x^2/(2*sigma^2)) / (sigma*sqrt(2*pi));

function y = dgauss(x,sigma)
%first order derivative of Gaussian
y = -x * gauss(x,sigma) / sigma^2;
