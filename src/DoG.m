function [pyr,imp]=DoG(img)
    img1 = img;
    S=3;
    sigma=1.6;
    sig_diff = sqrt( sigma * sigma - 0.5*0.5 * 4 ); 
    levels = floor(min(log(size(img)))/log(2)-2);
    %init image
    img1=imresize(img1,2,'bicubic');

%     f=fspecial('gaussian',[7,7],sig_diff);
%     img1=imfilter(img1,f,'replicate','same');
%     
    img1=mygaussian(img1,sig_diff);
    k=2^(1/S);
    sig(1)=sigma;
    sig(2)=sigma*sqrt(k*k-1);
    for i=3:S+3
        sig(i)=sig(i-1)*k;
    end
    for o=1:levels
        for i=1:6
            if o==1 && i==1
                imp{o}{i}=img1; 
            else
                if i==1
%                     imp{o}{i}=imresize(imp{o-1}{4},0.5,'nearest');
                    [h,w]=size(imp{o-1}{4});
                    imp{o}{i}=imp{o-1}{4}(1:2:h,1:2:w);
%                     figure
%                     imshow(uint8(imp{o}{i}));
                else
%                     f=fspecial('gaussian',[7,7],sig(i));
%                     imp{o}{i}=imfilter(imp{o}{i-1},f,'replicate','same');
                    imp{o}{i}=mygaussian(imp{o}{i-1},sig(i));
                end     
            end
        end
    end
    for o=1:levels
        for i=1:5
            pyr{o}{i}=imp{o}{i+1}-imp{o}{i};
        end
    end
%     for i=1:5
%         for j=1:6
%             figure
%             imshow(uint8(imp{i}{j}))
%         end
% % %         for j=1:5
% % %             figure
% % %             imshow(pyr{i}{j})
% % %         end
%     end
end
