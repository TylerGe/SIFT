img1 = imread('1.jpg');
img2 = imread('2.jpg');
img3 = imread('3.jpg');
img4 = imread('4.jpg');
img5 = imread('5.jpg');
featlist1=blobdetect(img1);
featlist2=blobdetect(img2);
featlist3=blobdetect(img3);
featlist4=blobdetect(img4);
featlist5=blobdetect(img5);
img1=imresize(img1,[612,816]);
img2=imresize(img2,[612,816]);
img3=imresize(img3,[612,816]);
img4=imresize(img4,[612,816]);
img5=imresize(img5,[612,816]);

[testx1,truth1]=mymatch(img1,img3,featlist1,featlist3);
[H1,ra1]=myransac(testx1,truth1);
[testx2,truth2]=mymatch(img2,img3,featlist2,featlist3);
[H2,ra2]=myransac(testx2,truth2);
[testx4,truth4]=mymatch(img4,img3,featlist4,featlist3);
[H4,ra4]=myransac(testx4,truth4);
[testx5,truth5]=mymatch(img5,img3,featlist5,featlist3);
[H5,ra5]=myransac(testx5,truth5);
% function [testx,truth]=mymatch(img1,img2,featlist1,featlist2)
%     m=length(featlist1);
%     n=length(featlist2);
%     k=1;
%     for i=1:m
%         descr1=featlist1{i}{2};
%         for j=1:n
%             descr2=featlist2{j}{2};
%             dist(j)=norm(descr1-descr2);
%         end
%         [val,ind]=min(dist);
%         dist(ind)=1000;
%         [sec_val,sec_ind]=min(dist);
%         if val>0.7*sec_val
%             val=1000;
%         end
%         valist(i)=val;
%         if val<600
%             pair{k}{1}=featlist1{i}{1};
%             pair{k}{2}=featlist2{ind}{1};
%             k=k+1;
%         end
%     end
%     miximg=[img1,img2];
%     [h,w,~]=size(img1);
%     figure
%     imshow(miximg)
%     hold on
%     for i=1:k-1
%         x1=pair{i}{1}(1);
%         y1=pair{i}{1}(2);
%         x2=pair{i}{2}(1);
%         y2=pair{i}{2}(2);
%         testx(i,1)=x1;
%         testx(i,2)=y1;
%         testx(i,3)=1;
%         truth(i,1)=x2;
%         truth(i,2)=y2;
%         truth(i,3)=1;
%         line([x1,x2+w],[y1,y2]);
%     end
%     
% end

% function hmerge_img(H,img1,img2)
%     [h1,w1]=size(img1);
%     [h2,w2]=size(img2);
%     lcorner=round(H*[0;0;1]);
%     dcorner=round(H*[0;h;1]);
%     merge_img=zeros()
% end
% function [newH,ratio]=myransac(testx,truth)
%     [leng,~]=size(testx);
%     past=0;
%     for i=1:1000
%         inlier=0;
%         ind=randperm(leng,4);
% %         for j=1:8
% %             pt(j)=testx(ind(i));
% %         end
%         for j=1:4
%             x(j,1)=testx(ind(j),1);
%             x(j,2)=testx(ind(j),2);
%             x(j,3)=1;
%             y(j,1)=truth(ind(j),1);
%             y(j,2)=truth(ind(j),2);
%             y(j,3)=1;
%         end
%         H=homographyget(x,y);
%         for k=1:leng
%             tx=testx(k,:)';
%             ty=H*tx;
%             truey=truth(k,:)';
%             if norm(truey-ty)<30
%                 inlier=inlier+1;
%             end
%         end
%         if inlier>past
%             past=inlier;
%             ratio=past/leng;
%             newH=H;
%         end
%     end
%     
% end 
% function H=homographyget(x,y)
% %y=Hx
%     ABB=[];
%     
%     for i=1:4
%         xi=x(i,:);
%         yi=y(i,:);
%         temp=Atran(xi,yi);
%         if isempty(ABB)
%             ABB=temp;
%         else
%             ABB=[ABB;temp];
%         end
%     end
%     [~,~,V]=svd(ABB);
%     [~,width]=size(V);
%     h=V(:,width);
%     n=norm(h);
%     h=h/n;
%     H=[h(1:3,1)';h(4:6,1)';h(7:9,1)'];
%     lambda=yi'\(H*xi');
%     H=H/lambda;
% end 
% function [x]=Atran(x,y)
%     x=[0,0,0,-x(1),-x(2),-x(3),y(2)*x(1),y(2)*x(2),y(2)*x(3);
%         x(1),x(2),x(3),0,0,0,-y(1)*x(1),-y(1)*x(2),-y(1)*x(3)];
% end 
% end