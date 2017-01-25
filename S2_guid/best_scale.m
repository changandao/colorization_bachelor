%description: 
%  find the best scale for each edge pixels (based on linderberg approach)
%param: 
%  edge_norm = normalized gradient norm scale space
%  deepness = deepness of the scale space
%result: 
%  best_scale_nb = image that store for each pixel its best scale number

function best_scale_nb = best_scale(edge_norm, deepness)
    D = ceil(deepness/2);
    [H,W,Depth]=size(edge_norm);%yzadd
    best_scale_nb = zeros(H,W,D);
    
    %for each pixel
    for i=1:H
        for j = 1:W
		%find local maxima in the normalized gradient norm
            indd =lmax(edge_norm(i,j,:));
            dim = size(indd,1);
            for k=1:dim
                best_scale_nb(i,j,k) = indd(k,1);            
		end
            clear indd;
        end
    end
   
    clear img; 