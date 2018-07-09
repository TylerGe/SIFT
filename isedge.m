function m=isedge(pyr,oct,int,r,c)
    val=pyr{oct}{int}(r,c);
    dxx=pyr{oct}{int}(r+1,c)+pyr{oct}{int}(r-1,c)-2*val;
    dyy=pyr{oct}{int}(r,c+1)+pyr{oct}{int}(r,c-1)-2*val;
    dxy=(pyr{oct}{int}(r+1,c+1)-pyr{oct}{int}(r+1,c-1)-pyr{oct}{int}(r-1,c+1)+pyr{oct}{int}(r-1,c-1))/4.0;
    tr=dxx+dyy;
    det=dxx * dyy - dxy * dxy;
    if tr * tr/det < ( 4 + 1.0 )*( 4 + 1.0 ) / 4 && det>0
%         a=tr * tr/det;
        m=0;
    else
        m=1;
    end
end
