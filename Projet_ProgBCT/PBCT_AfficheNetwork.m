%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_AfficheNetwork                                         %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Create ROI groups if available in the dataset
%=============================================
set(Wid_NetworkDisplay, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;
clear regionStr
if isempty(groupageROI) == 0
    for i=1:size(groupageROI,2)/2
        regionStr(i).ind(1) = groupageROI(i*2-1);
        regionStr(i).ind(2) = groupageROI(i*2);
    end
    nbRegionStr = size(regionStr,2);
else
    nbRegionStr = 0;
end


% Load data from the Excel file and extract associated metadata
% Loading depends on the ModeCompare flag (default = 0)
% When set to 1, 2, or 3, it indicates a comparison between two result files,
% and ModeCompare corresponds to the sheet number in the Excel file
%===================================================================
if ModeCompare == 0
    numPage = 1;
else
    numPage = ModeCompare;
end
[numData, txtData] = xlsread(nomFicExcelCorr,numPage);
% Remove header row from the dataset

if ModeMonoBi == 1
    txtData = txtData(2:size(txtData,1),1:4);
else
    txtData = txtData(2:size(txtData,1),1:6);
end
nbLigne = size(txtData,1);
valCorMax = max(numData(:,1));
valCorMin = min(abs(numData(:,1)));

% Compute spatial positions of the structures on a circular layout

%===================================================
angle_interval = 360/nbStructure;
for i=1:nbStructure
    % Assign positions either on the right hemisphere (for bilateral mode)
    % or across the entire layout (for unilateral mode)

    %---------------------------------------------------------------
    angle = 90-i*angle_interval+angle_interval/2;
    tabPosRight(i,1) = cosd(angle) + 1;
    tabPosRight(i,2) = sind(angle) + 1;
    
    % Assign positions either on the left hemisphere (for bilateral mode)
    % or across the entire layout (for unilateral mode)
    %--------------------------------------------------------------------
    angle = 90+i*angle_interval-angle_interval/2;
    tabPosLeft(i,1) = cosd(angle) + 1;
    tabPosLeft(i,2) = sind(angle) + 1;
end

% Display network based on selected mode
%======================================
if ModeMonoBi == 1
    PBCT_AfficheNetwork_Mono;

else
    PBCT_AfficheNetwork_Bi;

end


% Enable menu option for degree matrix computation
%============================================
set(Wid_NetworkDisplay, 'BackgroundColor', PG_ColorBackG_Ok);
set(Wid_CalcMatriceDegres, 'Enable', 'on');

% Clear memory
%====================
clear valCorMax valCorMin nbLigne i angle angle_interval taillePoint
clear numData txtData tabPosRight tabPosLeft numPage
clear regionStr nbRegionStr
