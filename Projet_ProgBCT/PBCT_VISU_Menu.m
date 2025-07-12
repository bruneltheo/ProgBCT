%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PCBT_VISU_Menu                                              %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2023 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Create main window
%=============================
scrsz = get(groot,'ScreenSize');
WinH = 500;
WinL = 270;
fenetreVisuPSrealiste = figure('Position',[283 scrsz(4)-WinH-60 WinL WinH],...
                               'MenuBar', 'none', 'Name', 'Visu Pseudo-realsitic', 'NumberTitle','off',...
                               'Color', PG_ColorBackG, 'DoubleBuffer', 'on');
                        
% File menu bar and data file name
%=====================================================
strMenu.menuFile         = uimenu('Label','Fichiers');
strMenu.menuFileOpenCorr = uimenu(strMenu.menuFile, 'Label', 'Loading a data file "*_Corr.xlsx" ou "*_Score.xlsx"',...
                                  'callback',('PBCT_VISU_LoadData'));
decV = 30;
Wid_VisuAffichage = uicontrol(fenetreVisuPSrealiste, 'Style', 'pushbutton', 'Position', [10 WinH-decV 250 20], 'HorizontalAlignment', 'center', ...
                              'BackgroundColor', [0 0 0.6], 'ForegroundColor', [1 1 1], 'String', 'Display update', ...
                              'callback', 'PBCT_VISU_Affichage', 'Enable', 'on');

% Buttons for figure selection (on/off)
%=======================================
decV = decV+25;
Wid_toggleVisuIntraL = uicontrol(fenetreVisuPSrealiste, 'Style', 'togglebutton', 'Position', [10 WinH-decV 12 12],...
                                 'BackgroundColor', [0 1 0], 'Value', 0, 'String', ' ', 'callback', 'PBCT_VISU_Affichage');
WA_label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [28 WinH-decV-7 250 20], 'HorizontalAlignment', 'left', ...
                     'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Visu Intra Left');
decV = decV+18;
Wid_toggleVisuIntraR = uicontrol(fenetreVisuPSrealiste, 'Style', 'togglebutton', 'Position', [10 WinH-decV 12 12],...
                                 'BackgroundColor', [0 1 0], 'Value', 0, 'String', ' ', 'callback', 'PBCT_VISU_Affichage');
WA_label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [28 WinH-decV-7 250 20], 'HorizontalAlignment', 'left', ...
                     'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Visu Intra Right');
decV = decV+18;
Wid_toggleVisuInter = uicontrol(fenetreVisuPSrealiste, 'Style', 'togglebutton', 'Position', [10 WinH-decV 12 12],...
                                 'BackgroundColor', [0 1 0], 'Value', 0, 'String', ' ', 'callback', 'PBCT_VISU_Affichage');
WA_label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [28 WinH-decV-7 250 20], 'HorizontalAlignment', 'left', ...
                     'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Visu Inter');

% Visualization parameters
%=================
decV = decV+35;
stringTmp = sprintf('%d', PG_VISU_Rayon);
Wid_Visu_Rayon = uicontrol(fenetreVisuPSrealiste, 'Style', 'edit', 'Position', [10 WinH-decV 60 20], 'String', stringTmp, ...
                          'callback', ('stringTmp = get(Wid_Visu_Rayon, ''String''); PG_VISU_Rayon = str2double(stringTmp);'));
Wid_Label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [75 WinH-decV-3 250 20], 'HorizontalAlignment', 'left', ...
                      'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Rayon des structures');
decV = decV+18;
Wid_toggleVisuAllStr = uicontrol(fenetreVisuPSrealiste, 'Style', 'togglebutton', 'Position', [10 WinH-decV 12 12],...
                                 'BackgroundColor', [0 0.5 0], 'Value', PG_VISU_FlagAllStruct, 'String', ' ',...
                                 'callback', 'PG_VISU_FlagAllStruct=Wid_toggleVisuAllStr.Value; PBCT_VISU_Affichage');
WA_label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [28 WinH-decV-7 250 20], 'HorizontalAlignment', 'left', ...
                     'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Display all referenced structures');
decV = decV+18;
Wid_toggleVisuNomStr = uicontrol(fenetreVisuPSrealiste, 'Style', 'togglebutton', 'Position', [10 WinH-decV 12 12],...
                                 'BackgroundColor', [0 0.5 0], 'Value', PG_VISU_FlagNomStruct, 'String', ' ',...
                                 'callback', 'PG_VISU_FlagNomStruct=Wid_toggleVisuNomStr.Value; PBCT_VISU_Affichage');
WA_label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [28 WinH-decV-7 250 20], 'HorizontalAlignment', 'left', ...
                     'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Display structure names');
decV = decV+18;
Wid_toggleVisuLienStr = uicontrol(fenetreVisuPSrealiste, 'Style', 'togglebutton', 'Position', [10 WinH-decV 12 12],...
                                 'BackgroundColor', [0 0.5 0], 'Value', PG_VISU_FlagLienStruct, 'String', ' ',...
                                 'callback', 'PG_VISU_FlagLienStruct=Wid_toggleVisuLienStr.Value; PBCT_VISU_Affichage');
WA_label = uicontrol(fenetreVisuPSrealiste, 'Style', 'text', 'Position', [28 WinH-decV-7 250 20], 'HorizontalAlignment', 'left', ...
                     'BackgroundColor', PG_ColorBackG, 'ForegroundColor', PG_ColorForeG, 'String', 'Display links between structures');
                 
                 
% Read reference files then initialize plotting
%===============================================================
PBCT_VISU_LoadReferences;
if flagErreur == 1
    errordlg({'One or more errors have occurred', 'Update the reference files, then restart the program'}, 'Error');
    Wid_VisuAffichage.Enable = 'off';
end
DefStrIntraL.nbConnect = 0;
DefStrIntraR.nbConnect = 0;
DefStrInter.nbConnect = 0;

                 
% Clear memory
%====================
clear scrsz WinH WinL decV WA_label ans stringTmp
