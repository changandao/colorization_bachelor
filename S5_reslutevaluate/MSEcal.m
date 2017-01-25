function MSE = MSEcal(myimg,oriimg)

[m,n,h] = size(myimg);
MSE = 0;
for j = 1:m
    for i = 1:n
        for k = 1:h
            MSE = MSE + (myimg(j,i,k)-oriimg(j,i,k))^2;
        end
    end
end
MSE = MSE/(m*n*h);
end