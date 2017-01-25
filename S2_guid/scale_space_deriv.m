%description: 
%  compute the image derivative scale space informations
%param: 
%  img_nvg = luminance image
%  img_clr = color image
%  deepness = deepness of the scale space
%result: 
%  scale_space_x = contrast compensated x gradient
%  scale_space_y = contrast compensated y gradient
%  scale_space_norm = normalized gradient norm
function [scale_space_x,scale_space_y, scale_space_norm] = scale_space_deriv(img_nvg, img_clr, deepness)    
    %image size
    [H,W,C] = size(img_clr);
    D = deepness;
    scale_space_x = zeros(H,W,C,D);
    scale_space_y = zeros(H,W,C,D);
    scale_space_norm = zeros(H,W,C,D);
    
    for i=1:deepness
        %start with sigma(0) = 0.8, increase sigma by 0.4 for each scale
        sigma = 0.8+0.4*(i-1);

        %x and y derivatives of the color image
        [gx,gy] = gaussgradient(img_clr,sigma);
        %compensated gradients (to obtain a correct contrast)
        scale_space_x(:,:,:,i) = gx*sigma*2*sqrt(pi);
        scale_space_y(:,:,:,i) = gy*sigma*2*sqrt(pi);
       
       %x and y derivatives of the luminance image 
       [gx,gy] = gaussgradient(img_nvg,sigma);
       %lindeberg normalization (used for blur estimation)
       gx = gx*sqrt(sigma); gy = gy*sqrt(sigma);
       scale_space_norm(:,:,i) = sqrt(gx.*gx+gy.*gy);
    end
    
  clear f;
  clear fg;