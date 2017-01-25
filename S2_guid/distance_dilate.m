%description: 
%  dilate edge datas (gradient norm, x gradient, y gradient)
%  using a distance function from a binary edge image. The resulting
%  datas contain for each pixel the values of the closest edge pixel.
%param: 
%  img_source = binary canny edges
%  img_value_norm = gradient norm of the edges
%  img_value_x = x gradient of the edges
%  img_value_y = y gradient of the edges
%  radius = size of the dilation
%result:
%  val_norm = dilated gradient norm
%  val_x = dilated x gradient
%  val_y = dilated y gradient
function [val_norm, val_x, val_y] = distance_dilate(img_source, img_value_norm, img_value_x, img_value_y, radius)
    %distance map
    dist = img_source.*0 + (1-img_source).*1000;

    %distance mask
    mask(1,:) = [4, 3, 4];
    mask(2,:) = [3, 0, 3];
    mask(3,:) = [4, 3, 4];

    %image size
    [h,w,c] = size(img_value_x);

    %edge values
    val_norm(:,:,1) = img_value_norm(:,:,1).*img_source;
    val_x(:,:,1) = img_value_x(:,:,1).*img_source;
    if c>1
        val_x(:,:,2) = img_value_x(:,:,2).*img_source;
        val_x(:,:,3) = img_value_x(:,:,3).*img_source;
    end
    val_y(:,:,1) = img_value_y(:,:,1).*img_source;
    if c>1
        val_y(:,:,2) = img_value_y(:,:,2).*img_source;
        val_y(:,:,3) = img_value_y(:,:,3).*img_source;
    end

    %loop over the image to compute chanfrein distance
    %first pass
    dist_temp = dist;
    val_temp_norm = val_norm;
    val_temp_x = val_x;
    val_temp_y = val_y;
    for i=2:h-1
        for j=2:w-1
            dmin = dist(i,j,:);
            valmin = val_norm(i,j,:);
            valxmin = val_x(i,j,:);
            valymin = val_y(i,j,:);
            for n=-1:1 
                dcurr = dist_temp(i-1,j+n,:)+mask(1,2+n);
                if dcurr<dmin
                    dmin=dcurr;
                    valmin = val_temp_norm(i-1,j+n,:);
                    valxmin = val_temp_x(i-1,j+n,:);
                    valymin = val_temp_y(i-1,j+n,:);
                end
            end
            dcurr = dist_temp(i,j-1,:)+mask(2,1);
            if dcurr<dmin
                dmin=dcurr;
                valmin = val_temp_norm(i,j-1,:);
                valxmin = val_temp_x(i,j-1,:);
                valymin = val_temp_y(i,j-1,:);
            end
            dist_temp(i,j,:)=dmin;
            val_temp_norm(i,j,:) = valmin;
            val_temp_x(i,j,:) = valxmin;
            val_temp_y(i,j,:) = valymin;
        end
    end
    dist = dist_temp;
    val_norm = val_temp_norm;
    val_x = val_temp_x;
    val_y = val_temp_y;

    %second pass
    dist_temp = dist;
    val_temp_norm = val_norm;
    val_temp_x = val_x;
    val_temp_y = val_y;
    for i=1:h-2
        for j=1:w-2
            dmin = dist(h-i,w-j,:);
            valmin = val_norm(h-i,w-j,:);
            valxmin = val_x(h-i,w-j,:);
            valymin = val_y(h-i,w-j,:);
            for n=-1:1 
                dcurr = dist_temp(h-i+1,w-j+n,:)+mask(3,2+n);
                if dcurr<dmin
                    dmin=dcurr;
                    valmin = val_temp_norm(h-i+1,w-j+n,:);
                    valxmin = val_temp_x(h-i+1,w-j+n,:);
                    valymin = val_temp_y(h-i+1,w-j+n,:);
                end
            end
            dcurr = dist_temp(h-i,w-j+1,:)+mask(2,3);
            if dcurr<dmin
                dmin=dcurr;
                valmin = val_temp_norm(h-i,w-j+1,:);
                valxmin = val_temp_x(h-i,w-j+1,:);
                valymin = val_temp_y(h-i,w-j+1,:);
            end
            dist_temp(h-i,w-j,:)=dmin;
            val_temp_norm(h-i,w-j,:)=valmin;
            val_temp_x(h-i,w-j,:) = valxmin;
            val_temp_y(h-i,w-j,:) = valymin;
        end
    end
    dist = dist_temp;
    val_norm = val_temp_norm;
    val_x = val_temp_x;
    val_y = val_temp_y;

    %dilated edges
    selected = (dist+img_source)<3*(radius+1);
    val_norm = val_norm.*selected;
    val_x(:,:,1) = val_x(:,:,1).*selected;
    val_x(:,:,2) = val_x(:,:,2).*selected;
    val_x(:,:,3) = val_x(:,:,3).*selected;
    val_y(:,:,1) = val_y(:,:,1).*selected;
    val_y(:,:,2) = val_y(:,:,2).*selected;
    val_y(:,:,3) = val_y(:,:,3).*selected;