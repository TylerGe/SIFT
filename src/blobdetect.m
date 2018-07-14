%blobdetect to find featrues and maxima is the matrix which every col is a
%featrue 


% function maxima = blobdetect(img)
%     
% end
function featlist=blobdetect(img)
%     img = imread('1.jpg');
    img=imresize(img,[612,816]);
    n=1;
    img=double(rgb2gray(img));
    [pyr,imp]=DoG(img);
    feat=detect_featrues(pyr,imp);
    for o=1:length(feat)
        for i=1:3
            if isempty(feat{o}{i})
                continue
            else
                [num,~]=size(feat{o}{i});
                for k=1:num
                    row=feat{o}{i}(k,1);
                    col=feat{o}{i}(k,2);
                    [newc,newr,pos,t]=accarute(pyr,o,i+1,row,col);
                    if t~=0
                        m=isedge(pyr,o,pos(3),pos(1),pos(2));
    %                     m=0;
                        if m==0
                            fdata=[pos,newc,newr,o];
                            tfeat{n}=fdata;
                            n=n+1;
                        end
                    end
                end
            end
        end
    end

    new=cal_scale(tfeat);
    tfeat=cal_oris(new,imp);
    n=1;
    for i=1:length(tfeat)
        pt=tfeat{i};
        if length(pt)<10
            continue
        end
        featlist{n}{1}=[pt(5),pt(6)];
        hist=descr_hist(imp{pt(7)}{pt(3)},pt(1),pt(2),10*(pt(10)-1),pt(9),4);
        sift_descr=normalize_hist(hist);
        featlist{n}{2}=sift_descr;
        n=n+1;
    end
    figure
    imshow(uint8(img))
    hold on
    for i=1:length(featlist)
        x=featlist{i}{1}(1);
        y=featlist{i}{1}(2);
        plot(x,y,'r+')
    end

end
%tfeat=[newr,newc,newi,xi,Col,Row,oct,scl,scl_oct,ori]
%newiispyri
% function sift_descr=normalize_hist(hist)
%     sift_descr=zeros(1,128);
%     for i=1:4
%         for j=1:4
%             for k=1:8
%                 sift_descr((i-1)*32+(j-1)*8+k)=hist(i,j,k);
%             end
%         end
%     end
%     sift_descr=sift_descr/norm(sift_descr);
%     for i=1:128
%         if sift_descr(i)>0.2
%             sift_descr(i)=0.2;
%         end
%     end
%     sift_descr=sift_descr/norm(sift_descr);
%     sift_descr=round(sift_descr*1000);
% end
% function hist=descr_hist(img,r,c,ori,scl,d)
%     [h,w]=size(img);
%     hist=zeros(4,4,8);
%     cos_t=cos(ori);
%     sin_t=sin(ori);
%     exp_den=d*d*0.5;
%     hist_width=3*scl;
%     radius=floor(hist_width*sqrt(2)*(d+1)*0.5+0.5);
%     kk=0;
%     for i=-radius:radius
%         for j=-radius:radius
%             
%             c_rot = ( j * cos_t - i * sin_t ) / hist_width;            
%             r_rot = ( j * sin_t + i * cos_t ) / hist_width; 
%             rbin = r_rot + d / 2 - 0.5;                         
%             cbin = c_rot + d / 2 - 0.5;
%             if rbin>0 && rbin<d-1 && cbin>0 && cbin<d-1 
% %                 && 1<r+i && r+i<h && 1<c+i && c+i<w
%                 kk=kk+1;
%                 [grad_mag,grad_ori]=calc_grad_mag_ori(img,r+i,c+j);
%                 grad_ori=grad_ori-ori;
%                 if grad_ori<0
%                     grad_ori=grad_ori+360;
%                 end
%                 obin=grad_ori/45;
%                 w=exp(-(c_rot * c_rot + r_rot * r_rot) / exp_den);
%                 hist=interp_hist_entry(hist,rbin,cbin,obin,grad_mag*w,d,36);
%             end
%             
%         end
%     end
% end
% function hist=interp_hist_entry(hist,rbin,cbin,obin,mag,d,n)
%     r0=floor(rbin);
%     c0=floor(cbin);
%     o0=floor(obin);
%     d_r=rbin-r0;
%     d_c=cbin-c0;
%     d_o=obin-o0;
% 
%     v_r1=mag*d_r;
%     v_r0=mag-v_r1;
%     v_rc11 = v_r1*d_c;
%     v_rc10 = v_r1 - v_rc11;  
%     v_rc01 = v_r0*d_c;
%     v_rc00 = v_r0 - v_rc01;  
%     v_rco111 = v_rc11*d_o;
%     v_rco110 = v_rc11 - v_rco111;  
%     v_rco101 = v_rc10*d_o;
%     v_rco100 = v_rc10 - v_rco101;  
%     v_rco011 = v_rc01*d_o;
%     v_rco010 = v_rc01 - v_rco011;  
%     v_rco001 = v_rc00*d_o;
%     v_rco000 = v_rc00 - v_rco001;
%     if o0==7
%         poso=1;
%     else
%         poso=o0+2;
%     end
%     hist(r0+1,c0+1,o0+1)=hist(r0+1,c0+1,o0+1)+v_rco000;
%     hist(r0+2,c0+1,o0+1)=hist(r0+2,c0+1,o0+1)+v_rco100;
%     hist(r0+1,c0+2,o0+1)=hist(r0+1,c0+2,o0+1)+v_rco010;
%     hist(r0+2,c0+2,o0+1)=hist(r0+2,c0+2,o0+1)+v_rco110;
%     hist(r0+1,c0+1,poso)=hist(r0+1,c0+1,poso)+v_rco001;
%     hist(r0+2,c0+1,poso)=hist(r0+2,c0+1,poso)+v_rco101;
%     hist(r0+1,c0+2,poso)=hist(r0+1,c0+2,poso)+v_rco011;
%     hist(r0+2,c0+2,poso)=hist(r0+2,c0+2,poso)+v_rco111;
% end
% function [mag,ori]=calc_grad_mag_ori(img,r,c)
%     dx=img(r,c+1)-img(r,c-1);
%     dy=img(r+1,c)-img(r-1,c);
%     mag=sqrt(dx*dx+dy*dy);
%     if dy<0
%         ori=(-atan(dy/dx)+pi/2)*180/pi+180;
%     else
%         ori=(-atan(dy/dx)+pi/2)*180/pi;
%     end
% end%gauss
% function tfeat=cal_oris(tfeat,imp)
%     bins=36;
%     orifct=4.5;
%     peakratio=0.8;
%     n=length(tfeat);
%     for i=1:n
%         m=length(tfeat);
%         ddata=tfeat{i};
%         hist=ori_hist(imp{ddata(7)}{ddata(3)},ddata(1),ddata(2),round(orifct*ddata(9)),1.5*ddata(9));
%         if hist==0
%             continue
%         end
%         
%         for j=1:3
%             hist=smoothhist(hist);
%         end
%         [val,ind]=max(hist);
%         %tfeat=[newr,newc,newi,xi,Col,Row,oct,scl,scl_oct,oribin]
%         tfeat{i}(10)=ind;
%         hist(ind)=0;
%         if max(hist)>0.8*val
%             [~,sec_ind]=max(hist);
%             ddata(10)=sec_ind;
%             tfeat{m+1}=ddata;
%         end
%         
%     end
% end%gauss
% function hist=smoothhist(hist)
%     prev=hist(36);
%     hist(37)=hist(1);
%     for i=1:36
%         tmp=hist(i);
%         hist(i)=0.25*prev+0.5*hist(i)+0.25*hist(i+1);
%         prev=tmp;
%     end
%     hist(37)=[];
% end
% function hist=ori_hist(img,r,c,rad,sigma)%gauss
%     exp_den=2*sigma*sigma;
%     hist=zeros(1,36);
%     [h,w]=size(img);
%     if r-rad<2 ||c-rad<2 || r+rad>h-1 || c+rad>w-1
%         hist=0;
%         return
%     end
%     for i=-rad:rad
%         for j=-rad:rad
%             rn=r+i;
%             cn=c+j;
%             dx=img(rn,cn+1)-img(rn,cn-1);
%             dy=img(rn+1,cn)-img(rn-1,cn);
%             w=exp(-(i*i+j*j)/exp_den);
%             mag=sqrt(dx*dx+dy*dy);
%             if dy<0
%                 ori=(-atan(dy/dx)+pi/2)*180/pi+180;
%             else
%                 ori=(-atan(dy/dx)+pi/2)*180/pi;
%             end
%             if isnan(ori)
%                 continue
%             end
%             
%             bin=floor(ori/10)+1;
%             if bin==37
%                 bin=1;
%             end
%             hist(bin)=hist(bin)+w*mag;
%         end
%     end
% end
% function new=cal_scale(tfeat)
% % tfeat=[newr,newc,newi,xi,Col,Row,oct]
%     for i=1:length(tfeat)
%         intvl=tfeat{i}(3)+tfeat{i}(4);
%         tfeat{i}(8)=1.6*2^(tfeat{i}(7)+intvl/3);
%         %tfeat=[newr,newc,newi,xi,Col,Row,oct,scl]
%         tfeat{i}(9)=1.6*2^(intvl/3);
%         %tfeat=[newr,newc,newi,xi,Col,Row,oct,scl,scl_oct]
%     end
%     new=tfeat;
% end
% function [pyr,imp]=DoG(img)
%     img1 = img;
%     S=3;
%     sigma=1.6;
%     sig_diff = sqrt( sigma * sigma - 0.5*0.5 * 4 ); 
%     levels = floor(min(log(size(img)))/log(2)-2);
%     %init image
%     img1=imresize(img1,2,'bicubic');
%     f=fspecial('gaussian',[7,7],sig_diff);
%     img1=imfilter(img1,f,'replicate','same');
%     
%     k=2^(1/S);
%     sig(1)=sigma;
%     sig(2)=sigma*sqrt(k*k-1);
%     for i=3:S+3
%         sig(i)=sig(i-1)*k;
%     end
%     for o=1:levels
%         for i=1:6
%             if o==1 && i==1
%                 imp{o}{i}=img1; 
%             else
%                 if i==1
% %                     imp{o}{i}=imresize(imp{o-1}{4},0.5,'nearest');
%                     [h,w]=size(imp{o-1}{4});
%                     imp{o}{i}=imp{o-1}{4}(1:2:h,1:2:w);
% %                     figure
% %                     imshow(uint8(imp{o}{i}));
%                 else
%                     f=fspecial('gaussian',[7,7],sig(i));
%                     imp{o}{i}=imfilter(imp{o}{i-1},f,'replicate','same');
%                 end     
%             end
%         end
%     end
%     for o=1:levels
%         for i=1:5
%             pyr{o}{i}=imp{o}{i+1}-imp{o}{i};
%         end
%     end
% %     for i=1:5
% %         for j=1:6
% %             figure
% %             imshow(uint8(imp{i}{j}))
% %         end
% % % %         for j=1:5
% % % %             figure
% % % %             imshow(pyr{i}{j})
% % % %         end
% %     end
% end
% function featrues=detect_featrues(pyr,imp)
% 
%     for o=1:6
%         for i=2:4
%             count=1;
%             plist=[];
%             [h,w]=size(pyr{o}{i});
%             rmax=imregionalmax(pyr{o}{i});
%             [maxr,maxc]=find(rmax==1);
%             rmin=imregionalmin(pyr{o}{i});
%             [minr,minc]=find(rmin==1);
%             for j=1:length(maxr)
%                 row=maxr(j);
%                 col=maxc(j);
%                 if row==1 ||row==h ||col==1 ||col==w
%                     continue
%                 end
%                 value=pyr{o}{i}(row,col);
%                 neigh1=pyr{o}{i-1}(row-1:row+1,col-1:col+1);
%                 neigh2=pyr{o}{i+1}(row-1:row+1,col-1:col+1);
%                 if all(neigh1(:)<value) && all(neigh2(:)<value)
%                     plist(count,1)=row;
%                     plist(count,2)=col;
%                     count=count+1;
%                 end
%             end
%             for j=1:length(minr)
%                 row=minr(j);
%                 col=minc(j);
%                 if row==1 ||row==h ||col==1 ||col==w
%                     continue
%                 end
%                 value=pyr{o}{i}(row,col);
%                 neigh1=pyr{o}{i-1}(row-1:row+1,col-1:col+1);
%                 neigh2=pyr{o}{i+1}(row-1:row+1,col-1:col+1);
%                 if all(neigh1(:)>value) && all(neigh2(:)>value)
%                     plist(count,1)=row;
%                     plist(count,2)=col;
%                     count=count+1;
%                 end
%             end
%             featrues{o}{i-1}=plist;
% %             if isnan(plist)
% %                 continue
% %             end
% %             figure
% %             imshow(imp{o}{1})
% %             hold on
% %             plot(plist(:,2),plist(:,1),'r+');
%         end
%     end
% end
% function [realc,realr,pos,k]=accarute(pyr,oct,int,r,c)
%     [h,w]=size(pyr{oct}{int});
%     i=1;
%     k=1;
%     pos=[];
%     D=0;dD=0;X=0;
%     while i<6
%         if int<2 || int>4 ||c<3 ||c>(w-2) ||r<3 ||r>(h-2)
%             k=0;
%             break
%         end
%         D=pyr{oct}{int}(r,c);
%         mat(:,:,1)=pyr{oct}{int-1}(r-2:r+2,c-2:c+2);
%         mat(:,:,2)=pyr{oct}{int}(r-2:r+2,c-2:c+2);
%         mat(:,:,3)=pyr{oct}{int+1}(r-2:r+2,c-2:c+2);
%         [dx,dy,dz]=gradient(mat);
%         dD=[dx(3,3,2);dy(3,3,2);dz(3,3,2)];
%         H=myhessian(pyr,oct,int,r,c);
%         X=-H\dD;
%         xr=X(1);
%         xc=X(2);
%         xi=X(3);
%         if abs(xi)<0.5 && abs(xr)<0.5 && abs(xc)<0.5
%             newr=r;
%             newc=c;
%             newi=int;
%             break
%         end
%         if isnan(X(1)) || isnan(X(2)) ||isnan(X(3))
%             k=0;
%             break
%         end
%         c=c+round(xc);
%         r=r+round(xr);
%         int=int+round(xi);
%         i=i+1;
%     end
%     contr=D+0.5*dD'*X;
%     if abs(contr)<2
%         k=0;
%     end
%     if i>=6
%         k=0;
%     end
%     if k~=0 
%         realc = round(( newc + xc ) * 2.0^(oct-2));    
%         realr = round(( newr + xr ) * 2.0^(oct-2));
%         pos=[newr,newc,newi,xi];
%     else
%         realc=0;
%         realr=0;
%     end
% end
% function m=isedge(pyr,oct,int,r,c)
%     val=pyr{oct}{int}(r,c);
%     dxx=pyr{oct}{int}(r+1,c)+pyr{oct}{int}(r-1,c)-2*val;
%     dyy=pyr{oct}{int}(r,c+1)+pyr{oct}{int}(r,c-1)-2*val;
%     dxy=(pyr{oct}{int}(r+1,c+1)-pyr{oct}{int}(r+1,c-1)-pyr{oct}{int}(r-1,c+1)+pyr{oct}{int}(r-1,c-1))/4.0;
%     tr=dxx+dyy;
%     det=dxx * dyy - dxy * dxy;
%     if tr * tr/det < ( 2 + 1.0 )*( 2 + 1.0 ) / 2 && det>0
%         a=tr * tr/det;
%         m=0;
%     else
%         m=1;
%     end
% end
% function H=myhessian(pyr,oct,int,r,c)
% 
%     mat(:,:,1)=pyr{oct}{int-1}(r-2:r+2,c-2:c+2);
%     mat(:,:,2)=pyr{oct}{int}(r-2:r+2,c-2:c+2);
%     mat(:,:,3)=pyr{oct}{int+1}(r-2:r+2,c-2:c+2);
%     [dx,dy,dz]=gradient(mat);
%     [ddx,dxdy,dxdz]=gradient(dx);
%     [dydx,ddy,dydz]=gradient(dy);
%     [dzdx,dzdy,ddz]=gradient(dz);
%     H=[ddx(3,3,2),dxdy(3,3,2),dxdz(3,3,2);
%         dydx(3,3,2),ddy(3,3,2),dydz(3,3,2);
%         dzdx(3,3,2),dzdy(3,3,2),ddz(3,3,2)];
% 
% end