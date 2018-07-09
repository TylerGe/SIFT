function tfeat=cal_oris(tfeat,imp)
    bins=36;
    orifct=4.5;
    peakratio=0.8;
    n=length(tfeat);
    for i=1:n
        m=length(tfeat);
        ddata=tfeat{i};
        hist=ori_hist(imp{ddata(7)}{ddata(3)},ddata(1),ddata(2),round(orifct*ddata(9)),1.5*ddata(9));
        if hist==0
            continue
        end
        
        for j=1:3
            hist=smoothhist(hist);
        end
        [val,ind]=max(hist);
        %tfeat=[newr,newc,newi,xi,Col,Row,oct,scl,scl_oct,oribin]
        tfeat{i}(10)=ind;
        hist(ind)=0;
        if max(hist)>0.8*val
            [~,sec_ind]=max(hist);
            ddata(10)=sec_ind;
            tfeat{m+1}=ddata;
        end
        
    end
end%gauss
