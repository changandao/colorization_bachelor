function PSNR = PSNRcal(myimg,oriimg)

MSE = MSEcal(myimg,oriimg);
PSNR = 10*log10(255^2/MSE);

end