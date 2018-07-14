function H=homographyget(x,y)
%y=Hx
    ABB=[];
    
    for i=1:4
        xi=x(i,:);
        yi=y(i,:);
        temp=Atran(xi,yi);
        if isempty(ABB)
            ABB=temp;
        else
            ABB=[ABB;temp];
        end
    end
    [~,~,V]=svd(ABB);
    [~,width]=size(V);
    h=V(:,width);
    n=norm(h);
    h=h/n;
    H=[h(1:3,1)';h(4:6,1)';h(7:9,1)'];
    lambda=yi'\(H*xi');
    H=H/lambda;
end 