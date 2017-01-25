%description: 
%  perform all the scale space analysis
%param: 
%  img = image file name
%  deepness = deepness of the scale space
%result: 
%  edge_gx, edge_gy = x and y gradient value over the scale space for each fine scale edge pixel
%  edge_norm = normalized gradient norm over the scale space for each fine scale edge pixel
%  ss_canny = canny edges scale space
%  life_time_map = lifetime of each edge pixel over the scale space
%  best_scale_nb = best scale of each edge pixel

function [edge_gx,edge_gy, edge_norm,ss_canny,life_time_map, best_scale_nb] = make_scale_spaces(img, deepness)
    %read the input image
    f = imread(img);
    %convert to luminance
    fg = rgb2gray(f);
    %make it double
    fg = (double(fg(:,:,1))/255.0);
    f = (double(f(:,:,:))/255.0);

    %apply a sigma=0.8 blur because the scale space analysis only starts at sigma=0.8
    h = fspecial('gaussian',3,0.8);
    fg = imfilter(fg,h);
    f = imfilter(f,h);

    %create first derivative scale space
    [ss_x,ss_y,ss_norm] = scale_space_deriv(fg,f, deepness);
    %create Canny edges scale space
    ss_canny = scale_space_canny(fg, deepness);
    %compute the lifetime information from the canny scale space
    [life_time_map,ss_canny] = scale_map_canny(ss_canny, deepness);
    %edge linking
    [edge_norm, edge_gx, edge_gy] = scale_space_link(ss_canny, ss_norm, ss_x, ss_y, life_time_map, deepness);
    %estimate the best scale
    best_scale_nb = best_scale(edge_norm, deepness);
    clear ss_x;
    clear ss_y;
    clear ss_norm;
    %time_used = toc; disp(sprintf('Time for Scale Space generation = %f secs',time_used));

    figure();
    imshow(life_time_map);
