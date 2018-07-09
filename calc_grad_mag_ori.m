function [mag,ori]=calc_grad_mag_ori(img,r,c)
    [h,w]=size(img);
    if r<2 || r>h-1 || c<2 ||c>w-1
        mag=0;
        ori=0;
        return
    end
    dx=img(r,c+1)-img(r,c-1);
    dy=img(r+1,c)-img(r-1,c);
    mag=sqrt(dx*dx+dy*dy);
    if dy<0
        ori=(-atan(dy/dx)+pi/2)*180/pi+180;
    else
        ori=(-atan(dy/dx)+pi/2)*180/pi;
    end
end%gauss
