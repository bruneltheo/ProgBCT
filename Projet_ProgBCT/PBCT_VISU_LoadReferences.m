%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_VISU_LoadReferences                                    %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2023 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Initializations
%=================
flagErreur = 0;

% Test opening of various reference image files and definitions
%=========================================================================
fid = fopen(NomFicVisuImgIntraL);    % Reference image INTRA LEFT (background image)
if fid == -1
	errordlg({'The following INTRA LEFT reference image file is missing!', NomFicVisuImgIntraL}, 'Error');
    flagErreur = 1;
else fclose(fid);
end
fid = fopen(NomFicVisuDefIntraL);    % Definitions of INTRA LEFT structures (positions and colors)
if fid == -1
	errordlg({'The following INTRA LEFT reference Excel file is missing!', NomFicVisuDefIntraL}, 'Error');
    flagErreur = 1;
else fclose(fid);
end
fid = fopen(NomFicVisuImgIntraR);    % Reference image INTRA RIGHT (background image)
if fid == -1
	errordlg({'The following INTRA RIGHT reference image file is missing!', NomFicVisuImgIntraR}, 'Error');
    flagErreur = 1;
else fclose(fid);
end
fid = fopen(NomFicVisuDefIntraR);    % Definitions of INTRA RIGHT structures (positions and colors)
if fid == -1
	errordlg({'The following INTRA RIGHT reference Excel file is missing!', NomFicVisuDefIntraR}, 'Error');
    flagErreur = 1;
else fclose(fid);
end
% fid = fopen(NomFicVisuImgInter);    % Reference image INTER (background image)
% if fid == -1
% 	errordlg({'Le fichier image de référence INTER suivant n''est pas présent !', NomFicVisuImgInter}, 'Erreur');
%     flagErreur = 1;
% else fclose(fid);
% end
% fid = fopen(NomFicVisuDefInter);    % Definitions of INTER structures (positions and colors)
% if fid == -1
% 	errordlg({'Le fichier Excel de référence INTER suivant n''est pas présent !', NomFicVisuDefInter}, 'Erreur');
%     flagErreur = 1;
% else fclose(fid);
% end

% Read files if all checks pass
%=====================================
if flagErreur == 1
    return;
else
    % INTRA LEFT
    %------------
    imgIntraL = imread(NomFicVisuImgIntraL);
    [DefDataNumIntraL, DefDataTxtIntraL] = xlsread(NomFicVisuDefIntraL);
    DefStrIntraL.Nb = size(DefDataNumIntraL,1);
    for i=1:DefStrIntraL.Nb
        DefStrIntraL.nom(i) = DefDataTxtIntraL(i,1);
        DefStrIntraL.system(i) = DefDataTxtIntraL(i,4);
        DefStrIntraL.x(i) = DefDataNumIntraL(i,1);
        DefStrIntraL.y(i) = DefDataNumIntraL(i,2);
        DefStrIntraL.RVB(i,1) = DefDataNumIntraL(i,4)/256;
        DefStrIntraL.RVB(i,2) = DefDataNumIntraL(i,5)/256;
        DefStrIntraL.RVB(i,3) = DefDataNumIntraL(i,6)/256;
    end
    % INTRA RIGHT
    %-------------
    imgIntraR = imread(NomFicVisuImgIntraR);
    [DefDataNumIntraR, DefDataTxtIntraR] = xlsread(NomFicVisuDefIntraR);
    DefStrIntraR.Nb = size(DefDataNumIntraR,1);
    for i=1:DefStrIntraR.Nb
        DefStrIntraR.nom(i) = DefDataTxtIntraR(i,1);
        DefStrIntraR.system(i) = DefDataTxtIntraR(i,4);
        DefStrIntraR.x(i) = DefDataNumIntraR(i,1);
        DefStrIntraR.y(i) = DefDataNumIntraR(i,2);
        DefStrIntraR.RVB(i,1) = DefDataNumIntraR(i,4)/256;
        DefStrIntraR.RVB(i,2) = DefDataNumIntraR(i,5)/256;
        DefStrIntraR.RVB(i,3) = DefDataNumIntraR(i,6)/256;
    end
    % INTER
    %-------
%     imgInter = imread(NomFicVisuImgInter);
%     [DefDataNumInter, DefDataTxtInter] = xlsread(NomFicVisuDefInter);
%     DefStrInter.Nb = size(DefDataNumInter,1);
%     for i=1:DefStrInter.Nb
%         DefStrInter.nom(i) = DefDataTxtInter(i,1);
%         DefStrInter.system(i) = DefDataTxtInter(i,4);
%         DefStrInter.x(i) = DefDataNumInter(i,1);
%         DefStrInter.y(i) = DefDataNumInter(i,2);
%         DefStrInter.RVB(i,1) = DefDataNumInter(i,4)/256;
%         DefStrInter.RVB(i,2) = DefDataNumInter(i,5)/256;
%         DefStrInter.RVB(i,3) = DefDataNumInter(i,6)/256;
%     end
end

% Clear memory
%====================
clear fid i

