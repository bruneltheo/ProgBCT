%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CompareResultats                                       %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Select the two files
%=============================
[DataFile1, DataRep1]=uigetfile([DataRep,'*_Corr.xlsx'], 'Selection of first file (correlation results)');
if DataFile1 == 0 return; end
[DataFile2, DataRep2]=uigetfile([DataRep,'*_Corr.xlsx'], 'Selection of the second file (correlation results)');
if DataFile2 == 0 return; end
nomFicExcelCorr1=[DataRep1,DataFile1];
nomFicExcelCorr2=[DataRep2,DataFile2];


% Load files and extract relevant data  
%=======================================================
[numData1, txtData1] = xlsread(nomFicExcelCorr1);
[numData2, txtData2] = xlsread(nomFicExcelCorr2);

% Remove header row
%==============================
if ModeMonoBi == 1
    txtData1 = txtData1(2:size(txtData1,1),1:4);
    txtData2 = txtData2(2:size(txtData2,1),1:4);
else
    txtData1 = txtData1(2:size(txtData1,1),1:6);
    txtData2 = txtData2(2:size(txtData2,1),1:6);
end
nbLigne1 = size(txtData1,1);
nbLigne2 = size(txtData2,1);

% Initialize variables
%==========================
txtDataCom = [];
numDataCom = [];
nbCom = 0;
txtDataDif1 = [];
numDataDif1 = [];
nbDif1 = 0;
txtDataDif2 = [];
numDataDif2 = [];
nbDif2 = 0;

% Test for shared values between 1 and the others
%=======================================================
for i=1:nbLigne1
    FlagCom = 0;
    for j=1:nbLigne2
        if strcmp(txtData1{i,1},txtData2{j,1}) && strcmp(txtData1{i,2},txtData2{j,2})
            FlagCom = 1;
            nbCom = nbCom+1;
            for k=1:4
                txtDataCom{nbCom,k} = txtData1{i,k};
            end
            for k=1:2
                numDataCom(nbCom,k) = (numData1(i,k)+numData2(j,k))/2;
            end
        end
    end
    if FlagCom == 0
        nbDif1 = nbDif1+1;
        for k=1:4
            txtDataDif1{nbDif1,k} = txtData1{i,k};
        end
        for k=1:2
            numDataDif1(nbDif1,k) = numData1(i,k);
        end
    end
end

% Test for different values between 2 and 1
%===========================================
for i=1:nbLigne2
    FlagCom = 0;
    for j=1:nbLigne1
        if strcmp(txtData1{j,1},txtData2{i,1}) && strcmp(txtData1{j,2},txtData2{i,2})
            FlagCom = 1;
        end
    end
    if FlagCom == 0
        nbDif2 = nbDif2+1;
        for k=1:4
            txtDataDif2{nbDif2,k} = txtData2{i,k};
        end
        for k=1:2
            numDataDif2(nbDif2,k) = numData2(i,k);
        end
    end
end


% Write data to Excel file according to selected mode  
% Sheet 1 = common part  
% Sheet 2 = part specific to the first file  
% Sheet 3 = part specific to the second file  
%=========================================================
nomFicExcelCorr = strcat(DataRep,'COMPARE','_Corr.xlsx');
if ModeMonoBi == 1
    DataExcel{1,1} = 'ROI1';
    DataExcel{1,2} = 'ROI2';
    DataExcel{1,3} = 'corr';
    DataExcel{1,4} = 'pvalue';
    xlswrite(nomFicExcelCorr, DataExcel, 1, 'A1');
    xlswrite(nomFicExcelCorr, txtDataCom, 1, 'A2');
    xlswrite(nomFicExcelCorr, numDataCom, 1, 'C2');
    xlswrite(nomFicExcelCorr, DataExcel, 2, 'A1');
    xlswrite(nomFicExcelCorr, txtDataDif1, 2, 'A2');
    xlswrite(nomFicExcelCorr, numDataDif1, 2, 'C2');
    xlswrite(nomFicExcelCorr, DataExcel, 3, 'A1');
    xlswrite(nomFicExcelCorr, txtDataDif2, 3, 'A2');
    xlswrite(nomFicExcelCorr, numDataDif2, 3, 'C2');
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
    xlswrite(nomFicExcelCorr, DataExcel, 2, 'A1');
    xlswrite(nomFicExcelCorr, txtDataDif1, 2, 'A2');
    xlswrite(nomFicExcelCorr, numDataDif1, 2, 'E2');
    xlswrite(nomFicExcelCorr, DataExcel, 3, 'A1');
    xlswrite(nomFicExcelCorr, txtDataDif2, 3, 'A2');
    xlswrite(nomFicExcelCorr, numDataDif2, 3, 'E2');
end
PBCT_RenommeFeuilleExcel(nomFicExcelCorr, 3, {'Commun', 'Specif1', 'Specif2'}, [1,2,3]);

% Read original Excel file to retrieve structure names  
% Reformat matrix and store original data in TabData
%=======================================================================
PBCT_LectureDataExcel;

% Compute and display the shared network
%======================================
titre_old = titre;
titre = 'COMMUN';
ModeCompare = 1;
PBCT_AfficheNetwork;
titre = titre_old;

% Compute and display the network Specific 1
%============================================
titre_old = titre;
titre = 'SPECIFIQUE_1';
ModeCompare = 2;
PBCT_AfficheNetwork;
titre = titre_old;

% Compute and display the network Specific 2
%============================================
titre_old = titre;
titre = 'SPECIFIQUE_2';
ModeCompare = 3;
PBCT_AfficheNetwork;
titre = titre_old;


% Clear memory
%====================
clear i j k titre_old tmp1 tmp2 DataExcel
clear DataFile1 DataRep1 nomFicExcelCorr1 nbLigne1
clear DataFile2 DataRep2 nomFicExcelCorr2 nbLigne2
clear nbCom FlagCom txtDataCom numDataCom
clear nbDif1 txtDataDif1 numDataDif1
clear nbDif2 txtDataDif2 numDataDif2

