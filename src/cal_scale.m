function new=cal_scale(tfeat)
% tfeat=[newr,newc,newi,xi,Col,Row,oct]
    for i=1:length(tfeat)
        intvl=tfeat{i}(3)+tfeat{i}(4);
        tfeat{i}(8)=1.6*2^(tfeat{i}(7)+intvl/3);
        %tfeat=[newr,newc,newi,xi,Col,Row,oct,scl]
        tfeat{i}(9)=1.6*2^(intvl/3);
        %tfeat=[newr,newc,newi,xi,Col,Row,oct,scl,scl_oct]
    end
    new=tfeat;
end
