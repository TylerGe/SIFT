function hist=descr_hist(img,r,c,ori,scl,d)
    [h,w]=size(img);
    hist=zeros(4,4,8);
    cos_t=cos(ori);
    sin_t=sin(ori);
    exp_den=d*d*0.5;
    hist_width=3*scl;
    radius=floor(hist_width*sqrt(2)*(d+1)*0.5+0.5);
    for i=-radius:radius
        for j=-radius:radius
            
            c_rot = ( j * cos_t - i * sin_t ) / hist_width;            
            r_rot = ( j * sin_t + i * cos_t ) / hist_width; 
            rbin = r_rot + d / 2 - 0.5;                         
            cbin = c_rot + d / 2 - 0.5;
            if rbin>0 && rbin<d-1 && cbin>0 && cbin<d-1 
%                 && 1<r+i && r+i<h && 1<c+i && c+i<w
                [grad_mag,grad_ori]=calc_grad_mag_ori(img,r+i,c+j);
                if grad_mag==0
                    continue
                end
                grad_ori=grad_ori-ori;
                if grad_ori<0
                    grad_ori=grad_ori+360;
                end
                obin=grad_ori/45;
                w=exp(-(c_rot * c_rot + r_rot * r_rot) / exp_den);
                hist=interp_hist_entry(hist,rbin,cbin,obin,grad_mag*w,d,36);
            end
        end
    end
end
