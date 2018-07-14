
img_final=zeros(2000,4000);
sec_final=merge(img_final,H,img1,img3);
thr_final=merge(sec_final,H2,img2,img3);
fourth=merge(thr_final,H4,img4,img3);
finalcase=merge(fourth,H5,img5,img3);
function img_final=merge(img_final,H,img1,img3)
    [Rows ,Cols, d1] = size(img1);
    [fr,fc]=size(img_final);
    grayimg3=double(rgb2gray(img3));
    I_r=rgb2gray(img1);
    I_r=double(I_r);
    M=zeros(2000,3000);  
    X=zeros(3,1); 
    addi=[500;500;0];
    for i=1:Rows   
        for j=1:Cols    
            X = H*[j;i;1];  
            X=X/X(3);  
            new_c=X(1);  
            new_r=X(2);  

            new_r = round(new_r)+500;   
            new_c = round(new_c)+500;  

            if new_r<1 || new_c<1 || new_r >fr || new_c>fc  
                 continue
            end  
            M(new_r, new_c) = I_r(i,j);  

        end  
    end  

    % M = uint8(M);  
    for i=1:Rows %y  
        for j=1:Cols %x  
    %         b1=M(0,0);  
    %         b2=M(1,0)-M(0,0);  
    %         b3=M(0,1)-M(0,0);  
    %         b4=M(0,0)-M(1,0)-M(0,1)+M(1,1);  
    % %       M(j,i)=b1+b2*i+b3*j+b4*j*i;  
            X1 = H*[j;i;1];  
            X1=X1/X1(3);  


            b = fix(X1+addi);  
            if b(1)<1 || b(1)>fr-1 || b(2)<1 || b(2)>fc-1    
                continue;   
            end  
            k=X1+addi-b;  
            val=M(b(2), b(1))*(1-k(1))*(1-k(2)) ...  
            + M(b(2), b(1)+1)*k(1)*(1-k(2)) ...  
            + M(b(2)+1, b(1))*(1-k(1))*k(2) ...  
            + M(b(2)+1, b(1)+1)*k(2)*k(1);  
            X1=fix(X1);  
            img_final(b(2),b(1)) = (val+img_final(b(2),b(1)))/2;  

        end  
    end  
    for i=1:Rows
        for j=1:Cols
            if img_final(i+500,j+500)>0
               img_final(i+500,j+500)=(grayimg3(i,j)+img_final(i+500,j+500))/2;
            else
                img_final(i+500,j+500)=grayimg3(i,j);
            end

        end
    end
    img_final=uint8(img_final);  
    figure  
    imshow(img_final);
end