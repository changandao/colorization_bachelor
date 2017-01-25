%description: 
%  perform the edge linking over the scale space, 
%  so that each fine scale edge pixel has its linked values for each scale
%param: 
%  ss_canny = canny edges scale space
%  ss_norm = normalized gradient norm
%  ss_x = x gradient scale space
%  ss_y = y gradient scale space
%  life_time_map = lifetime of each edge pixel over the scale space
%  deepness = deepness of the scale space
%result:
%  for each fine scale edge pixel, the linked values over the scale space for:
%  edge_norm = normalized gradient norm 
%  edge_gx = x gradient
%  edge_gy = y gradient

function [edge_norm, edge_gx, edge_gy] = scale_space_link(ss_canny, ss_norm, ss_x, ss_y, life_time_map, deepness)

[H,W,C] = size(ss_x);
D = deepness;

edge_norm = zeros(H,W,D);
edge_gx = zeros(H,W,C,D);
edge_gy = zeros(H,W,C,D);

for i=1:deepness%for each scale

    %edges that appear at the current scale
    selected_edges = ss_canny(:,:,1).*(life_time_map>=i);
       
    nvmax = max(selected_edges(:));
    if nvmax>0 %if there are some edges at this scale

        %dilate the edge informations to cover the possible moving area of the edge in the scale space
	  %perform this dilation using a distance field
        [norm_dilate, gx_dilate, gy_dilate] = distance_dilate(ss_canny(:,:,i), ss_norm(:,:,i), ss_x(:,:,:,i), ss_y(:,:,:,i), i-1);

	  %select for each edge the closest edge information
        edge_norm(:,:,i) = selected_edges.*norm_dilate;
        edge_gx(:,:,1,i) = selected_edges.*gx_dilate(:,:,1);
        edge_gx(:,:,2,i) = selected_edges.*gx_dilate(:,:,2);
        edge_gx(:,:,3,i) = selected_edges.*gx_dilate(:,:,3);
        edge_gy(:,:,1,i) = selected_edges.*gy_dilate(:,:,1);
        edge_gy(:,:,2,i) = selected_edges.*gy_dilate(:,:,2);
        edge_gy(:,:,3,i) = selected_edges.*gy_dilate(:,:,3);
    end    
end