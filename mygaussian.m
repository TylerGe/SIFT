function [ out_img ] = mygaussian( input_img, sigma )
% Function: Gaussian smooth for an image
k = 3;
hsize = round(2*k*sigma+1);
if mod(hsize,2) == 0
    hsize = hsize+1;
end
g = fspecial('gaussian',hsize,sigma);
out_img = conv2(input_img,g,'same');
end