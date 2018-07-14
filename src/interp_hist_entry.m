function hist=interp_hist_entry(hist,rbin,cbin,obin,mag,d,n)
    r0=floor(rbin);
    c0=floor(cbin);
    o0=floor(obin);
    d_r=rbin-r0;
    d_c=cbin-c0;
    d_o=obin-o0;

    v_r1=mag*d_r;
    v_r0=mag-v_r1;
    v_rc11 = v_r1*d_c;
    v_rc10 = v_r1 - v_rc11;  
    v_rc01 = v_r0*d_c;
    v_rc00 = v_r0 - v_rc01;  
    v_rco111 = v_rc11*d_o;
    v_rco110 = v_rc11 - v_rco111;  
    v_rco101 = v_rc10*d_o;
    v_rco100 = v_rc10 - v_rco101;  
    v_rco011 = v_rc01*d_o;
    v_rco010 = v_rc01 - v_rco011;  
    v_rco001 = v_rc00*d_o;
    v_rco000 = v_rc00 - v_rco001;
    if o0==7
        poso=1;
    else
        poso=o0+2;
    end
    hist(r0+1,c0+1,o0+1)=hist(r0+1,c0+1,o0+1)+v_rco000;
    hist(r0+2,c0+1,o0+1)=hist(r0+2,c0+1,o0+1)+v_rco100;
    hist(r0+1,c0+2,o0+1)=hist(r0+1,c0+2,o0+1)+v_rco010;
    hist(r0+2,c0+2,o0+1)=hist(r0+2,c0+2,o0+1)+v_rco110;
    hist(r0+1,c0+1,poso)=hist(r0+1,c0+1,poso)+v_rco001;
    hist(r0+2,c0+1,poso)=hist(r0+2,c0+1,poso)+v_rco101;
    hist(r0+1,c0+2,poso)=hist(r0+1,c0+2,poso)+v_rco011;
    hist(r0+2,c0+2,poso)=hist(r0+2,c0+2,poso)+v_rco111;
end
