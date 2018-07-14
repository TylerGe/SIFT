function [newH,ratio]=myransac(testx,truth)
    [leng,~]=size(testx);
    past=0;
    for i=1:2000
        inlier=0;
        ind=randperm(leng,4);
%         for j=1:8
%             pt(j)=testx(ind(i));
%         end
        for j=1:4
            x(j,1)=testx(ind(j),1);
            x(j,2)=testx(ind(j),2);
            x(j,3)=1;
            y(j,1)=truth(ind(j),1);
            y(j,2)=truth(ind(j),2);
            y(j,3)=1;
        end
        H=homographyget(x,y);
        for k=1:leng
            tx=testx(k,:)';
            ty=H*tx;
            truey=truth(k,:)';
            if norm(truey-ty)<10
                inlier=inlier+1;
            end
        end
        if inlier>past
            past=inlier;
            ratio=past/leng;
            newH=H;
        end
    end
    
end 