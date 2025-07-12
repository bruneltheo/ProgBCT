%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CompareNResultats                                      %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Select the two minimum files
%=====================================
[DataFileN, DataRepN]=uigetfile([DataRep,'*_Corr.xlsx'], 'Selection of 2 files minimum (correlation results)','MultiSelect', 'on');
if iscell(DataFileN)
    if size(DataFileN,2) <= 2
        msgbox('The number of Excel files selected must be greater than 2', 'Warning','error');
        return;
    end
else
    return;
end
nomFicExcelCorr = [];
nbFicN = size(DataFileN,2);
for n=1:nbFicN
    nomFicExcelCorr{n}=[DataRepN,DataFileN{n}];
end

% Load files and extract relevant data  
% Remove header row
%=======================================================
numData = [];
txtData = [];
for n=1:nbFicN
    [numData{n}, txtData{n}] = xlsread(nomFicExcelCorr{n});
    if ModeMonoBi == 1
        txtData{n} = txtData{n}(2:size(txtData{n},1),1:4);
    else
        txtData{n} = txtData{n}(2:size(txtData{n},1),1:6);
    end
    nbLigneN(n) = size(txtData{n},1);
end

% Initialize variables
%==========================
txtDataCom = [];
numDataCom = [];
nbCom = 0;

% Test for shared values between 1 and the others
%=================================================
for i=1:nbLigneN(1)
    FlagCom = 0;
    numDataComTmp(1) = 0;
    numDataComTmp(2) = 0;
    for n=2:nbFicN
        for j=1:nbLigneN(n)
            if strcmp(txtData{1}{i,1},txtData{n}{j,1}) && strcmp(txtData{1}{i,2},txtData{n}{j,2})
                FlagCom = FlagCom+1;
                for k=1:2
                    numDataComTmp(k) = numDataComTmp(k)+numData{n}(j,k);
                end
            end
        end
    end
    if FlagCom == nbFicN-1
    	nbCom = nbCom+1;
        for k=1:4
            txtDataCom{nbCom,k} = txtData{1}{i,k};
        end
        for k=1:2
            numDataCom(nbCom,k) = (numData{1}(i,k) + numDataComTmp(k))/nbFicN;
        end
    end
end


% Write data to Excel file according to selected mode  
% Sheet 1 = common part
%=========================================================
nomFicExcelCorr = strcat(DataRep,'COMPARE_N','_Corr.xlsx');
if Wid_ModeMB.Value == 1
    DataExcel{1,1} = 'ROI1';
    DataExcel{1,2} = 'ROI2';
    DataExcel{1,3} = 'corr';
    DataExcel{1,4} = 'pvalue';
    xlswrite(nomFicExcelCorr, DataExcel, 1, 'A1');
    xlswrite(nomFicExcelCorr, txtDataCom, 1, 'A2');
    xlswrite(nomFicExcelCorr, numDataCom, 1, 'C2');
else
    DataExcel{1,1} = 'ROI1';
    DataExcel{1,2} = 'ROI2';
    DataExcel{1,3} = 'hemisphere';
    DataExcel{1,4} = 'side';
    DataExcel{1,5} = 'corr';
    DataExcel{1,6} = 'pvalue';
    xlswrite(nomFicExcelCorr, DataExcel, 1, 'A1');
    xlswrite(nomFicExcelCorr, txtDataCom, 1, 'A2');
    xlswrite(nomFicExcelCorr, numDataCom, 1, 'E2');
end
PBCT_RenommeFeuilleExcel(nomFicExcelCorr, 1, {'Commun'}, [1]);

% Read original Excel file to retrieve structure names  
% Reformat matrix and store original data in TabData
%=======================================================================
PBCT_LectureDataExcel;

% Compute and display the common network
%======================================
titre_old = titre;
titre = 'COMMUN_N';
ModeCompare = 1;
PBCT_AfficheNetwork;
titre = titre_old;


%  Clear memory
%====================
clear i j k n titre_old tmp1 tmp2 DataExcel
clear DataFileN DataRepN nomFicExcelCorr nbLigneN
clear nbCom FlagCom txtDataCom numDataCom numDataComTmp

