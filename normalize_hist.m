function sift_descr=normalize_hist(hist)
    sift_descr=zeros(1,128);
    for i=1:4
        for j=1:4
            for k=1:8
                sift_descr((i-1)*32+(j-1)*8+k)=hist(i,j,k);
            end
        end
    end
    sift_descr=sift_descr/norm(sift_descr);
    for i=1:128
        if sift_descr(i)>0.2
            sift_descr(i)=0.2;
        end
    end
    sift_descr=sift_descr/norm(sift_descr);
    sift_descr=round(sift_descr*1000);
end