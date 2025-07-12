%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_VISU_LoadData                                         %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2023 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Select data file
%=================================
[DataFileVISU, DataRepVISU]=uigetfile([DataRep,'*_Corr.xlsx;*_Score.xlsx'], 'File selection (correlations)');
if DataFileVISU == 0 return; end

% Read file and extract relevant data
%=======================================================
nomFicExcelCorrVISU=[DataRepVISU,DataFileVISU];
[numDataVISU, txtDataVISU] = xlsread(nomFicExcelCorrVISU, 1);

% Check size to determine unilateral (mono) or bilateral mode
%=========================================================
if size(txtDataVISU,2) == 4 && ModeMonoBi == 2
    warndlg({'The loaded file seems to be in Mono-lateral mode!',...
             'Change the interface mode to display the results'}, 'Error');
    return;
end
if size(txtDataVISU,2) == 6 && ModeMonoBi == 1
    warndlg({'The loaded file seems to be in Bi-lateral mode!',...
             'Change the interface mode to display the results'}, 'Error');
    return;
end

% Remove header row
%==============================
if ModeMonoBi == 1
    txtDataVISU = txtDataVISU(2:size(txtDataVISU,1),1:4);
else
    txtDataVISU = txtDataVISU(2:size(txtDataVISU,1),1:6);
end
nbLigneVISU = size(txtDataVISU,1);


% Check if structures are present in the reference files  
% Fill flagDataVisu to show or hide corresponding data rows
%=======================================================================
refNonPresente = 0;
flagDataVisu = zeros(nbLigneVISU,1);
for n=1:nbLigneVISU
    switch txtDataVISU{n,4}
        % Cas Bi-latéral INTRA LEFT
        case 'left'
            str1 = txtDataVISU{n,1}; ok1 = 0;
            str2 = txtDataVISU{n,2}; ok2 = 0;
            for i=1:DefStrIntraL.Nb
                nomComplet = DefStrIntraL.nom{i};
                if nomComplet(end-1:end) ~= '_L'
                    nomComplet = [DefStrIntraL.nom{i}, '_L'];
                end
                if strcmpi(nomComplet, str1) ok1 = 1; end
                if strcmpi(nomComplet, str2) ok2 = 1; end
            end
            if (ok1 && ok2) flagDataVisu(n) = 1;
            else            refNonPresente = 1;
            end
        % Mono/unilateral case : INTRA RIGHT
        case 'right'
            str1 = txtDataVISU{n,1}; ok1 = 0;
            str2 = txtDataVISU{n,2}; ok2 = 0;
            for i=1:DefStrIntraR.Nb
                nomComplet = DefStrIntraR.nom{i};
                if nomComplet(end-1:end) ~= '_R'
                    nomComplet = [DefStrIntraR.nom{i}, '_R'];
                end
                if strcmpi(nomComplet, str1) ok1 = 1; end
                if strcmpi(nomComplet, str2) ok2 = 1; end
            end
            if (ok1 && ok2) flagDataVisu(n) = 1;
            else            refNonPresente = 1;
            end
        % Bilateral case : INTER
        case 'null'
%             str1 = txtDataVISU{n,1}; ok1 = 0;
%             str2 = txtDataVISU{n,2}; ok2 = 0;
%             ext1 = str1(end-1:end);
%             ext2 = str1(end-1:end);
%             for i=1:DefStrInter.Nb
%                 nomComplet1 = [DefStrInter.nom{i}, ext1];
%                 nomComplet2 = [DefStrInter.nom{i}, ext2];
%                 if strcmpi(nomComplet1, str1) ok1 = 1; end
%                 if strcmpi(nomComplet2, str2) ok2 = 1; end
%             end
%             if (ok1 && ok2) flagDataVisu(n) = 1;
%             else            refNonPresente = 1;
%             end
        % Mono/unilateral case (test on both left and right sides)
        otherwise
            str1 = txtDataVISU{n,1}; ok1 = 0; ok3 = 0;
            str2 = txtDataVISU{n,2}; ok2 = 0; ok4 = 0;
            for i=1:DefStrIntraL.Nb
                nomComplet = DefStrIntraL.nom{i};
                if strcmpi(nomComplet, str1) ok1 = 1; end
                if strcmpi(nomComplet, str2) ok2 = 1; end
            end
            for i=1:DefStrIntraR.Nb
                nomComplet = DefStrIntraR.nom{i};
                if strcmpi(nomComplet, str1) ok3 = 1; end
                if strcmpi(nomComplet, str2) ok4 = 1; end
            end
            if (ok1 && ok2 && ok3 && ok4) flagDataVisu(n) = 1;
            else                          refNonPresente = 1;
            end
    end
end
if refNonPresente == 1
	warndlg({'Some structures are not present in the', ...
             'references! They will therefore not be traced'}, 'Warning');
end


% Format data for graphical representation
%======================================================
DefStrIntraL.nbConnect = 0;
DefStrIntraL.tabConnect = [];
DefStrIntraR.nbConnect = 0;
DefStrIntraR.tabConnect = [];
DefStrInter.nbConnect = 0;
DefStrInter.tabConnect = [];
for n=1:nbLigneVISU
    if flagDataVisu(n) == 1
        switch txtDataVISU{n,4}
            % Bilateral INTRA LEFT case
            case 'left'
                str1 = txtDataVISU{n,1};
                str2 = txtDataVISU{n,2};
                for i=1:DefStrIntraL.Nb
                    nomComplet = DefStrIntraL.nom{i};
                    if nomComplet(end-1:end) ~= '_L'
                        nomComplet = [DefStrIntraL.nom{i}, '_L'];
                    end
                    if strcmpi(nomComplet, str1) ind1 = i; end
                    if strcmpi(nomComplet, str2) ind2 = i; end
                end
                DefStrIntraL.nbConnect = DefStrIntraL.nbConnect+1;
                DefStrIntraL.tabConnect(DefStrIntraL.nbConnect,1) = ind1;
                DefStrIntraL.tabConnect(DefStrIntraL.nbConnect,2) = ind2;
            % Bilateral INTRA RIGHT case
            case 'right'
                str1 = txtDataVISU{n,1};
                str2 = txtDataVISU{n,2};
                for i=1:DefStrIntraR.Nb
                    nomComplet = DefStrIntraR.nom{i};
                    if nomComplet(end-1:end) ~= '_R'
                        nomComplet = [DefStrIntraR.nom{i}, '_R'];
                    end
                    if strcmpi(nomComplet, str1) ind1 = i; end
                    if strcmpi(nomComplet, str2) ind2 = i; end
                end
                DefStrIntraR.nbConnect = DefStrIntraR.nbConnect+1;
                DefStrIntraR.tabConnect(DefStrIntraR.nbConnect,1) = ind1;
                DefStrIntraR.tabConnect(DefStrIntraR.nbConnect,2) = ind2;
            % Bilateral INTER case
            case 'null'
            % Mono/unilateral case (represent both left and right)
            otherwise
                str1 = txtDataVISU{n,1};
                str2 = txtDataVISU{n,2};
                for i=1:DefStrIntraL.Nb
                    nomComplet = DefStrIntraL.nom{i};
                    if strcmpi(nomComplet, str1) ind1 = i; end
                    if strcmpi(nomComplet, str2) ind2 = i; end
                end
                DefStrIntraL.nbConnect = DefStrIntraL.nbConnect+1;
                DefStrIntraL.tabConnect(DefStrIntraL.nbConnect,1) = ind1;
                DefStrIntraL.tabConnect(DefStrIntraL.nbConnect,2) = ind2;
                for i=1:DefStrIntraR.Nb
                    nomComplet = DefStrIntraR.nom{i};
                    if strcmpi(nomComplet, str1) ind1 = i; end
                    if strcmpi(nomComplet, str2) ind2 = i; end
                end
                DefStrIntraR.nbConnect = DefStrIntraR.nbConnect+1;
                DefStrIntraR.tabConnect(DefStrIntraR.nbConnect,1) = ind1;
                DefStrIntraR.tabConnect(DefStrIntraR.nbConnect,2) = ind2;
        end
    end
end

% Call display procedure
%===================================
PBCT_VISU_Affichage;

% Clear memory
%====================
clear n i str1 str2 ind1 ind2 ok1 ok2 nomComplet refNonPresente
clear DataFileVISU DataRepVISU nomFicExcelCorrVISU
clear txtDataVISU txtDataVISU nbLigneVISU

