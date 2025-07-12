%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_ProcedureSupprStructure                                %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Check for existence of data file
%===================================
PBCT_LectureVariablesMenu; 
if flagDataOK == 0
	errordlg({'Please select a data file','calculate the correlation matrix'}, 'Error', 'modal');
    return;
end

% Load original data returned in TabData
%========================================================
PBCT_LectureDataExcel;
if flagErreur == 1
    return;
end
set(Wid_SupprStruc, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;

% Create output Excel file
%==================================
nomFicExcelSuppr = strcat(DataRep,titre,'_SUPPR_STRUCTURE.xlsx');
Entete = {'Nb', 'NomStruc', 'MaxDeg', 'SumDeg', 'E', 'Mean_C', 'r', 'Trans', 'SumCorr', 'SizeComp'};
for i=1:PG_NbSupprStrAleatoire+1
    xlswrite(nomFicExcelSuppr, Entete, i, 'A1');
end
Entete = {'Nb', 'MeanSizeComp'};
xlswrite(nomFicExcelSuppr, Entete, PG_NbSupprStrAleatoire+2, 'A1');


%##########################################################################
% Remove structures in order of degree
%##########################################################################


% Recompute all parameters using all structures
%=============================================================
hWait = waitbar(0,'Parameter calculation with all structures ...');

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
    VectValeurs(1) = nbStructure;
    VectValeurs(2) = 0;
    VectValeurs(3) = max(deg);
    VectValeurs(4) = sum(deg);
    VectValeurs(5) = E;
    VectValeurs(6) = mean(C);
    VectValeurs(7) = r;
    VectValeurs(8) = Trans;
    VectValeurs(9) = size(numDataExcel,1);
    VectValeurs(10) = 100.0;
    VectVal10 = size(numDataExcel,1);
    xlswrite(nomFicExcelSuppr, VectValeurs, 1, 'A2');
    xlswrite(nomFicExcelSuppr, {'Toutes'}, 1, 'B2');
    
% Sort structures based on their degree
%==============================================
[deg, Indices] = sort(deg,'descend');
for i=1:size(Indices,2)
    NomStructTri(i) = NomStruct(Indices(i));
    for n=1:nbAnimal
        TabDataTri(n,i) = TabData(n,Indices(i));
    end
end
nbStructureTri = nbStructure;


% Then loop over structures to remove them one by one
% progressively, based on the previously calculated degree
%================================================================
if PG_MaxStructFlag == 0
    NbStructureASupprimer = nbStructure-2;
else
    NbStructureASupprimer = PG_MaxStructSuppr;
end
waitbar(1/(NbStructureASupprimer+1), hWait, {'Parameter calculation with structure deletion','in order of degree ...'});
nSuppr = 2;
for numStr=1:NbStructureASupprimer
    waitbar(numStr/(NbStructureASupprimer+1), hWait);
    
    % Remove the structure with the highest degree  
    % i.e., the first column of the tables
    %------------------------------------------------
    TabDataIncomplet = [];
    NomStructIncomplet = [];
    n = 1;
    for i=nSuppr:nbStructure
        TabDataIncomplet(:,n) = TabDataTri(:,i);
        NomStructIncomplet{n} = NomStructTri{i};
        n = n+1;
    end
    nbStructureTri = n-1;
    nSuppr = nSuppr+1;
    
    % Pearson or Spearman test on original data
    %--------------------------------------------------
    if TypeCorr == 1  [rData,pData] = corr(TabDataIncomplet, 'Type', 'Pearson');
    else              [rData,pData] = corr(TabDataIncomplet, 'Type', 'Spearman');
    end

    % Generate thresholded data for Excel file format
    %------------------------------------------------
    [nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
     numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
     = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructureTri,rData,pData,PG_SeuilTest,NomStructIncomplet);


    % Create degree matrix and compute degrees
    %----------------------------------------------
    [DataDegre] = PBCT_CreationDataDegre(nbStructureTri,NomStructIncomplet,txtDataExcel,numDataExcel);
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
    VectValeurs(1) = nbStructureTri;
    VectValeurs(2) = 0;
    VectValeurs(3) = max(deg);
    VectValeurs(4) = sum(deg);
    VectValeurs(5) = E;
    VectValeurs(6) = mean(C);
    VectValeurs(7) = r;
    VectValeurs(8) = Trans;
    VectValeurs(9) = size(numDataExcel,1);
    VectValeurs(10) = VectValeurs(9)/VectVal10*100;
    cellule = sprintf('A%d',numStr+2);
    xlswrite(nomFicExcelSuppr, VectValeurs, 1, cellule);
    cellule = sprintf('B%d',numStr+2);
    xlswrite(nomFicExcelSuppr, NomStructTri(numStr), 1, cellule);
end



%##########################################################################
% Remove structures in a random order
%##########################################################################


% Random removal of structures:  
% Recompute all parameters with all structures
%=============================================================
waitbar(0, hWait,'Parameter calculation with all structures ...');

    % Pearson or Spearman test on original data
    %--------------------------------------------------
    if TypeCorr == 1  [rData,pData] = corr(TabData, 'Type', 'Pearson');
    else              [rData,pData] = corr(TabData, 'Type', 'Spearman');
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
    VectValeurs(1) = nbStructure;
    VectValeurs(2) = 0;
    VectValeurs(3) = max(deg);
    VectValeurs(4) = sum(deg);
    VectValeurs(5) = E;
    VectValeurs(6) = mean(C);
    VectValeurs(7) = r;
    VectValeurs(8) = Trans;
    VectValeurs(9) = size(numDataExcel,1);
    VectValeurs(10) = 100.0;
    VectVal10 = size(numDataExcel,1);
    for i=1:PG_NbSupprStrAleatoire
        xlswrite(nomFicExcelSuppr, VectValeurs, i+1, 'A2');
        xlswrite(nomFicExcelSuppr, {'Toutes'}, i+1, 'B2');
    end

    
% Then loop over structures to remove them randomly  
% Repeat the operation multiple times if necessary
%===============================================================
tabValC1 = [];
tabValC10 = [];
for nba=1:PG_NbSupprStrAleatoire
    
    % Fill new tables for initialization
    %---------------------------------------------------
    for i=1:size(NomStruct,2)
        NomStructTri(i) = NomStruct(i);
        for n=1:nbAnimal
            TabDataTri(n,i) = TabData(n,i);
        end
    end
    nbStructureTri = nbStructure;
    TabDataIncomplet = TabDataTri;
    NomStructIncomplet = NomStruct;

    % Then loop over structures to remove them randomly
    %-----------------------------------------------------------------
    if PG_MaxStructFlag == 0
        NbStructureASupprimer = nbStructure-2;
    else
        NbStructureASupprimer = PG_MaxStructSuppr;
    end
    txt = sprintf('repeats N°%d', nba);
    waitbar(1/(NbStructureASupprimer+1), hWait, {'Parameter calculation with random deletion :', txt});
    
    for numStr=1:NbStructureASupprimer
        waitbar(numStr/(NbStructureASupprimer+1), hWait);

        % Randomly remove a structure
        %-------------------------------------------
        numSuppr = round(rand*(nbStructureTri-1))+1;
        NomStructSuppr = NomStructTri(numSuppr);
        
        TabDataIncomplet = [];
        NomStructIncomplet = [];
        n = 1;
        if numSuppr == 1
            for i=2:nbStructureTri
                TabDataIncomplet(:,n) = TabDataTri(:,i);
                NomStructIncomplet{n} = NomStructTri{i};
                n = n+1;
            end
        else
            for i=1:numSuppr-1
                TabDataIncomplet(:,n) = TabDataTri(:,i);
                NomStructIncomplet{n} = NomStructTri{i};
                n = n+1;
            end
            for i=numSuppr+1:nbStructureTri
                TabDataIncomplet(:,n) = TabDataTri(:,i);
                NomStructIncomplet{n} = NomStructTri{i};
                n = n+1;
            end
        end
        nbStructureTri = nbStructureTri-1;
        TabDataTri = TabDataIncomplet;
        NomStructTri = NomStructIncomplet;

        % Pearson or Spearman test on original data
        %--------------------------------------------------
        if TypeCorr == 1  [rData,pData] = corr(TabDataIncomplet, 'Type', 'Pearson');
        else              [rData,pData] = corr(TabDataIncomplet, 'Type', 'Spearman');
        end

        % Generate thresholded data for Excel file format
        %------------------------------------------------
        [nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
         numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
         = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructureTri,rData,pData,PG_SeuilTest,NomStructIncomplet);


        % Create degree matrix and compute degrees
        %----------------------------------------------
        [DataDegre] = PBCT_CreationDataDegre(nbStructureTri,NomStructIncomplet,txtDataExcel,numDataExcel);
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
        VectValeurs(1) = nbStructureTri;
        VectValeurs(2) = 0;
        VectValeurs(3) = max(deg);
        VectValeurs(4) = sum(deg);
        VectValeurs(5) = E;
        VectValeurs(6) = mean(C);
        VectValeurs(7) = r;
        VectValeurs(8) = Trans;
        VectValeurs(9) = size(numDataExcel,1);
        VectValeurs(10) = VectValeurs(9)/VectVal10*100;
        cellule = sprintf('A%d',numStr+2);
        xlswrite(nomFicExcelSuppr, VectValeurs, nba+1, cellule);
        cellule = sprintf('B%d',numStr+2);
        xlswrite(nomFicExcelSuppr, NomStructSuppr, nba+1, cellule);
        
        % Store values for mean random values
        %-------------------------------------
        tabValC1(numStr) = nbStructureTri;
        tabValC10(nba, numStr) = VectValeurs(10);
    end
end

% Writing mean values of random loop
%====================================
for i=1:NbStructureASupprimer
    tabValMoyC10(i) = mean(tabValC10(:,i));
end
xlswrite(nomFicExcelSuppr, nbStructure, PG_NbSupprStrAleatoire+2, 'A2');
xlswrite(nomFicExcelSuppr, 100, PG_NbSupprStrAleatoire+2, 'B2');
xlswrite(nomFicExcelSuppr, tabValC1', PG_NbSupprStrAleatoire+2, 'A3');
xlswrite(nomFicExcelSuppr, tabValMoyC10', PG_NbSupprStrAleatoire+2, 'B3');
PBCT_RenommeFeuilleExcel(nomFicExcelSuppr, 5, {'Network', 'Rand1', 'Rand2', 'Rand3', 'RandMean'}, [1 2 3 4 5]);

% Enable menu
%==================
waitbar(5/5, hWait);
close(hWait);
set(Wid_SupprStruc, 'BackgroundColor', PG_ColorBackG_Ok);


% Clear memory
%====================
clear Entete i n numStr VectValeurs TabDataIncomplet cellule NomStructIncomplet
clear deg BC E C r Trans Mcommunity Qcommunity
clear DataDegre AbsDataDegre DataUtil rData pData TabDataTri
clear nomFicExcelSuppr DataExcel txtDataExcel numDataExcel
clear nbDataExcel nbDataExcelBi_intraR nbDataExcelBi_intraL nbDataExcelBi_inter
clear std_rDataTot std_rDataBi_intraR std_rDataBi_intraL std_rDataBi_inter
clear NomStructTri nbStructureTri Indices NbStructureASupprimer nSuppr
clear hWait tabValC1 tabValC10 tabValMoyC10