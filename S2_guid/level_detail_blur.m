%description: 
%  remove detail edges from the image
%param: 
%  edge_gx, edge_gy = x and y gradient value over the scale space for each fine scale edge pixel
%  life_time_map = lifetime of each edge pixel over the scale space
%  best_scale_nb = best scale of each edge pixel
%  deepness = deepness of the scale space
%  scale = minimum scale to keep (threshold of the level of detail)
%  img = image file name
%result: 
%  life_time_map = image that store for each pixel its lifetime over the edge scale space
%  ss_canny = updated canny scale space, where blurry edges that appear in upper scales are
%             draged down to the finest scales


function [img_rec0,img_rec]=level_detail_blur(edge_gx, edge_gy, life_time_map, best_scale_nb, deepness, scale, img)
    %read the input image
    f = imread(img);
    %make it double
    f = (double(f)/255.0);

    [H,W,C] = size(f);
    %sharp level of detail gradients
    sharp_gx = zeros(H,W,C);
    sharp_gy = zeros(H,W,C);

    %reblurred level of detail gradients
    abstracted_edges = zeros(H,W);
    abstracted_gx = zeros(H,W,C);
    abstracted_gy = zeros(H,W,C);
    
    %---------- Sharp reconstruction -------------
    for i=1:deepness    %for each scale
	  %select the edges of this scale
        selected_edges = (best_scale_nb(:,:,1)==i).*(life_time_map>=scale);
	  %closing to fill gaps
        elem = strel('disk',1,0);
        dil = imdilate(selected_edges,elem);
        selected_edges = imerode(dil,elem);
        
        nvmax = max(selected_edges(:));
        if nvmax>0 %if there are pixels at this scale 
		%update the level of detail edges
		abstracted_edges = abstracted_edges+selected_edges;
            sharp_gx(:,:,1) = sharp_gx(:,:,1)+selected_edges.*edge_gx(:,:,1,i);
            sharp_gx(:,:,2) = sharp_gx(:,:,2)+selected_edges.*edge_gx(:,:,2,i);
            sharp_gx(:,:,3) = sharp_gx(:,:,3)+selected_edges.*edge_gx(:,:,3,i);
            sharp_gy(:,:,1) = sharp_gy(:,:,1)+selected_edges.*edge_gy(:,:,1,i);
            sharp_gy(:,:,2) = sharp_gy(:,:,2)+selected_edges.*edge_gy(:,:,2,i);
            sharp_gy(:,:,3) = sharp_gy(:,:,3)+selected_edges.*edge_gy(:,:,3,i);
        end
    end

    %reconstructed image
    img_rec(:,:,1) = poisson_solver_function(sharp_gx(:,:,1), ...
                                            sharp_gy(:,:,1), ...
                                            f(:,:,1));
    img_rec(:,:,2) = poisson_solver_function(sharp_gx(:,:,2), ...
                                            sharp_gy(:,:,1), ...
                                            f(:,:,2));
    img_rec(:,:,3) = poisson_solver_function(sharp_gx(:,:,3), ...
                                            sharp_gy(:,:,1), ...
                                            f(:,:,3));
    img_rec0=img_rec;
    figure();
    imshow(img_rec0);

    %---------- Blurred reconstruction -------------
    %Compute the reblurring. The blur scale is the first best scale
    %( best_scale_nb(:,:,1) ).
    blur_scale_nb=best_scale_nb(:,:,1);
    for i=1:deepness    %for each scale
	  %select the edges at this scale
        selected_edges = (blur_scale_nb==i).*(life_time_map>=scale);
        elem = strel('disk',1,0);
        dil = imdilate(selected_edges,elem);
        selected_edges = imerode(dil,elem);
       
        %if there are pixels to blur at this scale 
        nvmax = max(selected_edges(:));
        if nvmax>0
                sigma = (0.8+(i-1)*0.4); %blur kernel
                h = fspecial('gaussian',ceil(3*sigma),sigma);
                new_gx(:,:,1) = imfilter(sharp_gx(:,:,1).*selected_edges, h);
                new_gx(:,:,2) = imfilter(sharp_gx(:,:,2).*selected_edges, h);
                new_gx(:,:,3) = imfilter(sharp_gx(:,:,3).*selected_edges, h);
                new_gy(:,:,1) = imfilter(sharp_gy(:,:,1).*selected_edges, h);
                new_gy(:,:,2) = imfilter(sharp_gy(:,:,2).*selected_edges, h);
                new_gy(:,:,3) = imfilter(sharp_gy(:,:,3).*selected_edges, h);

            abstracted_gx(:,:,1) = abstracted_gx(:,:,1)+new_gx(:,:,1);
            abstracted_gx(:,:,2) = abstracted_gx(:,:,2)+new_gx(:,:,2);
            abstracted_gx(:,:,3) = abstracted_gx(:,:,3)+new_gx(:,:,3);
            abstracted_gy(:,:,1) = abstracted_gy(:,:,1)+new_gy(:,:,1);
            abstracted_gy(:,:,2) = abstracted_gy(:,:,2)+new_gy(:,:,2);
            abstracted_gy(:,:,3) = abstracted_gy(:,:,3)+new_gy(:,:,3);
        end
    end

    %reconstructed blurred image
    img_rec(:,:,1) = poisson_solver_function(abstracted_gx(:,:,1), ...
                                            abstracted_gy(:,:,1), ...
                                            f(:,:,1));
    img_rec(:,:,2) = poisson_solver_function(abstracted_gx(:,:,2), ...
                                            abstracted_gy(:,:,2), ...
                                            f(:,:,2));
    img_rec(:,:,3) = poisson_solver_function(abstracted_gx(:,:,3), ...
                                            abstracted_gy(:,:,3), ...
                                            f(:,:,3));

    figure();
    imshow(img_rec);
    
    clear sharp_gx;
    clear sharp_gy;
    
    clear abstracted_edges;
    clear abstracted_gx;
    clear abstracted_gy;   
    
    clear f;    