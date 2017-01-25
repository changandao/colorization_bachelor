function A = getsparse(superpixels,colorIm,ntscIm,edgeIm,cfeat,gfeat)

n=size(ntscIm,1); 
m=size(ntscIm,2);

imgSize=n*m;

nI=zeros(n,m,3);
nI(:,:,1)=ntscIm(:,:,1);

indsM=reshape([1:imgSize],n,m);

wd=1; 
len=0;
sumlen = 0;
col_inds=zeros(imgSize*(2*wd+1)^2,1);
row_inds=zeros(imgSize*(2*wd+1)^2,1);
vals=zeros(imgSize*(2*wd+1)^2,1);

spnum=max(superpixels(:));
for sp = 1:spnum
    
    consts_len=0;
    
    
    %evals=zeros(1,(2*wd+1)^2);
    
    
    spall = sum(superpixels(superpixels==sp))/sp;
    [sprows,spcols] = find(superpixels==sp);
    spinds = find(superpixels==sp);
    flag = superpixels==sp;
    rowend = max(sprows);
    colend = max(spcols);
    rowstart = min(sprows);
    colstart = min(spcols);
    sprow = rowend-rowstart+1;
    spcol = colend-colstart+1;
    for j = colstart:colend
        for i = rowstart:rowend
            if flag(i,j)
                consts_len = consts_len+1;
                sumlen = sumlen+1;
                if (~colorIm(i,j))
                    tlen = 0;
                    for ii=max(rowstart,i-wd):min(i+wd,rowend)
                        for jj=max(colstart,j-wd):min(j+wd,colend)
                            if flag(ii,jj)
                                gvals=zeros(1,(2*wd+1)^2);
                                fvals=zeros(1,(2*wd+1)^2);
                                evals=zeros(1,(2*wd+1)^2);
                                if (ii~=i)|(jj~=j)
                                    len=len+1;
                                    tlen=tlen+1;
                                    row_inds(len)= indsM(i,j);
                                    col_inds(len)=indsM(ii,jj);
                                    featdif1 = abs(cfeat.resize_cfeat1(ii,jj)-gfeat.resize_gfeat1(ii,jj));
                                    featdif2 = abs(cfeat.resize_cfeat2(ii,jj)-gfeat.resize_gfeat2(ii,jj));
                                    featdif3 = abs(cfeat.resize_cfeat3(ii,jj)-gfeat.resize_gfeat3(ii,jj));
                                    featdif4 = abs(cfeat.resize_cfeat4(ii,jj)-gfeat.resize_gfeat4(ii,jj));
                                    featdif5 = abs(cfeat.resize_cfeat5(ii,jj)-gfeat.resize_gfeat5(ii,jj));
                                    %featdif = (featdif1+featdif5)/2;
                                    featdif =featdif1;
                                    fvals(tlen) = featdif;
                                    evals(tlen)=double(edgeIm(ii,jj));
                                    gvals(tlen)=ntscIm(ii,jj,1);
                                else
                                    ecur=double(edgeIm(i,j));
                                    fcur = abs(cfeat.resize_cfeat1(i,j)-gfeat.resize_gfeat1(i,j));
                                    gcur=ntscIm(i,j,1);
                                end;
                            else
                                continue
                            end;
                        end;
                    end;
                    edge = evals';
                    if(tlen==8)
                        if(edge(2,1)>0 && edge(4,1)>0 && ecur==0 && edge(1,1)==0)
                            edge(1,1)=(edge(2,1)+edge(4,1))/2;
                        end;
                        if(edge(4,1)>0 && edge(7,1)>0 && ecur==0 && edge(6,1)==0)
                            edge(6,1)=(edge(4,1)+edge(7,1))/2;
                        end;
                        if(edge(2,1)>0 && edge(5,1)>0 && ecur==0 && edge(3,1)==0)
                            edge(3,1)=(edge(2,1)+edge(5,1))/2;
                        end;
                        if(edge(5,1)>0 && edge(7,1)>0 && ecur==0 && edge(8,1)==0)
                            edge(8,1)=(edge(5,1)+edge(7,1))/2;
                        end;
                    end;
                    
                    %%====edge process======%%
                    evals=edge';
                    evals(1+tlen) = ecur;
                    ec_var=mean((evals(1:tlen+1)-mean(evals(1:tlen+1))).^2);
                    ecsig=ec_var*0.6;
                    mgv=min((evals(1:tlen)-ecur).^2);
                    if (ecsig<(-mgv/log(0.01)))
                        ecsig=-mgv/log(0.01);
                    end
                    if (ecsig<0.000002)
                        ecsig=0.000002;
                    end
                    
                    evals(1:tlen)=exp(-(evals(1:tlen)-ecur).^2/ecsig*10);
                    
                    if(tlen==8)
                        if(evals(1)<0.000001 && evals(2)<0.000001 && evals(3)<0.000001)
                            evals(1)=evals(1)+0.000001;
                            evals(2)=evals(2)+0.000001;
                            evals(3)=evals(3)+0.000001;
                        end;
                        if(evals(1)<0.000001 && evals(4)<0.000001 && evals(6)<0.000001)
                            evals(1)=evals(1)+0.000001;
                            evals(4)=evals(4)+0.000001;
                            evals(6)=evals(6)+0.000001;
                        end;
                        if(evals(3)<0.000001 && evals(5)<0.000001 && evals(8)<0.000001)
                            evals(3)=evals(3)+0.000001;
                            evals(5)=evals(5)+0.000001;
                            evals(8)=evals(8)+0.000001;
                        end;
                        if(evals(6)<0.000001 && evals(7)<0.000001 && evals(8)<0.000001)
                            evals(6)=evals(6)+0.000001;
                            evals(7)=evals(7)+0.000001;
                            evals(8)=evals(8)+0.000001;
                        end;
                    end;
                    %%=====feature process======%%
                    fvals(tlen+1)=fcur;
                    fc_val=mean((fvals(1:tlen)-fcur).^2);
                    fcsig=fc_val*0.6;
                    
                    mgv=min((fvals(1:tlen)-fcur).^2);
                    if (fcsig<(-mgv/log(0.01)))
                        fcsig=-mgv/log(0.01);
                    end
                    
                    if (fcsig<0.000002)
                        fcsig=0.000002;
                    end
                    fvals(1:tlen)=exp(-(fvals(1:tlen)-fcur).^2/fcsig);
                    
                    %%=====gray proess======%%
                    gvals(tlen+1)=gcur;
                    gc_var=mean((gvals(1:tlen+1)-mean(gvals(1:tlen+1))).^2);
                    gcsig=gc_var*0.6;
                    mgv=min((gvals(1:tlen)-gcur).^2);
                    if (gcsig<(-mgv/log(0.01)))
                        gcsig=-mgv/log(0.01);
                    end
                    if (gcsig<0.000002)
                        gcsig=0.000002;
                    end
                    gvals(1:tlen)=exp(-(gvals(1:tlen)-gcur).^2/gcsig);
                    
                    %if(ecur>0)
                        %wvals=gvals;
                    %else
                        wvals=gvals.*evals;%fvals.*evals;%.*
                    %end;
                    
                    %wvals = fvals;
                    wvals(1:tlen)=wvals(1:tlen)/sum(wvals(1:tlen));
                    vals(len-tlen+1:len)=-wvals(1:tlen);
                end;
                
                len=len+1;
                row_inds(len)= indsM(i,j);
                col_inds(len)= indsM(i,j);
                vals(len)=1;
            else 
                continue
            end;
        end;
    end;

end;
vals=vals(1:len);
col_inds=col_inds(1:len);
row_inds=row_inds(1:len);

A=sparse(row_inds,col_inds,vals,sumlen,imgSize);

end