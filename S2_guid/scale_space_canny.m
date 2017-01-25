%description: 
%  compute the canny edges scale space
%param: 
%  img = luminance image
%  deepness = deepness of the scale space to compute
%result: 
%  scale_space = canny scale space
function scale_space=scale_space_canny(img, deepness)
   
    %compute the canny edges for each scale
    for i=1:deepness
        %start with sigma(0) = 0.8, increase sigma by 0.4 for each scale
        sigma = 0.8+0.4*(i-1);
        scale_space(:,:,i) = edge(img,'canny',[],sigma);
    end
 
    clear f;