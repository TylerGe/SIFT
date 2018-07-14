function [testx,truth]=mymatch(img1,img2,featlist1,featlist2)
    m=length(featlist1);
    n=length(featlist2);
    k=1;
    for i=1:m
        descr1=featlist1{i}{2};
        for j=1:n
            descr2=featlist2{j}{2};
            dist(j)=norm(descr1-descr2);
        end
        [val,ind]=min(dist);
        dist(ind)=1000;
        [sec_val,sec_ind]=min(dist);
        if val>0.7*sec_val
            val=1000;
        end
        valist(i)=val;
        if val<600
            pair{k}{1}=featlist1{i}{1};
            pair{k}{2}=featlist2{ind}{1};
            k=k+1;
        end
    end
    miximg=[img1,img2];
    [h,w,~]=size(img1);
    figure
    imshow(miximg)
    hold on
    for i=1:k-1
        x1=pair{i}{1}(1);
        y1=pair{i}{1}(2);
        x2=pair{i}{2}(1);
        y2=pair{i}{2}(2);
        testx(i,1)=x1;
        testx(i,2)=y1;
        testx(i,3)=1;
        truth(i,1)=x2;
        truth(i,2)=y2;
        truth(i,3)=1;
        line([x1,x2+w],[y1,y2]);
    end
    
end
