%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_LancementBCT                                           %
% Launch procedures of Brain Connectivity ToolBox         %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Menu in computation mode
%=====================
set(Wid_LancementBCT, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;

% Compute Score parameter and write to dedicated Excel file
%==================================================================
[CIJscore,sn] = score_wu(rDataSeuillee,PG_SeuilScore);
pCIJscore = ones(size(CIJscore,1), size(CIJscore,2))*1000;
for i=1:size(CIJscore,1)
    for j=1:size(CIJscore,2)
        if CIJscore(i,j) > 0 pCIJscore(i,j)=0.0; end
    end
end

% Generate thresholded data for Excel export
%==============================================
[nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
 numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
 = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructure,CIJscore,pCIJscore,PG_SeuilScore,NomStruct);

% Write data to Excel file according to the selected mode
%=========================================================
% nomFicExcelScore = strcat(DataRep,titre,'_Score.xlsx');
% if Wid_ModeMB.Value == 1
%     % Sheet 1 : corr and pvalue
%     DataExcel{1,1} = 'ROI1';
%     DataExcel{1,2} = 'ROI2';
%     DataExcel{1,3} = 'corr';
%     DataExcel{1,4} = 'pvalue';
%     xlswrite(nomFicExcelScore, DataExcel, 1, 'A1');
%     xlswrite(nomFicExcelScore, txtDataExcel, 1, 'A2');
%     xlswrite(nomFicExcelScore, numDataExcel, 1, 'C2');
% else
%     % Sheet 1 : corr and pvalue
%     DataExcel{1,1} = 'ROI1';
%     DataExcel{1,2} = 'ROI2';
%     DataExcel{1,3} = 'hemisphere';
%     DataExcel{1,4} = 'side';
%     DataExcel{1,5} = 'corr';
%     DataExcel{1,6} = 'pvalue';
%     xlswrite(nomFicExcelScore, DataExcel, 1, 'A1');
%     xlswrite(nomFicExcelScore, txtDataExcel, 1, 'A2');
%     xlswrite(nomFicExcelScore, numDataExcel, 1, 'E2');
% end
clear nomFicExcelScore DataExcel txtDataExcel numDataExcel
clear nbDataExcel nbDataExcelBi_intraR nbDataExcelBi_intraL nbDataExcelBi_inter
clear std_rDataTot std_rDataBi_intraR std_rDataBi_intraL std_rDataBi_inter


% Load data from DataDegre  
% Then compute node degree
%========================================================
DataStr = load(NomFicDegre);
DataDegre = DataStr.DataDegre;
AbsDataDegre = abs(DataDegre);
DataUtil = AbsDataDegre;
nbData = size(DataUtil,1);
[deg] = degrees_und(DataUtil);


% Measure connection parameters: Components, Community, Modularity, Idempotent
%===========================================================================
[comps,comp_sizes] = get_components(DataUtil);
[Mcommunity,Qcommunity] = community_louvain(DataUtil,1);
[Cmodularity,Qmodularity]=modularity_und(DataUtil,1);
% SUPPRIMER
% [XN,IOTA,EPS,U] = quasi_idempotence(abs(rData));
% SUPPRIMER

% Write connection parameters to a dedicated Excel file
%====================================================================
nomFicExcelCOM = strcat(DataRep,titre,'_COM.xlsx');
% Sheet 1 : Write connected components to file
clear NomSSres
for i=1:size(comp_sizes,2)
    NomSSres{i} = sprintf('SSReseau%d',i);
end
xlswrite(nomFicExcelCOM, {"Components"}, 1, 'A1');
xlswrite(nomFicExcelCOM, NomSSres, 1, 'A2');
xlswrite(nomFicExcelCOM, comp_sizes, 1, 'A3');
clear NomSSres
for i=1:size(comp_sizes,2)
    n = 0;
    for j=1:size(comps,2)
        if comps(j) == i
            n = n+1;
            NomSSres{i,n} = NomStruct{j};
        end
    end
end
xlswrite(nomFicExcelCOM, NomSSres', 1, 'A4');
% Sheet 2 : % Write Louvain community
clear NomSSres
for i=1:max(Mcommunity)
    NomSSres{i} = sprintf('SSReseau%d',i);
end
xlswrite(nomFicExcelCOM, {"CommunityLouvain"}, 2, 'A1');
xlswrite(nomFicExcelCOM, {"Qcommunity"}, 2, 'B1');
xlswrite(nomFicExcelCOM, Qcommunity, 2, 'C1');
xlswrite(nomFicExcelCOM, NomSSres, 2, 'A2');
xlswrite(nomFicExcelCOM, histcounts(Mcommunity), 2, 'A3');
clear NomSSres
for i=1:max(Mcommunity)
    n = 0;
    for j=1:size(Mcommunity,1)
        if Mcommunity(j) == i
            n = n+1;
            NomSSres{i,n} = NomStruct{j};
        end
    end
end
xlswrite(nomFicExcelCOM, NomSSres', 2, 'A4');
% Sheet 3 : Write modularity

% Compute additional network parameters
%===============================
% Compute betweenness
BC = betweenness_bin(DataUtil);
% Compute global (arg = 0) and local (arg = 1) efficiency
E=efficiency_bin(DataUtil,0); % 0 : global / 1 : local
% Compute clustering coefficient
C=clustering_coef_bu(DataUtil);
Mean_C = mean(C);
% Compute assortativity
r = assortativity_bin(DataUtil,0); % Second argument: choose degree type (in/out; here: basic)
% Compute transitivity
[Trans]=transitivity_bu(DataUtil);

% Display degree histogram by structure  
% Sort degrees in descending order; display bars in black  
% for values below the 80th percentile
%================================================================
[dataSort, indexSort] = sort(deg,'descend');
NomStructSort = NomStruct(indexSort);
NomStructSort = strrep(NomStructSort,'_','.');
nb = size(dataSort,2);
figure('Name', 'Histogram Degrees','NumberTitle','off', 'Color', 'w');
X = categorical(NomStructSort);
X = reordercats(X, NomStructSort);
barFigDeg = bar(X, dataSort);
v = prctile(dataSort, 80);
barFigDeg.FaceColor = 'flat';
for i=1:nb
    if dataSort(i) <= v
        barFigDeg.CData(i,:) = [0 0 0];
        iSum = i;
    end
end
line([0, nb], [v, v], 'Color', 'k');
nomFicJPG = strcat(DataRep,titre,'_HistoDeg.jpg');
saveas(gcf,nomFicJPG);
clear nb v somme i X dataSort indexSort NomStructSort

% Apply the same procedure for betweenness centrality
%=====================================
[dataSort, indexSort] = sort(BC,'descend');
NomStructSort = NomStruct(indexSort);
NomStructSort = strrep(NomStructSort,'_','.');
nb = size(dataSort,2);
figure('Name', 'Histogram Betweenness','NumberTitle','off', 'Color', 'w');
X = categorical(NomStructSort);
X = reordercats(X, NomStructSort);
barFigBC = bar(X, dataSort);
v = prctile(dataSort, 80);
barFigBC.FaceColor = 'flat';
for i=1:nb
    if dataSort(i) <= v
        barFigBC.CData(i,:) = [0 0 0];
    end
end
line([0, nb], [v, v], 'Color', 'k');
nomFicJPG = strcat(DataRep,titre,'_HistoBetween.jpg');
saveas(gcf,nomFicJPG);
clear nb v somme i X dataSort indexSort NomStructSort


% Loop for random networks
%============================
hWait = waitbar(0,'Random Network calculation in progress ...');
nMax = PG_MaxRandom;
Som_eff = 0;
Som_r = 0;
Som_E = 0;
Som_Trans = 0;
Som_C = zeros(nbData,1);
Som_BC = zeros(1,nbData);
for n=1:nMax
    waitbar(n/nMax, hWait);

    % Create random matrix
    %---------------------------
    [R,Rand_eff] = randmio_und_connected(DataUtil, 10);
    
    % Compute metrics on the original matrix
    %------------------------------
    % Compute betweenness
    Rand_BC = betweenness_bin(R);
    % Compute  global (arg = 0) and local (arg = 1) efficiency
    Rand_E=efficiency_bin(R,0); % 0 : global / 1 : local
    % Compute clustering coefficient
    Rand_C=clustering_coef_bu(R);
    % Mesure de l'assortavity
    Rand_r = assortativity_bin(R,0); % Second argument: choose degree type (in/out; here: basic)
    % Compute transitivity
    [Rand_Trans]=transitivity_bu(R);
    
    % Sum data for averaging
    %-------------------------------------
    Som_eff = Som_eff + Rand_eff;
    Som_r = Som_r + Rand_r;
    Som_E = Som_E + Rand_E;
    Som_Trans = Som_Trans + Rand_Trans;
    Som_C = Som_C + Rand_C;
    Som_BC = Som_BC + Rand_BC;
    Mean_Rand_C = mean(Rand_C);
    % Save computed data in a table
    %--------------------------------------------------
    Tab_Rand_E(n) = Rand_E;
    Tab_Rand_Mean_C(n) = Mean_Rand_C;
    Tab_Rand_r(n) = Rand_r;
    Tab_Rand_Trans(n) = Rand_Trans;
end
RandMoy_eff = Som_eff / nMax;
RandMoy_r = Som_r / nMax;
RandMoy_E = Som_E / nMax;
RandMoy_Trans = Som_Trans / nMax;
RandMoy_C = Som_C / nMax;
RandMoy_BC = Som_BC / nMax;
MeanRandMoy_C = mean(RandMoy_C);

% Format results for Excel export
%======================================================
tabRes(1,1) = Mean_C;   tabRes(1,2) = MeanRandMoy_C;
tabRes(2,1) = r;        tabRes(2,2) = RandMoy_r;
tabRes(3,1) = E;        tabRes(3,2) = RandMoy_E;
tabRes(4,1) = Trans;    tabRes(4,2) = RandMoy_Trans;

% Write data to Excel file
%=========================================
waitbar(1/5, hWait, 'Writing results');
nomFicExcelGT = strcat(DataRep,titre,'_GT.xlsx');
NomAnalyse = {'Mean_C', 'r', 'E', 'Trans'};
NomVariable = {'Network', 'Random', 'Bootstrap'};

% Sheet 1
%===========
[BC, Indices] = sort(BC,'descend');
for i=1:size(Indices,2)
    NomTri(i) = NomStruct(Indices(i));
end
percentilBC = zeros(size(BC,2),1);
percentilBC_seuil = prctile(BC, 80);	% 80th percentile
for i=1:size(BC,2)
    if BC(i) > percentilBC_seuil
        percentilBC(i) = 1;
    end
end
xlswrite(nomFicExcelGT, {'ROI'}, 1, 'A1');
xlswrite(nomFicExcelGT, NomTri', 1, 'A2');
xlswrite(nomFicExcelGT, {'betweenness'}, 1, 'B1');
xlswrite(nomFicExcelGT, BC', 1, 'B2');
xlswrite(nomFicExcelGT, {'threshold'}, 1, 'C1');
xlswrite(nomFicExcelGT, percentilBC, 1, 'C2');
clear Indices NomTri

% Sheet 2
%===========
waitbar(2/5, hWait, 'Writing results');
[deg, Indices] = sort(deg,'descend');
for i=1:size(Indices,2)
    NomTri(i) = NomStruct(Indices(i));
end
xlswrite(nomFicExcelGT, {'ROI'}, 2, 'A1');
xlswrite(nomFicExcelGT, NomTri', 2, 'A2');
xlswrite(nomFicExcelGT, {'degree'}, 2, 'B1');
xlswrite(nomFicExcelGT, deg', 2, 'B2');
percentildeg = zeros(size(deg,2),1);
percentildeg_seuil = prctile(deg, 80);	% 80th percentile
for i=1:size(deg,2)
    if deg(i) > percentildeg_seuil
        percentildeg(i) = 1;
    end
end
xlswrite(nomFicExcelGT, {'threshold'}, 2, 'C1');
xlswrite(nomFicExcelGT, percentildeg, 2, 'C2');
clear Indices NomTri

% Sheet 2: values for degree frequency histogram
%=====================================================
figure('Name', 'Histogram Frequency Degrees','NumberTitle','off', 'Color', 'w');
hHisto = histogram(deg);
for i=1:hHisto.NumBins
    valHisto(i) = hHisto.BinEdges(i)-hHisto.BinEdges(1);
end
xlswrite(nomFicExcelGT, {'histo_freq'}, 2, 'F1');
xlswrite(nomFicExcelGT, valHisto', 2, 'F2');
xlswrite(nomFicExcelGT, hHisto.Values', 2, 'G2');

% Save histogram to JPG file
%====================================
nomFicJPG = strcat(DataRep,titre,'_degfreq.jpg');
saveas(gcf,nomFicJPG);

% Sheet 3
%===========
xlswrite(nomFicExcelGT, NomAnalyse, 3, 'B1');
xlswrite(nomFicExcelGT, NomVariable', 3, 'A2');
xlswrite(nomFicExcelGT, tabRes', 3, 'B2');

% Sheet 4
%===========
Tab_Rand_Mean_C = sort(Tab_Rand_Mean_C);
Tab_Rand_r = sort(Tab_Rand_r);
Tab_Rand_E = sort(Tab_Rand_E);
Tab_Rand_Trans = sort(Tab_Rand_Trans);
xlswrite(nomFicExcelGT, NomAnalyse, 4, 'A1');
xlswrite(nomFicExcelGT, Tab_Rand_Mean_C', 4, 'A2');
xlswrite(nomFicExcelGT, Tab_Rand_r', 4, 'B2');
xlswrite(nomFicExcelGT, Tab_Rand_E', 4, 'C2');
xlswrite(nomFicExcelGT, Tab_Rand_Trans', 4, 'D2');

% Find min 2.5% 
%====================
waitbar(3/5, hWait, 'Writing results');
nDep = 2.5*nMax/100;
for i=nDep:nMax
    if ~isnan(Tab_Rand_Mean_C(i))
        min_Tab_Rand_Mean_C = Tab_Rand_Mean_C(i);
        break;
    end
end
for i=nDep:nMax
    if ~isnan(Tab_Rand_r(i))
        min_Tab_Rand_r = Tab_Rand_r(i);
        break;
    end
end
for i=nDep:nMax
    if ~isnan(Tab_Rand_E(i))
        min_Tab_Rand_E = Tab_Rand_E(i);
        break;
    end
end
for i=nDep:nMax
    if ~isnan(Tab_Rand_Trans(i))
        min_Tab_Rand_Trans = Tab_Rand_Trans(i);
        break;
    end
end
EcartMin_Tab_Rand_Mean_C = mean(Tab_Rand_Mean_C)-min_Tab_Rand_Mean_C;
EcartMin_Tab_Rand_r = mean(Tab_Rand_r)-min_Tab_Rand_r;
EcartMin_Tab_Rand_E = mean(Tab_Rand_E)-min_Tab_Rand_E;
EcartMin_Tab_Rand_Trans = mean(Tab_Rand_Trans)-min_Tab_Rand_Trans;
xlswrite(nomFicExcelGT, {'Random'}, 3, 'A15');
xlswrite(nomFicExcelGT, {'2.5% min'}, 3, 'A17');
xlswrite(nomFicExcelGT, min_Tab_Rand_Mean_C, 3, 'B17');
xlswrite(nomFicExcelGT, min_Tab_Rand_r, 3, 'C17');
xlswrite(nomFicExcelGT, min_Tab_Rand_E, 3, 'D17');
xlswrite(nomFicExcelGT, min_Tab_Rand_Trans, 3, 'E17');
xlswrite(nomFicExcelGT, {'CI min'}, 3, 'A20');
xlswrite(nomFicExcelGT, EcartMin_Tab_Rand_Mean_C, 3, 'B20');
xlswrite(nomFicExcelGT, EcartMin_Tab_Rand_r, 3, 'C20');
xlswrite(nomFicExcelGT, EcartMin_Tab_Rand_E, 3, 'D20');
xlswrite(nomFicExcelGT, EcartMin_Tab_Rand_Trans, 3, 'E20');

% Find max 2.5%  
%====================
waitbar(4/5, hWait, 'Writing results');
nDep = nMax-2.5*nMax/100;
for i=nDep:-1:0
    if ~isnan(Tab_Rand_Mean_C(i))
        max_Tab_Rand_Mean_C = Tab_Rand_Mean_C(i);
        break;
    end
end
for i=nDep:-1:0
    if ~isnan(Tab_Rand_r(i))
        max_Tab_Rand_r = Tab_Rand_r(i);
        break;
    end
end
for i=nDep:-1:0
    if ~isnan(Tab_Rand_E(i))
        max_Tab_Rand_E = Tab_Rand_E(i);
        break;
    end
end
for i=nDep:-1:0
    if ~isnan(Tab_Rand_Trans(i))
        max_Tab_Rand_Trans = Tab_Rand_Trans(i);
        break;
    end
end
EcartMax_Tab_Rand_Mean_C = max_Tab_Rand_Mean_C-mean(Tab_Rand_Mean_C);
EcartMax_Tab_Rand_r = max_Tab_Rand_r-mean(Tab_Rand_r);
EcartMax_Tab_Rand_E = max_Tab_Rand_E-mean(Tab_Rand_E);
EcartMax_Tab_Rand_Trans = max_Tab_Rand_Trans-mean(Tab_Rand_Trans);
xlswrite(nomFicExcelGT, {'2.5% max'}, 3, 'A16');
xlswrite(nomFicExcelGT, max_Tab_Rand_Mean_C, 3, 'B16');
xlswrite(nomFicExcelGT, max_Tab_Rand_r, 3, 'C16');
xlswrite(nomFicExcelGT, max_Tab_Rand_E, 3, 'D16');
xlswrite(nomFicExcelGT, max_Tab_Rand_Trans, 3, 'E16');
xlswrite(nomFicExcelGT, {'CI max'}, 3, 'A19');
xlswrite(nomFicExcelGT, EcartMax_Tab_Rand_Mean_C, 3, 'B19');
xlswrite(nomFicExcelGT, EcartMax_Tab_Rand_r, 3, 'C19');
xlswrite(nomFicExcelGT, EcartMax_Tab_Rand_E, 3, 'D19');
xlswrite(nomFicExcelGT, EcartMax_Tab_Rand_Trans, 3, 'E19');

% Enable menu
%==================
waitbar(5/5, hWait, 'Writing results');
close(hWait);
set(Wid_LancementBCT, 'BackgroundColor', PG_ColorBackG_Ok);
set(Wid_LancementBootStrap, 'Enable', 'on');

% Clear memory
%====================
clear i j n indices nDep nMax deg DataDegre AbsDataDegre DataUtil hWait DataStr
clear Mean_C BC E C r Trans R Rand_eff Rand_C Rand_BC Rand_E Rand_r Rand_Trans
clear RandMoy_BC RandMoy_C RandMoy_E RandMoy_eff RandMoy_r RandMoy_Trans
clear Mean_Rand_C MeanRandMoy_C tabRes nbData valHisto
clear Som_eff Som_r Som_E Som_Trans Som_C Som_BC iSum
clear Tab_Rand_Mean_C Tab_Rand_r Tab_Rand_E Tab_Rand_Trans
clear max_Tab_Rand_Mean_C max_Tab_Rand_r max_Tab_Rand_E max_Tab_Rand_Trans
clear min_Tab_Rand_Mean_C min_Tab_Rand_r min_Tab_Rand_E min_Tab_Rand_Trans
clear EcartMax_Tab_Rand_Mean_C EcartMax_Tab_Rand_r EcartMax_Tab_Rand_E EcartMax_Tab_Rand_Trans
clear EcartMin_Tab_Rand_Mean_C EcartMin_Tab_Rand_r EcartMin_Tab_Rand_E EcartMin_Tab_Rand_Trans
clear percentildeg_seuil percentildeg barFigBC barFigDeg
clear percentilBC_seuil percentilBC NomVariable NomAnalyse
clear comps comp_sizes EPS IOTA CIJscore pCIJscore Cmodularity Mcommunity U sn XN Qcommunity Qmodularity
clear nomFicJPG hHisto
