function hist=ori_hist(img,r,c,rad,sigma)%gauss
    exp_den=2*sigma*sigma;
    hist=zeros(1,36);
    [h,w]=size(img);
    if r-rad<2 ||c-rad<2 || r+rad>h-1 || c+rad>w-1
        hist=0;
        return
    end
    for i=-rad:rad
        for j=-rad:rad
            rn=r+i;
            cn=c+j;
            dx=img(rn,cn+1)-img(rn,cn-1);
            dy=img(rn+1,cn)-img(rn-1,cn);
            w=exp(-(i*i+j*j)/exp_den);
            mag=sqrt(dx*dx+dy*dy);
            if dy<0
                ori=(-atan(dy/dx)+pi/2)*180/pi+180;
            else
                ori=(-atan(dy/dx)+pi/2)*180/pi;
            end
            if isnan(ori)
                continue
            end
            
            bin=floor(ori/10)+1;
            if bin==37
                bin=1;
            end
            hist(bin)=hist(bin)+w*mag;
        end
    end
end
