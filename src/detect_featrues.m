function featrues=detect_featrues(pyr,imp)

    for o=1:6
        for i=2:4
            count=1;
            plist=[];
            [h,w]=size(pyr{o}{i});
            rmax=imregionalmax(pyr{o}{i});
            [maxr,maxc]=find(rmax==1);
            rmin=imregionalmin(pyr{o}{i});
            [minr,minc]=find(rmin==1);
            for j=1:length(maxr)
                row=maxr(j);
                col=maxc(j);
                if row==1 ||row==h ||col==1 ||col==w
                    continue
                end
                value=pyr{o}{i}(row,col);
                neigh1=pyr{o}{i-1}(row-1:row+1,col-1:col+1);
                neigh2=pyr{o}{i+1}(row-1:row+1,col-1:col+1);
                if all(neigh1(:)<value) && all(neigh2(:)<value)
                    plist(count,1)=row;
                    plist(count,2)=col;
                    count=count+1;
                end
            end
            for j=1:length(minr)
                row=minr(j);
                col=minc(j);
                if row==1 ||row==h ||col==1 ||col==w
                    continue
                end
                value=pyr{o}{i}(row,col);
                neigh1=pyr{o}{i-1}(row-1:row+1,col-1:col+1);
                neigh2=pyr{o}{i+1}(row-1:row+1,col-1:col+1);
                if all(neigh1(:)>value) && all(neigh2(:)>value)
                    plist(count,1)=row;
                    plist(count,2)=col;
                    count=count+1;
                end
            end
            featrues{o}{i-1}=plist;
%             if isnan(plist)
%                 continue
%             end
%             figure
%             imshow(imp{o}{1})
%             hold on
%             plot(plist(:,2),plist(:,1),'r+');
        end
    end
end
