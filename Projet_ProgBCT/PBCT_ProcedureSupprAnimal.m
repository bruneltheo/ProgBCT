%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_ProcedureSupprAnimal                                   %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Check if data file exists
%===================================
PBCT_LectureVariablesMenu; 
if flagDataOK == 0
	errordlg('Please select a data file', 'Erreur', 'modal');
    return;
end

% Load original data returned in TabData
%========================================================
PBCT_LectureDataExcel;
if flagErreur == 1
    return;
end
set(Wid_SupprAnimal, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;

% Create output Excel file
%==================================
nomFicExcelSuppr = strcat(DataRep,titre,'_SUPPR_ANIMAUX.xlsx');
Entete = {'Nb', 'NumSuppr', 'MaxDeg', 'SumDeg', 'E', 'Mean_C', 'r', 'Trans', 'SumCorr'};
xlswrite(nomFicExcelSuppr, Entete, 1, 'A1');


% Recompute all parameters using all animals
%========================================================
hWait = waitbar(0,'Parameters calculation with all animals ...');

    % Pearson or Spearman test on original data
    %--------------------------------------------------
    if TypeCorr == 1  [rData,pData] = corr(TabData, 'Type', 'Pearson');
    else              [rData,pData] = corr(TabData, 'Type', 'Spearman');
    end

    % Generate thresholded data for Excel export
    %------------------------------------------------
    [nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
     numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
     = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructure,rData,pData,PG_SeuilTest,NomStruct);

    % Create degree matrix and compute node degrees
    %----------------------------------------------
    [DataDegre] = PBCT_CreationDataDegre(nbStructure,NomStruct,txtDataExcel,numDataExcel);
    AbsDataDegre = abs(DataDegre);
    DataUtil = AbsDataDegre;
    nbData = size(DataUtil,1);
    [deg] = degrees_und(DataUtil);
    BC = betweenness_bin(DataUtil);
    E=efficiency_bin(DataUtil,0);
    C=clustering_coef_bu(DataUtil);
    r = assortativity_bin(DataUtil,0);
    [Trans]=transitivity_bu(DataUtil);
    [Mcommunity,Qcommunity] = community_louvain(DataUtil,1);
    
    % Write values to Excel
    %---------------------------------
    VectValeurs = [];
    VectValeurs(1) = nbAnimal;
    VectValeurs(2) = 0;
    VectValeurs(3) = max(deg);
    VectValeurs(4) = sum(deg);
    VectValeurs(5) = E;
    VectValeurs(6) = mean(C);
    VectValeurs(7) = r;
    VectValeurs(8) = Trans;
    VectValeurs(9) = size(numDataExcel,1);
    xlswrite(nomFicExcelSuppr, VectValeurs, 1, 'A2');
    
    % Compute by systems if the file exists
    %------------------------------------------
    flagSystem = 0;
    DataFileSys = strrep(DataFile, '.xlsx', '_sys.xlsx');
    DataFileSys = [DataRep DataFileSys];
    fid = fopen(DataFileSys);
    if fid ~= -1
        % Read system file
        %~~~~~~~~~~~~~~~~~~~~~~~~
        flagSystem = 1;
        fclose(fid);
        [num txt] = xlsread(DataFileSys);
        % Fill structure system
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        tabSystem = [];
        tabSystem.nb = 0;
        tabSystem.nb = size(txt,2);
        for i=1:tabSystem.nb
            tabSystem.nomSys{i} = txt{1,i};
            tabSystem.nbStr(i) = 0;
            for j=2:size(txt,1)
                if ~isempty(txt{j,i})
                    tabSystem.nbStr(i) = tabSystem.nbStr(i)+1;
                    tabSystem.nomStr{i,j-1} = txt{j,i};
                end
            end
        end
        xlswrite(nomFicExcelSuppr, tabSystem.nomSys, 1, 'M1');
    end
    
    % Compute degrees by system
    %------------------------------
    if flagSystem == 1 && tabSystem.nb > 0
        nbDegSys = zeros(tabSystem.nb,1);
        for i=1:tabSystem.nb
            for k=1:size(deg,2)
                for j=1:tabSystem.nbStr(i)
                    if strcmpi(tabSystem.nomStr{i,j},NomStruct{k})
                        nbDegSys(i) = nbDegSys(i) + deg(k);
                    end
                end
            end
        end
        xlswrite(nomFicExcelSuppr, nbDegSys', 1, 'M2')
    end


% Then loop over animals to remove them one by one
%==========================================================================
waitbar(1/(nbAnimal+1), hWait, 'Parameters calculation with animal deletion ...');
for numAnimal=1:nbAnimal
    waitbar(numAnimal/(nbAnimal+1), hWait);
    
    % Animal suppression
    %---------------------
    TabDataIncomplet = [];
    n = 0;
    for i=1:nbAnimal
        if i ~= numAnimal
            n = n+1;
            TabDataIncomplet(n,:) = TabData(i,:);
        end
    end

    % Pearson or Spearman test on original data
    %--------------------------------------------------
    if TypeCorr == 1  [rData,pData] = corr(TabDataIncomplet, 'Type', 'Pearson');
    else              [rData,pData] = corr(TabDataIncomplet, 'Type', 'Spearman');
    end

    % Generate thresholded data for Excel file format
    %------------------------------------------------
    [nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
     numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
     = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructure,rData,pData,PG_SeuilTest,NomStruct);

    % Create degree matrix and compute degrees
    %----------------------------------------------
    [DataDegre] = PBCT_CreationDataDegre(nbStructure,NomStruct,txtDataExcel,numDataExcel);
    AbsDataDegre = abs(DataDegre);
    DataUtil = AbsDataDegre;
    nbData = size(DataUtil,1);
    [deg] = degrees_und(DataUtil);
    BC = betweenness_bin(DataUtil);
    E=efficiency_bin(DataUtil,0);
    C=clustering_coef_bu(DataUtil);
    r = assortativity_bin(DataUtil,0);
    [Trans]=transitivity_bu(DataUtil);
    [Mcommunity,Qcommunity] = community_louvain(DataUtil,1);
    
    % Write values to Excel
    %---------------------------------
    VectValeurs = [];
    VectValeurs(1) = nbAnimal-1;
    VectValeurs(2) = numAnimal;
    VectValeurs(3) = max(deg);
    VectValeurs(4) = sum(deg);
    VectValeurs(5) = E;
    VectValeurs(6) = mean(C);
    VectValeurs(7) = r;
    VectValeurs(8) = Trans;
    VectValeurs(9) = size(numDataExcel,1);
    cellule = sprintf('A%d',numAnimal+2);
    xlswrite(nomFicExcelSuppr, VectValeurs, 1, cellule);
    
    % Calculate degrees by system
    %------------------------------
    if flagSystem == 1 && tabSystem.nb > 0
        nbDegSys = zeros(tabSystem.nb,1);
        for i=1:tabSystem.nb
            for k=1:size(deg,2)
                for j=1:tabSystem.nbStr(i)
                    if strcmpi(tabSystem.nomStr{i,j},NomStruct{k})
                        nbDegSys(i) = nbDegSys(i) + deg(k);
                    end
                end
            end
        end
        cellule = sprintf('M%d',numAnimal+2);
        xlswrite(nomFicExcelSuppr, nbDegSys', 1, cellule)
    end
end


% Enable menu
%==================
waitbar(5/5, hWait, 'Writing results');
close(hWait);
set(Wid_SupprAnimal, 'BackgroundColor', PG_ColorBackG_Ok);


% Clear memory
%====================
clear Entete i n numAnimal VectValeurs TabDataIncomplet cellule
clear deg BC E C r Trans Mcommunity Qcommunity
clear DataDegre AbsDataDegre DataUtil rData pData
clear nomFicExcelSuppr DataExcel txtDataExcel numDataExcel
clear nbDataExcel nbDataExcelBi_intraR nbDataExcelBi_intraL nbDataExcelBi_inter
clear std_rDataTot std_rDataBi_intraR std_rDataBi_intraL std_rDataBi_inter
clear hWait