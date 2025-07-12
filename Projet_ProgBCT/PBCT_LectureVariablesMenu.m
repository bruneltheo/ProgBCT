%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_LectureVariablesMenu                                   %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Retrieve menu values
%===========================
if strcmp(nomFicData,'') == 1
	errordlg('Please select a data file', 'Erreur', 'modal');
    flagDataOK = 0;
else
    GroupeData = Wid_CelData.String;
    GroupeStr  = Wid_CelNomS.String;
    ModeMonoBi = Wid_ModeMB.Value;
    titre = Wid_NomRes.String;
    stringTmp = get(Wid_SeuilTest, 'String');
    PG_SeuilTest = str2double(stringTmp);
    stringTmp = get(Wid_GroupageROI, 'String');
    groupageROI = str2num(stringTmp);
end

% Clear memory
%====================
clear stringTmp