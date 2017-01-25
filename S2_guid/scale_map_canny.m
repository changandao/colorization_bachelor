%description: 
%  compute the lifetime structure from multiscale canny edges
%param: 
%  ss_canny = canny edges scale space
%  deepness = deepness of the scale space
%result: 
%  life_time_map = image that store for each pixel its lifetime over the edge scale space
%  ss_canny = updated canny scale space, where blurry edges that appear in upper scales are
%             draged down to the finest scales
function [life_time_map,ss_canny] =scale_map_canny(ss_canny, deepness)
    life_time_map = ss_canny(:,:,1);

    for i=2:deepness
        %an edge can only move of one pixel between two successive scales
        dil = dilate(ss_canny(:,:,i),i-1);
        %select edges that was still alive in the previous scale
        selected_edges = (dil).*(life_time_map==i-1);
        %find edges that are in canny(i), but not in the canny(i-1)
        dil = dilate(selected_edges,i-1);
        shadow_edges = ss_canny(:,:,i) - ss_canny(:,:,i).*dil;
        %update the lifetime structure
        life_time_map = life_time_map+selected_edges+shadow_edges*i;%2 he 1 chonghe de difang shi 2, dandu shi 1 de difang shi 1
        %drag down blurry edges that just appeared
        for j=1:i
            ss_canny(:,:,j) = max(ss_canny(:,:,j),shadow_edges);%shadow_edges is where 2nd has edge but 1st hasn't, so i-1 canny has all edge pixels of i to deepness;
        end
    end
