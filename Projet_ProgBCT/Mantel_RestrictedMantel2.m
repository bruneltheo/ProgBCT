% This Matlab script has been developped by Jerome G. Prunier.

% Prunier J.G., Kaufmann B., Fenet S., Picard D., Pompanon F.,
% Joly P., Lena, J.P., 2013. Optimizing the trade-off between spatial and 
% genetic sampling efforts in patchy populations: towards a better assessment 
% of functional connectivity using an individual-based sampling scheme. 
% Molecular Ecology (accepted).

% Version history :
% - 02/03/14 : ==> new input parameters : you are know asked to provide the kind of permutation procedure (classical or restrited) and the kind of test (one-tailed or two-tailed) you intend to use

% This script can be used to perform simple and partial Mantel
% tests with restricted permutations.
%   typa : ''r'' for restricted permutations, ''c'' for classical permutations
%   tailed : '1' for a (positive) one-tailed test, '2' for a two-tailed
%   test.
%   npop :    number of independant sampled plots (individuals /
%   aggregates). If type='c', npop=size(DG,1).
%   nperm :   number of permutations
%   DG :      matrix of pairwise genetic distances (dependent  variable)
%   DE :      matrix of pairwise Euclidean distances (explanatory variable I)
%   DP :      matrix of pairwise effective distances (explanatory variable II)
%  
% If a pair of sites is associated with only one distance (one
% individual-base measure in the case of an ISS or one population-based measure
% in the case of a conventional PSS), the script performs standard permutations.
% If the matrix DP is not provided, the script performs a simple Mantel
% test. If the matrix DP is provided, the script performs a partial Mantel
% test with DE as a covariable.
% The script returns a correlation coefficient rr (based on the Pearson
% coefficient correlation in simple Mantel tests or the partial coefficient 
% correlation in the partial Mantel tests) and a one-tailed p-value p.

function [rr,p]=RestrictedMantel2(typa,tailed,npop,nperm,DG,DE,DP)        
    if typa=='r'
        tempini=DE(:,1);
        affini=NaN(size(tempini,1),1);
        aff=affini;
        temp1=tempini(1,1);
        affini(1,1)=temp1;
        for i=2:size(tempini,1)
            if tempini(i,1)~=tempini(i-1,1);
                affini(i,1)=tempini(i,1);
            end
        end
        affini(isnan(affini)==1)=[];
        if size(affini,1)~=npop
            error('Several pairs of populations may be separated by equal euclidean distances... Please, add a small amount of noise to initial coordinates and recalculate Euclidean distance matrix... Example: Transfom X-coordinates using the function { X=X+(normrnd(0,1)/10000) }')
        end
        for i=1:size(tempini,1)
            for j=1:size(affini,1)
                if tempini(i,1)==affini(j,1)
                    aff(i,1)=j;
                end
            end
        end
    else aff=(1:size(DE,1))';
    end
          
        if nargin==6
            pop=NaN(size(aff,1),2);
            pop(:,1)=aff;
            pop(:,2)=1:size(aff,1);
            veca=asvect(DG);
            vecb=asvect(DE);
                %Standardization :
            vec=vecb; 
            veca(vec==0)=[];
            vecb(vec==0)=[];
            no=length(veca);
            nveca=(veca-mean(veca));
            nvecb=(vecb-mean(vecb));
            sveca=sqrt(sum(nveca.^2)/(no-1));
            svecb=sqrt(sum(nvecb.^2)/(no-1));
            veca=nveca/sveca;
            vecb=nvecb/svecb;
                %Pearson correlation coefficient :
            nveca=(veca-mean(veca));
            nvecb=(vecb-mean(vecb));
            sveca=sqrt(sum(nveca.^2)/(no-1));
            svecb=sqrt(sum(nvecb.^2)/(no-1));
            rr = (nveca*nvecb')/((no-1)*sveca*svecb);
                %Permutations :            
            r = zeros(nperm, 1);
            popuni=unique(pop(:,1));
            for qsdf=1:nperm 
                pop3=randperm(size(unique(pop(:,1)),1))';
                tem1=pop(pop(:,1)==popuni(pop3(1,1)),:);
                for i=2:size(unique(pop(:,1)),1)
                    tem2=pop(pop(:,1)==popuni(pop3(i,1)),:);
                    tem1=[tem1;tem2];
                end
                DA=DG(tem1(:,2),tem1(:,2));
                avec=asvect(DA);
                avec(vec==0)=[];
                anvec=(avec-mean(avec));
                asvec=sqrt(sum(anvec.^2)/(no-1));
                avec=anvec/asvec;
                anvec=(avec-mean(avec));
                asvec=sqrt(sum(anvec.^2)/(no-1));
                r(qsdf,1)= (anvec*(nvecb)')/((no-1)*asvec*svecb); 
            end
            if tailed==2
                if rr>=0
                    p = (sum(r>=rr))/(nperm+1);   
                    else p = (sum(r<rr))/(nperm+1);
                end
            else
                p = (sum(r>=rr))/(nperm+1);   
            end
        else
            pop=NaN(size(aff,1),2);
            pop(:,1)=aff;
            pop(:,2)=1:size(aff,1);
            veca=asvect(DG);
            vece=asvect(DE);
            vec=vece;
            vecb=asvect(DP);             
                %Standardization :
            veca(vec==0)=NaN;
            vece(vec==0)=NaN;
            vecb(vec==0)=NaN;
            veca2=veca(isnan(veca)==0);
            vece2=vece(isnan(vece)==0);
            vecb2=vecb(isnan(vecb)==0);
            no=length(veca2);
            nveca=(veca-mean(veca2));
            nvece=(vece-mean(vece2));
            nvecb=(vecb-mean(vecb2));
            nveca2=nveca(isnan(nveca)==0);
            nvece2=nvece(isnan(nvece)==0);
            nvecb2=nvecb(isnan(nvecb)==0);
            sveca=sqrt(sum(nveca2.^2)/(no-1));
            svece=sqrt(sum(nvece2.^2)/(no-1));
            svecb=sqrt(sum(nvecb2.^2)/(no-1));
            veca=nveca/sveca;
            vece=nvece/svece;
            vecb=nvecb/svecb;      
                %Partial correlation coefficient :
            veca(vec==0)=NaN;
            vece(vec==0)=NaN;
            vecb(vec==0)=NaN;
            veca2=veca(isnan(veca)==0);
            vece2=vece(isnan(vece)==0);
            vecb2=vecb(isnan(vecb)==0);
            nveca=(veca-mean(veca2));
            nvece=(vece-mean(vece2));
            nvecb=(vecb-mean(vecb2));
            nveca2=nveca(isnan(nveca)==0);
            nvece2=nvece(isnan(nvece)==0);
            nvecb2=nvecb(isnan(nvecb)==0);
            sveca=sqrt(sum(nveca2.^2)/(no-1));
            svece=sqrt(sum(nvece2.^2)/(no-1));
            svecb=sqrt(sum(nvecb2.^2)/(no-1));
            rae = (nveca2*nvece2')/((no-1)*sveca*svece);
            rbe = (nvecb2*nvece2')/((no-1)*svecb*svece); 
            rab = (nveca2*nvecb2')/((no-1)*sveca*svecb);
            rr=(rab-rae*rbe)/(sqrt(1-rae^2)* sqrt(1-rbe^2));
                %Permutations : 
            intercept=mean(veca2)-rae*mean(vece2);
            residuals=veca-(intercept+rae*vece);
            DA=asmatr(residuals,DG); 
            r = zeros(nperm, 1);
            popuni=unique(pop(:,1));
            for qsdf = (1:nperm) 
                pop3=randperm(size(unique(pop(:,1)),1))';
                tem1=pop(pop(:,1)==popuni(pop3(1,1)),:);
                for i=2:size(unique(pop(:,1)),1)
                    tem2=pop(pop(:,1)==popuni(pop3(i,1)),:);
                    tem1=[tem1;tem2];
                end        
                DAp=DA(tem1(:,2),tem1(:,2));
                vecr=asvect(DAp);
                vecr2=vecr(isnan(vecr)==0);
                nvecr=(vecr-mean(vecr2));
                nvecr2=nvecr(isnan(nvecr)==0);
                svecr=sqrt(sum(nvecr2.^2)/(no-1));
                r1= (nvecr2*nvecb2')/(no*svecr*svecb); 
                r2= (nvecr2*nvece2')/(no*svecr*svece); 
                r(qsdf)=(r1-r2*rbe)/(sqrt(1-r2^2)* sqrt(1-rbe^2));
            end
            if tailed==2
                if rr>=0
                    p = (sum(r>=rr))/(nperm+1);   
                    else p = (sum(r<rr))/(nperm+1);
                end
            else 
                p = (sum(r>=rr))/(nperm+1);   
           end
        end
    
function vect=asvect(mat)
       m=size(mat,1);
        n=((m-1)*m)/2;
       k=1;
       vect=zeros(1,n);
       for i=(2:m)
           for j = (1:(i-1))
               vect(k)=mat(i,j);
               k=k+1;
           end
       end
       
function DR=asmatr(vect,mat)    
    Z=zeros(size(mat,1),size(mat,1));
    DR=zeros(size(mat,1),size(mat,1));
    for i=1:size(mat,1)
        for j=1:size(mat,1)
            Z(i,j)=sub2ind(size(mat),i,j);
        end
    end
    z=asvect(Z);
    for i=1:size(vect,2);
        DR(ind2sub(size(Z),z(i)))=vect(i);
    end
    Z=Z';
    z=asvect(Z);
    for i=1:size(vect,2);
        DR(ind2sub(size(Z),z(i)))=vect(i);
    end
        
