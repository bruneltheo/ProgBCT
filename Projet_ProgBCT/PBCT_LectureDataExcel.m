%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_LectureDataExcel                                       %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Test Excel file opening
%==============================
flagDataOK = 0;
flagErreur = 0;
fid = fopen(nomFicData);
if fid == -1
	errordlg('The selected file cannot be found', 'Error', 'modal');
    flagErreur = 1;
    return;
else
    fclose(fid);
end

% Read Excel file and reorder data if necessary
%====================================================================
[TabNum, tmp1] = xlsread(nomFicData, 1, GroupeData);
[tmp2, NomStruct] = xlsread(nomFicData, 1, GroupeStr);

nbROI =  size(TabNum,2);
if nbROI ~= size(NomStruct,2)
	errordlg('The number of data columns does not correspond to the number of ROIs', 'Error', 'modal');
    flagErreur = 1;
    return;
end

% Reformat matrix and store original data in TabData
%=====================================================================
flagDataOK = 1;
nbStructure = size(NomStruct,2);
if ModeMonoBi == 1
    % Nothing special here...
    %--------------------------
    nbAnimal = size(TabNum,1);
    NomStructInit = NomStruct;
else

    % The number of animals is divided by 2 (data from both right and left sides)  
    % However, the number of structures is doubled
    %-------------------------------------------------------------
    nbAnimal = size(TabNum,1)/2;
    NomStruct = [NomStruct NomStruct];
    NomStructInit = NomStruct;
    for i=1:nbStructure
        NomStruct(i) = strcat(NomStruct(i),'_L');
        NomStruct(i+nbStructure) = strcat(NomStruct(i+nbStructure),'_R');
    end
    nbStructure = nbStructure*2;
end
TabData = [];
for i=1:nbAnimal
    for j=1:nbROI
        TabData(i,j) = TabNum(i,j);
        if ModeMonoBi == 2
            TabData(i,j+nbROI) = TabNum(i+nbAnimal,j);
        end
    end
end


% Clear memory
%====================
clear fid tmp1 tmp2 i j TabNum
