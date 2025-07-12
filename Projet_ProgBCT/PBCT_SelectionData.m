%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_SelectionData                                          %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Select file (with retrieval of previous selection)
%==============================================
DataFileOld = DataFile;
DataRepOld = DataRep;
[DataFile, DataRep]=uigetfile('*.xlsx');

% Check if selection is valid
%======================
if DataFile~=0
    % OK : New file
    nomFicData=[DataRep,DataFile];
    Wid_NomFicData.String = nomFicData;
    set(Wid_CalcMatriceCorr, 'BackgroundColor', PG_ColorBackG_NOk);
    set(Wid_NetworkDisplay, 'Enable', 'off');
    set(Wid_NetworkDisplay, 'BackgroundColor', PG_ColorBackG_NOk);
    set(Wid_CalcMatriceDegres, 'Enable', 'off');
    set(Wid_CalcMatriceDegres, 'BackgroundColor', PG_ColorBackG_NOk);
    set(Wid_LancementBCT, 'Enable', 'off');
    set(Wid_LancementBCT, 'BackgroundColor', PG_ColorBackG_NOk);
    set(Wid_LancementBootStrap, 'Enable', 'off');
    set(Wid_LancementBootStrap, 'BackgroundColor', PG_ColorBackG_NOk);
else
    % Annulation : reaffectation ancien
    DataFile = DataFileOld;
    DataRep = DataRepOld;
end

% Clear memory
%====================
clear DataFileOld DataRepOld
