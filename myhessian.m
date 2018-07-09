function H=myhessian(pyr,oct,int,r,c)

    mat(:,:,1)=pyr{oct}{int-1}(r-2:r+2,c-2:c+2);
    mat(:,:,2)=pyr{oct}{int}(r-2:r+2,c-2:c+2);
    mat(:,:,3)=pyr{oct}{int+1}(r-2:r+2,c-2:c+2);
    [dx,dy,dz]=gradient(mat);
    [ddx,dxdy,dxdz]=gradient(dx);
    [dydx,ddy,dydz]=gradient(dy);
    [dzdx,dzdy,ddz]=gradient(dz);
    H=[ddx(3,3,2),dxdy(3,3,2),dxdz(3,3,2);
        dydx(3,3,2),ddy(3,3,2),dydz(3,3,2);
        dzdx(3,3,2),dzdy(3,3,2),ddz(3,3,2)];

end