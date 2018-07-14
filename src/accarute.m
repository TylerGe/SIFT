function [realc,realr,pos,k]=accarute(pyr,oct,int,r,c)
    [h,w]=size(pyr{oct}{int});
    i=1;
    k=1;
    pos=[];
    D=0;dD=0;X=0;
    while i<6
        if int<2 || int>4 ||c<3 ||c>(w-2) ||r<3 ||r>(h-2)
            k=0;
            break
        end
        D=pyr{oct}{int}(r,c);
        mat(:,:,1)=pyr{oct}{int-1}(r-2:r+2,c-2:c+2);
        mat(:,:,2)=pyr{oct}{int}(r-2:r+2,c-2:c+2);
        mat(:,:,3)=pyr{oct}{int+1}(r-2:r+2,c-2:c+2);
        [dx,dy,dz]=gradient(mat);
        dD=[dx(3,3,2);dy(3,3,2);dz(3,3,2)];
        H=myhessian(pyr,oct,int,r,c);
        X=-H\dD;
        xr=X(1);
        xc=X(2);
        xi=X(3);
        if abs(xi)<0.5 && abs(xr)<0.5 && abs(xc)<0.5
            newr=r;
            newc=c;
            newi=int;
            break
        end
        if isnan(X(1)) || isnan(X(2)) ||isnan(X(3))
            k=0;
            break
        end
        c=c+round(xc);
        r=r+round(xr);
        int=int+round(xi);
        i=i+1;
    end
    contr=D+0.5*dD'*X;
    if abs(contr)<1.5
        k=0;
    end
    if i>=6
        k=0;
    end
    if k~=0 
        realc = round(( newc + xc ) * 2.0^(oct-2));    
        realr = round(( newr + xr ) * 2.0^(oct-2));
        pos=[newr,newc,newi,xi];
    else
        realc=0;
        realr=0;
    end
end
