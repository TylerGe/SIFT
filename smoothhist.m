function hist=smoothhist(hist)
    prev=hist(36);
    hist(37)=hist(1);
    for i=1:36
        tmp=hist(i);
        hist(i)=0.25*prev+0.5*hist(i)+0.25*hist(i+1);
        prev=tmp;
    end
    hist(37)=[];
end
