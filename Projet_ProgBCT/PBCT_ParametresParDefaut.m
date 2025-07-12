%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_ParametresParDefaut                                    %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Default data to analyze
%================================
% Name of the original data file: directory and Excel filename
DataRep = 'C:\';
DataFile = 'C:\';
% Cells to read: structure names followed by data table

GroupeStr = 'E1:AE1';
GroupeData = 'E2:AE17';
% Generic name for result files
titre = 'X';

% Parameters related to the data to be analyzed
%========================================
% Laterality mode: 1 = Mono Unilateral (1 hemisphere), 2 = Bi Bilateral (2 hemispheres)
ModeMonoBi = 2;
% Correlation type: 1 = Pearson / 2 = Spearman
TypeCorr = 1;
% Threshold for statistical tests
PG_SeuilTest = 0.01;
PG_SeuilScore = 1;
% Maximum number of structures to remove
    % Set PG_MaxStructFlag = 0 to remove all structures  
    % Set PG_MaxStructFlag = 1 to remove only PG_MaxStructSuppr structures
PG_MaxStructFlag = 0;   
PG_MaxStructSuppr = 10;
PG_NbSupprStrAleatoire = 3;

% Mantel test
%================
PG_NbIterationMantel = 100000;   % Maximum number of iterations
PG_ColorTypeMantel = 2;          % Color scale: 1 = bicolor, 2 = mono red 


% Brain files used for "realistic" visualization
%======================================================
NomFicVisuImgIntraL = '.\Mice_Brain_Left.png';
NomFicVisuDefIntraL = '.\Mice_Brain_Left.xlsx';
NomFicVisuImgIntraR = '.\Mice_Brain_Right.png';
NomFicVisuDefIntraR = '.\Mice_Brain_Right.xlsx';
NomFicVisuImgInter = '.\Mice_Brain_Inter.png';
NomFicVisuDefInter = '.\Mice_Brain_Inter.xlsx';
PG_VISU_Rayon = 10;
PG_VISU_TailleTxt = 8;
PG_VISU_FlagNomStruct = 1;
PG_VISU_FlagAllStruct = 0;
PG_VISU_FlagLienStruct = 1;

% General parameters for the different visualizations
%=========================================================
PG_AfficheEchelles = false;             % Display flag for correlation matrix scales 
PG_AfficheMatriceDegres = true;         % Display flag for degree matrix  
PG_couleurGriseDeFond = 32;             % Gray level for lower diagonal (0 to 64 – black to white)  
PG_couleurGriseImage = 32;              % Gray level for map background (0 to 64 – black to white)
                                        % or -1 for gradient based on 'r'  
PG_flagVisuNetwork_cercle = false;      % Circle visualization flag  
PG_flagVisuNetwork_groupesROI = true;   % ROI grouping visualization flag  
PG_rayon = 2;                           % Circle radius  
PG_coefRayonTxt = 1.1;                  % Text offset (structure names)  
PG_coefTaillePoint = 100;               % Size coefficient for plotting points (inversely proportional) 
PG_coefEpaisseurLigne = 3;              % Line thickness coefficient  
PG_tailleTxtStr = 10;                   % Text size for structure names  
PG_tailleTxtTitre = 10;                 % Text size for group title  
PG_coefTailleDensite = 5;               % Size coefficient for plotting densities (inversely proportional)

% Grouping of regions
%======================
groupageROI = [1 5 6 8 9 14];
PG_coefRayonReg = 1.08;                 % Spacing for the ROI group line  
PG_coefRepereReg = 0.08;                % Coefficient defining the size of the marker for ROI groups  
PG_colorReg = [0.5 0.5 0.5];            % Color of ROI groups  
PG_angleOffsetReg = 3;                  % Angular offset for start/end markers of ROI groups

% Parameters for BCT (Brain Connectivity Toolbox) procedures
%====================================
PG_MaxRandom = 1000;                    % Maximum number of randomizations

