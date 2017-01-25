function A = getsparse_revise(colorIm,ntscIm,edgeIm,cfeat,gfeat)

n=size(ntscIm,1); 
m=size(ntscIm,2);

imgSize=n*m;

nI=zeros(n,m,3);
nI(:,:,1)=ntscIm(:,:,1);

indsM=reshape([1:imgSize],n,m);
wd=1; 

len=0;
consts_len=0;
col_inds=zeros(imgSize*(2*wd+1)^2,1);
row_inds=zeros(imgSize*(2*wd+1)^2,1);
vals=zeros(imgSize*(2*wd+1)^2,1);
gvals=zeros(1,(2*wd+1)^2);
fvals=zeros(1,(2*wd+1)^2);
evals=zeros(1,(2*wd+1)^2);
for j=1:m
   for i=1:n
      consts_len=consts_len+1;
      
      if (~colorIm(i,j))    
          tlen=0;
          for ti=max(1,i-wd):min(i+wd,n)
              for tj=max(1,j-wd):min(j+wd,m)
                          
                  if (ti~=i)|(tj~=j)    
                      len=len+1;
                      tlen=tlen+1;
                      row_inds(len)= indsM(i,j);
                      col_inds(len)=indsM(ti,tj);
                  end;
              end;
          end;
          ttlen=0;
         
          gcur=0;
       
          for ii=max(1,i-wd):min(i+wd,n)
              for jj=max(1,j-wd):min(j+wd,m)
                  if (ii~=i)|(jj~=j)
                      ttlen=ttlen+1;
                      featdif3 = 0;
                      featdif4 = 0;
                      featdif5 = 0;
                      
                      featdif1 = abs(cfeat.resize_cfeat1(ii,jj)-gfeat.resize_gfeat1(ii,jj));
                      featdif2 = abs(cfeat.resize_cfeat2(ii,jj)-gfeat.resize_gfeat2(ii,jj));
                      featdif3 = abs(cfeat.resize_cfeat3(ii,jj)-gfeat.resize_gfeat3(ii,jj));
                      featdif4 = abs(cfeat.resize_cfeat4(ii,jj)-gfeat.resize_gfeat4(ii,jj));
                      featdif5 = abs(cfeat.resize_cfeat5(ii,jj)-gfeat.resize_gfeat5(ii,jj));
                      
                      ggfeat1=gfeat.resize_gfeat1(ii,jj);
                      ggfeat2=gfeat.resize_gfeat2(ii,jj);
                      ggfeat3=gfeat.resize_gfeat3(ii,jj);
                      ggfeat4=gfeat.resize_gfeat4(ii,jj);
                      ggfeat5=gfeat.resize_gfeat5(ii,jj);
                      ggfeat = (ggfeat1+ggfeat5)/2;
                      featdif =(featdif4+featdif4+featdif5)/3;
                      fvals(ttlen) = ggfeat;%featdif;
                      evals(ttlen)=double(edgeIm(ii,jj));
                      gvals(ttlen)=ntscIm(ii,jj,1);
                  else
                      ecur=double(edgeIm(i,j));
                      fcur = abs(cfeat.resize_cfeat1(i,j)-gfeat.resize_gfeat1(i,j));
                      gcur=ntscIm(i,j,1);
                  end;
              end
          end
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
          %{
          ecvars=mean((edge(1:tlen,1)-edgecur).^2);
          if (evars<0.000002)
              evars=0.000002;
          end;
          esig1=evars*0.6;
          e_vals(1:tlen)=exp(-(edge(1:tlen,1)-edgecur).^2/esig1*10);
          %}
          
          %g_vals=zeros(1,tlen);
          %{
          gvals(1+tlen) = gcur;
          gc_var=mean((gvals(1:tlen,1)-gcur).^2);
          gcsig=gc_var*0.6;
          mgv=min((gvals(1:tlen)-gcur).^2);
          if (gcsig<(-mgv/log(0.01)))
              gcsig=-mgv/log(0.01);
          end
          if (gvals<0.000002)
              gvals=0.000002;
          end;
         
          gvals(1:tlen)=exp(-(gvals(1:tlen,1)-gcur).^2/gcsig);
           %}
          %                     fvals1=zeros(1,tlen);
          %                     fvar=zeros(1,tlen);
          %                     for icnt=1:tlen
          %                         fvar(1,icnt)=mean((fvals(icnt,:)-featurecur).^2);
          %                         fseq=exp(-((fvals(icnt,:)-featurecur).^2)/fvar(1,icnt));
%                         fvals1(1,icnt)=sum(fseq);
%                     end;          
%                     fvals1=fvals1/sum(fvals1);
%                     fvals1=fvals1+0.000001;
            %fvals = zeros(1,tlen);
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
            %fvals(1:tlen)=fvals(1:tlen)/sum(fvals(1:tlen));
            %vals(len-tlen+1:len)=-gvals(1:tlen);
%{
            fvals1=zeros(1,tlen);
                    fvar=zeros(1,tlen);
                    for icnt=1:tlen
                        fvar(1,icnt)=mean((fvals(icnt,:)-featurecur).^2);
                   end;
                   fsig=sum(fvar)/tlen;
                    for icnt=1:tlen
                        fvals1(1,icnt)=exp(-sum((fvals(icnt,:)-featurecur).^2)/fsig);
                    end;
                    fvals1=fvals1/sum(fvals1);
                    fvals1=fvals1+0.000001;
%}
%                     if(tlen==8)
%                         if(fvals1(1)<0.000001 && fvals1(2)<0.000001 && fvals1(3)<0.000001)
%                             fvals1(1)=fvals1(1)+0.000001;
%                             fvals1(2)=fvals1(2)+0.000001;
%                             fvals1(3)=fvals1(3)+0.000001;
%                         end;
%                         if(fvals1(1)<0.000001 && fvals1(4)<0.000001 && fvals1(6)<0.000001)
%                             fvals1(1)=fvals1(1)+0.000001;
%                             fvals1(4)=fvals1(4)+0.000001;
%                             fvals1(6)=fvals1(6)+0.000001;
%                         end;
%                         if(fvals1(3)<0.000001 && fvals1(5)<0.000001 && fvals1(8)<0.000001)
%                             fvals1(3)=fvals1(3)+0.000001;
%                             fvals1(5)=fvals1(5)+0.000001;
%                             fvals1(8)=fvals1(8)+0.000001;
%                         end;
%                         if(fvals1(6)<0.000001 && fvals1(7)<0.000001 && fvals1(8)<0.000001)
%                             fvals1(6)=fvals1(6)+0.000001;
%                             fvals1(7)=fvals1(7)+0.000001;
%                             fvals1(8)=fvals1(8)+0.000001;
%                         end;
%                     end; 
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
                     %wvals=fvals1.*e_vals.*g_vals;
                    if(ecur>0)
                        wvals=gvals;
                    else
%                         if(sum(isnan(fvals1)==1)>=1)
%                             wvals=e_vals.*g_vals;
%                         else     
                            wvals=fvals.*evals;%.*gvals;
%                        end;
                    end;
                    
%                
                    wvals(1:tlen)=wvals(1:tlen)/sum(wvals(1:tlen)); 
                    vals(len-tlen+1:len)=-wvals(1:tlen);
      end
        
      len=len+1;
      row_inds(len)= indsM(i,j);
      col_inds(len)=indsM(i,j);
      vals(len)=1; 

   end
end
  
vals=vals(1:len);
col_inds=col_inds(1:len);
row_inds=row_inds(1:len);

A=sparse(row_inds,col_inds,vals,consts_len,imgSize);

end