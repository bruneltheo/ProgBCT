%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CreationDataDegre                                      %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
function [DataDegre] = PBCT_CreationDataDegre(nbStructure,NomStruct,txtData, numData)

nbLigne = size(txtData,1);
DataDegre = zeros(nbStructure);
for n=1:nbLigne
    ind1 = 0;
    ind2 = 0;
    struct1 = txtData(n,1);
    struct2 = txtData(n,2);
    for i=1:nbStructure
        if strcmp(struct1, NomStruct(i))
            ind1 = i;
        end
        if strcmp(struct2, NomStruct(i))
            ind2 = i;
        end
    end
    if ind1>0 && ind2>0
        if numData(n,1) > 0
            DataDegre(ind1, ind2) = 1;
            DataDegre(ind2, ind1) = 1;
        elseif numData(n,1) < 0
            DataDegre(ind1, ind2) = -1;
            DataDegre(ind2, ind1) = -1;
        end
    end
end

end
