%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CalcMatriceDegre                                       %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Load correlation data from Excel file
%================================================
set(Wid_CalcMatriceDegres, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;
[numData, txtData] = xlsread(nomFicExcelCorr);
% Remove header row
if ModeMonoBi == 1
    txtData = txtData(2:size(txtData,1),1:4); 
else
    txtData = txtData(2:size(txtData,1),1:6); 
end

% Fill matrix and save it in a .mat file  
% (structure containing the variable DegreData)
%===============================================
NomFicDegre = strcat(DataRep,titre,'_Degre.mat');
[DataDegre] = PBCT_CreationDataDegre(nbStructure,NomStruct,txtData, numData);
save(NomFicDegre, 'DataDegre');

% Display matrix if requested  
% ==============================
if PG_AfficheMatriceDegres
    refFig = figure('Name', 'Degrees', 'NumberTitle', 'off');
    axis ij
    axis equal
    axis off
    hold on;
    ImageFond = (DataDegre+1)*32;
    ImageFond = ind2rgb(ImageFond, gray(64));
    image(ImageFond);
    nomFicJPG = strcat(DataRep,titre,'_Degre.jpg');
    saveas(gcf,nomFicJPG);
end

% Enable menu option to compute the degree matrix
%============================================
set(Wid_CalcMatriceDegres, 'BackgroundColor', PG_ColorBackG_Ok);
set(Wid_LancementBCT, 'Enable', 'on');


% Clear memory
%====================
clear DataDegre ImageFond numData txtData
clear refFig nomFicJPG

