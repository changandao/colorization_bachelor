function [rsI,colorsI]=getRI(colorI,t_edge,,lifetime,gI,rI)
    W=getW(colorIm,gI);
    lblInds=find(colorIm);

    b=zeros(size(W,1),1);
    b(lblInds)=gI(lblInds);
    rsI=W\b;    
    eI=gI-rsI;
%     if(sum(sum(eI.*eI))>thred)
%         
%     end;