%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PROGRAM ProgBCT (Brain Tool Connectivity)                 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Initialize of general variables
%====================================
close all;
clear all;

% Initialize of default parameters
%======================================
PG_ColorForeG = [0 0 0];
PG_ColorBackG = [0.8 0.8 0.8];
PG_ColorBackG_Ok = [0.5 1 0.5];
PG_ColorBackG_NOk = [1 0.5 0.0];
PG_ColorBackG_Calc = [0.8 0.8 1.0];
PBCT_ParametresParDefaut;
nomFicData=[DataRep,DataFile];
flagDataOK = 0;

% Create main window
%=============================
scrsz = get(groot,'ScreenSize');
WinH = 500;
WinL = 270;
fenetrePrincipale = figure('Position',[10 scrsz(4)-WinH-60 WinL WinH],...
                            'MenuBar', 'none', 'Name', 'ProgBCT - V1.0', 'NumberTitle','off',...
                            'Color', PG_ColorBackG, 'DoubleBuffer', 'on');
                        
% File menu bar and data file name
%=====================================================
strMenu.menuFile         = uimenu('Label','Files');
strMenu.menuFileOpenData = uimenu(strMenu.menuFile, 'Label', 'Data file selection',...
                                  'callback',('PBCT_SelectionData'));
strMenu.menuFileCompare  = uimenu(strMenu.menuFile, 'Label', 'Compare 2 results files (_Corr.xlsx) : similarity and difference',...
                                  'callback',('PBCT_CompareResultats'));
strMenu.menuFileCompareN = uimenu(strMenu.menuFile, 'Label', 'Compare N results files (_Corr.xlsx) : similarity only',...
                                  'callback',('PBCT_CompareNResultats'));
strMenu.menuFileCompareCorr = uimenu(strMenu.menuFile, 'Label', 'Compare 2 matrix of correlations (_Corr.mat) : diff rence and Mantel test',...
                                  'callback',('PBCT_CompareCorrelations'));
strMenu.menuFileQuit     = uimenu(strMenu.menuFile, 'Separator', 'on', 'Label', 'Quit',...
                                  'callback',('hFigIntraL.Visible=''off''; hFigIntraR.Visible=''off''; hFigInter.Visible=''off''; close all; clear all;'));
decV = 22;
Wid_NomFicData = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [10 WinH-decV WinL-10 20], 'HorizontalAlignment', 'left', ...
                           'BackgroundColor', PG_ColorBackG, 'ForegroundColor', [1 0 0], 'String', nomFicData);

% Cells to read (structure names and data) and Mono/unilateral, Bi/bilateral mode
%=========================================================================
decV = decV+35;
Wid_CelNomS = uicontrol(fenetrePrincipale, 'Style', 'edit', 'Position', [10 WinH-decV 60 20], 'String', GroupeStr);
Wid_label   = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [80 WinH-decV-3 250 20], 'HorizontalAlignment', 'left', ...
                        'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Range to read: names of ROI');
decV = decV+20;
Wid_CelData = uicontrol(fenetrePrincipale, 'Style', 'edit', 'Position', [10 WinH-decV 60 20], 'String', GroupeData);
Wid_label   = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [80 WinH-decV-3 250 20], 'HorizontalAlignment', 'left', ...
                        'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Range to read: data');
decV = decV+25;
Wid_ModeMB = uicontrol(fenetrePrincipale, 'Style', 'popup', 'String', {'Mono', 'Bi'}, 'Position', [10 WinH-decV 60 20], ...
                       'Value', ModeMonoBi, 'callback', ('ModeMonoBi = get(Wid_ModeMB, ''Value'');'));
Wid_Label = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [80 WinH-decV-3 250 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Laterality');

% Treshold value
%=================
decV = decV+23;
stringTmp = sprintf('%5.3f', PG_SeuilTest);
Wid_SeuilTest = uicontrol(fenetrePrincipale, 'Style', 'edit', 'Position', [10 WinH-decV 60 20], 'String', stringTmp, ...
                          'callback', ('stringTmp = get(Wid_SeuilTest, ''String''); PG_SeuilTest = str2double(stringTmp);'));
Wid_Label = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [80 WinH-decV-3 250 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Threshold test "correlation matrix"');
decV = decV+20;

decV = decV+24;
Wid_TypeCorr = uicontrol(fenetrePrincipale, 'Style', 'popup', 'String', {'Pearson', 'Spearman'}, 'Position', [10 WinH-decV 100 20], ...
                         'Value', TypeCorr, 'callback', ('TypeCorr = get(Wid_TypeCorr, ''Value'');'));
Wid_Label = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [120 WinH-decV-5 250 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Type of correlation');

% Nomenclature
%==============
decV = decV+22;
Wid_NomRes  = uicontrol(fenetrePrincipale, 'Style', 'edit', 'Position', [10 WinH-decV 100 20], 'String', titre);
Wid_label   = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [120 WinH-decV-3 250 20], 'HorizontalAlignment', 'left', ...
                        'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Result file name');

% Button to compute correlation matrix
%======================================
decV = decV+26;
Wid_Label = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [30 WinH-decV 240 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Matrix scale');
Wid_toggleEch = uicontrol(fenetrePrincipale, 'Style', 'togglebutton', 'Position', [10 WinH-decV+5 15 15], 'BackgroundColor', [0 1 0], ...
                         'Value', PG_AfficheEchelles, 'String', ' ', 'callback', ('PG_AfficheEchelles = 1-PG_AfficheEchelles;'));
decV = decV+20;
Wid_CalcMatriceCorr = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                                'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'Correlation matrix', ...
                                'callback', ('PBCT_LectureVariablesMenu; PBCT_CalcMatriceCorr;'));
                            
% ROI grouping and visualization button
%===============================================
decV = decV+22;
Wid_Label = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [10 WinH-decV 350 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Group of ROIs (complete the list)');
decV = decV+20;
Wid_GroupageROI = uicontrol(fenetrePrincipale, 'Style', 'edit', 'Position', [10 WinH-decV+5 250 20], 'HorizontalAlignment', 'left', ...
                            'String', num2str(groupageROI), ...
                            'callback', ('stringTmp = get(Wid_GroupageROI, ''String''); groupageROI = str2num(stringTmp);'));
decV = decV+20;
Wid_Label = uicontrol(fenetrePrincipale, 'Style', 'text', 'Position', [30 WinH-decV 240 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Group of ROIs');
Wid_toggleROI = uicontrol(fenetrePrincipale, 'Style', 'togglebutton', 'Position', [10 WinH-decV+5 15 15], 'BackgroundColor', [0 1 0], ...
                         'Value', PG_flagVisuNetwork_groupesROI, 'String', ' ', 'callback', ('PG_flagVisuNetwork_groupesROI = 1-PG_flagVisuNetwork_groupesROI;'));
                     
% NetworkDisplay, CalcMatriceDegre and LancementBCT buttons
%=========================================================
decV = decV+20;
Wid_NetworkDisplay = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                               'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'Draw network', ...
                               'callback', ('ModeCompare = 0; PBCT_AfficheNetwork;'), 'Enable', 'off');
decV = decV+22;
Wid_CalcMatriceDegres = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                                 'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'Matrix of degres', ...
                                 'callback', ('PBCT_CalcMatriceDegres;'), 'Enable', 'off');
decV = decV+22;
Wid_LancementBCT = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                             'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'BCT procedures', ...
                             'callback', ('PBCT_LancementBCT;'), 'Enable', 'off');
decV = decV+22;
Wid_LancementBootStrap = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                             'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'Bootstrap procedures', ...
                             'callback', ('PBCT_LancementBootstrap;'), 'Enable', 'off');

% Suppress animal or structure button
%=========================================
decV = decV+35;
Wid_SupprAnimal = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                            'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'Animal removals', ...
                            'callback', 'PBCT_ProcedureSupprAnimal', 'Enable', 'on');
decV = decV+22;
Wid_SupprStruc = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                            'BackgroundColor', PG_ColorBackG_NOk, 'ForegroundColor', PG_ColorForeG, 'String', 'ROI removals', ...
                            'callback', 'PBCT_ProcedureSupprStructure', 'Enable', 'on');

% Button to display pseudo-realistic visualization window
%=====================================================
% SUPPRIMER
% decV = decV+35;
% Wid_VisuPSrealiste = uicontrol(fenetrePrincipale, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
%                           'BackgroundColor', [0 0 0.6], 'ForegroundColor', [1 1 1], 'String', 'Visualsationp "Pseudo-r aliste"', ...
%                           'callback', 'PBCT_VISU_Menu', 'Enable', 'on');


% Prepare (create) pseudo-realistic visualization windows
%==============================================================
hFigIntraL = figure('Name', 'Visu Intra Left', 'NumberTitle', 'off', 'CloseRequestFcn', '');
hFigIntraL.Visible = 'off';
hFigIntraR = figure('Name', 'Visu Intra Right', 'NumberTitle', 'off', 'CloseRequestFcn', '');
hFigIntraR.Visible = 'off';
hFigInter = figure('Name', 'Visu Inter', 'NumberTitle', 'off', 'CloseRequestFcn', '');
hFigInter.Visible = 'off';

                      
% Clear memory
%====================
clear scrsz WinH WinL stringTmp Wid_Label decV


