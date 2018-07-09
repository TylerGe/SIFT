% image_A = imread('11.jpg');
% image_B = imread('22.jpg');
% reord_1=imread('reord_11.jpg');
% reord_2=imread('reord_22.jpg');
[height_wrap, width_wrap,~] = size(img1);
[height_unwrap, width_unwrap,~] = size(img2);

% CONVERT TO GRAY SCALE
% gray_A = im2double(rgb2gray(img1));
% gray_B = im2double(rgb2gray(img2));


% % FIND HARRIS CORNERS IN BOTH IMAGE
% [x_A, y_A, v_A] = harris(gray_A, 2, 0.0, 2);
% [x_B, y_B, v_B] = harris(gray_B, 2, 0.0, 2);
% 
% % ADAPTIVE NON-MAXIMAL SUPPRESSION (ANMS)
% ncorners = 500;
% [x_A, y_A, ~] = ada_nonmax_suppression(x_A, y_A, v_A, ncorners);
% [x_B, y_B, ~] = ada_nonmax_suppression(x_B, y_B, v_B, ncorners);
% 
% % EXTRACT FEATURE DESCRIPTORS
% sigma = 7;
% [des_A] = getFeatureDescriptor(gray_A, x_A, y_A, sigma);
% [des_B] = getFeatureDescriptor(gray_B, x_B, y_B, sigma);
% 
% % IMPLEMENT FEATURE MATCHING
% dist = dist2(des_A,des_B);
% [ord_dist, index] = sort(dist, 2);
% % THE RATIO OF FIRST AND SECOND DISTANCE IS A BETTER CRETIA THAN DIRECTLY
% % USING THE DISTANCE. RATIO LESS THAN .5 GIVES AN ACCEPTABLE ERROR RATE.
% ratio = ord_dist(:,1)./ord_dist(:,2);
% threshold = 0.5;
% idx = ratio<threshold;
% 
% x_A = x_A(idx);
% y_A = y_A(idx);
% x_B = x_B(index(idx,1));
% y_B = y_B(index(idx,1));
% npoints = length(x_A);
% 
% 
% % USE 4-POINT RANSAC TO COMPUTE A ROBUST HOMOGRAPHY ESTIMATE
% % KEEP THE FIRST IMAGE UNWARPED, WARP THE SECOND TO THE FIRST
% matcher_A = [y_A, x_A, ones(npoints,1)]'; %!!! previous x is y and y is x,
% matcher_B = [y_B, x_B, ones(npoints,1)]'; %!!! so switch x and y here.
% % [hh, ~] = ransacfithomography(matcher_B, matcher_A, npoints, 10);
% 
% % s = load('matcher.mat');
% % matcher_A = s.matcher(1:3,:);
% % matcher_B = s.matcher(4:6,:);
% % npoints = 60;
% [hh, inliers,AAA,BBB] = ransacfithomography(matcher_B, matcher_A, npoints, 10);
image_A=img3;
image_B=img1;
hh=inv(H);
% USE INVERSE WARP METHOD
% DETERMINE THE SIZE OF THE WHOLE IMAGE
[newH, newW, newX, newY, xB, yB] = getNewSize(inv(H), height_wrap, width_wrap, height_unwrap, width_unwrap);

[X,Y] = meshgrid(1:width_wrap,1:height_wrap);
[XX,YY] = meshgrid(newX:newX+newW-1, newY:newY+newH-1);
AA = ones(3,newH*newW);
AA(1,:) = reshape(XX,1,newH*newW);
AA(2,:) = reshape(YY,1,newH*newW);

AA = hh*AA;
XX = reshape(AA(1,:)./AA(3,:), newH, newW);
YY = reshape(AA(2,:)./AA(3,:), newH, newW);

% INTERPOLATION, WARP IMAGE A INTO NEW IMAGE
newImage(:,:,1) = interp2(X, Y, double(image_A(:,:,1)), XX, YY);
newImage(:,:,2) = interp2(X, Y, double(image_A(:,:,2)), XX, YY);
newImage(:,:,3) = interp2(X, Y, double(image_A(:,:,3)), XX, YY);

% BLEND IMAGE BY CROSS DISSOLVE
[newImage] = blend(newImage, image_B, xB, yB);

% DISPLAY IMAGE MOSIAC
imshow(uint8(newImage));

 
function n2 = dist2(x, c)
% DIST2 Calculates squared distance between two sets of points.
% Adapted from Netlab neural network software:
% http://www.ncrg.aston.ac.uk/netlab/index.php
%
% Description
% D = DIST2(X, C) takes two matrices of vectors and calculates the
% squared Euclidean distance between them. Both matrices must be of
% the same column dimension. If X has M rows and N columns, and C has
% L rows and N columns, then the result has M rows and L columns. The
% I, Jth entry is the squared distance from the Ith row of X to the
% Jth row of C.
%
%
% Copyright (c) Ian T Nabney (1996-2001)

    [ndata, dimx] = size(x);
    [ncentres, dimc] = size(c);
    if dimx ~= dimc
    error('Data dimension does not match dimension of centres')
    end

    n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
    ones(ndata, 1) * sum((c.^2)',1) - ...
    2.*(x*(c'));

    % Rounding errors occasionally cause negative entries in n2
    if any(any(n2<0))
    n2(n2<0) = 0;
    end
end

function [newH, newW, x1, y1, x2, y2] = getNewSize(transform, h2, w2, h1, w1)
% Calculate the size of new mosaic
% Input:
% transform - homography matrix
% h1 - height of the unwarped image
% w1 - width of the unwarped image
% h2 - height of the warped image
% w2 - height of the warped image
% Output:
% newH - height of the new image
% newW - width of the new image
% x1 - x coordate of lefttop corner of new image
% y1 - y coordate of lefttop corner of new image
% x2 - x coordate of lefttop corner of unwarped image
% y2 - y coordate of lefttop corner of unwarped image
% 
% Yihua Zhao 02-02-2014
% zhyh8341@gmail.com
%

    % CREATE MESH-GRID FOR THE WARPED IMAGE
    [X,Y] = meshgrid(1:w2,1:h2);
    AA = ones(3,h2*w2);
    AA(1,:) = reshape(X,1,h2*w2);
    AA(2,:) = reshape(Y,1,h2*w2);

    % DETERMINE THE FOUR CORNER OF NEW IMAGE
    newAA = transform\AA;
    new_left = fix(min([1,min(newAA(1,:)./newAA(3,:))]));
    new_right = fix(max([w1,max(newAA(1,:)./newAA(3,:))]));
    new_top = fix(min([1,min(newAA(2,:)./newAA(3,:))]));
    new_bottom = fix(max([h1,max(newAA(2,:)./newAA(3,:))]));

    newH = new_bottom - new_top + 1;
    newW = new_right - new_left + 1;
    x1 = new_left;
    y1 = new_top;
    x2 = 2 - new_left;
    y2 = 2 - new_top;
end
function [newImage] = blend(warped_image, unwarped_image, x, y)
% Blend two image by using cross dissolve
% Input:
% warped_image - original image
% unwarped_image - the other image
% x - x coordinate of the lefttop corner of unwarped image
% y - y coordinate of the lefttop corner of unwarped image
% Output:
% newImage
% 
% Yihua Zhao 02-02-2014
% zhyh8341@gmail.com
%


% MAKE MASKS FOR BOTH IMAGES 
    warped_image(isnan(warped_image))=0;
    maskA = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);
    newImage = zeros(size(warped_image));
    newImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;
    mask = (newImage(:,:,1)>0 | newImage(:,:,2)>0 | newImage(:,:,3)>0);
    mask = and(maskA, mask);

    % GET THE OVERLAID REGION
    [~,col] = find(mask);
    left = min(col);
    right = max(col);
    mask = ones(size(mask));
    if( x<2)
        mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
    else
        mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
    end

    % BLEND EACH CHANNEL
    warped_image(:,:,1) = warped_image(:,:,1).*mask;
    warped_image(:,:,2) = warped_image(:,:,2).*mask;
    warped_image(:,:,3) = warped_image(:,:,3).*mask;

    % REVERSE THE ALPHA VALUE
    if( x<2)
        mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
    else
        mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
    end
    newImage(:,:,1) = newImage(:,:,1).*mask;
    newImage(:,:,2) = newImage(:,:,2).*mask;
    newImage(:,:,3) = newImage(:,:,3).*mask;

    newImage(:,:,1) = warped_image(:,:,1) + newImage(:,:,1);
    newImage(:,:,2) = warped_image(:,:,2) + newImage(:,:,2);
    newImage(:,:,3) = warped_image(:,:,3) + newImage(:,:,3);
end