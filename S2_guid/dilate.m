%description: 
%  dilate a binary image using a thresholded distance function
%param: 
%  img_source = binary image
%  radius = size of the dilation
%result: 
%  dilated binary image
function [result] = dilate(img_source, radius)
    %distance map
    dist = img_source.*0 + (1-img_source).*1000;

    %distance mask, compute distances with less than 8% error according to an euclidian distance 
    %warning this distance mask produce distances multiplied by 3
    mask(1,:) = [4, 3, 4];
    mask(2,:) = [3, 0, 3];
    mask(3,:) = [4, 3, 4];

    %loop over the image to compute chanfrein distance
    [h,w] = size(img_source);
    %first pass
    dist_temp = dist;
    for i=2:h-1
        for j=2:w-1
            dmin = dist(i,j);
            for n=-1:1 
                dcurr = dist_temp(i-1,j+n)+mask(1,2+n);
                if dcurr<dmin
                    dmin=dcurr;
                end
            end
            dcurr = dist_temp(i,j-1)+mask(2,1);
            if dcurr<dmin
                dmin=dcurr;
            end
            dist_temp(i,j)=dmin;
        end
    end
    dist = dist_temp;

    %second pass
    dist_temp = dist;
    for i=1:h-2
        for j=1:w-2
            dmin = dist(h-i,w-j);
            for n=-1:1 
                dcurr = dist_temp(h-i+1,w-j+n)+mask(3,2+n);
                if dcurr<dmin
                    dmin=dcurr;
                end
            end
            dcurr = dist_temp(h-i,w-j+1)+mask(2,3);
            if dcurr<dmin
                dmin=dcurr;
            end
            dist_temp(h-i,w-j)=dmin;
        end
    end
    dist = dist_temp;

    result = ((dist+img_source)<3*(radius+1));