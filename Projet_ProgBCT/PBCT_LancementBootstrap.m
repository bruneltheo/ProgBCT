%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_LancementBootstrap                                     %
% Start bootstrap iterations                                   %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Menu in computation mode
%=====================
set(Wid_LancementBootStrap, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;

% Loop for bootstrap procedure
%=========================
hWait = waitbar(0,'Calculation in progress ...');
nbLoopBoostrap = PG_MaxRandom;
for nb_boot = 1:nbLoopBoostrap
    waitbar(nb_boot/nbLoopBoostrap, hWait);
    
    % Resample TabData with replacement
    %===============================
    for n=1:nbAnimal
        vectTirage(n) = round((nbAnimal-1)*(rand)+1);
    end
    for j=1:nbAnimal
        TabDataBootS(j,:) = TabData(vectTirage(j),:);
    end
    
    % Perform Pearson or Spearman correlation test on original data
    %=================================================
    if TypeCorr == 1
        [rDataBootS,pDataBootS] = corr(TabDataBootS, 'Type', 'Pearson');
    else
        [rDataBootS,pDataBootS] = corr(TabDataBootS, 'Type', 'Spearman');
    end
   
    % Compute quasi-idempotent parameters
    %=====================================
    
    % Create NumDataExcel and TxtDataExcel tables
    %====================================================
    [nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
     numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
     = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructure,rDataBootS,pDataBootS,PG_SeuilTest,NomStruct);
    clear nbDataExcel nbDataExcelBi_intraR nbDataExcelBi_intraL nbDataExcelBi_inter
    clear std_rDataTot std_rDataBi_intraR std_rDataBi_intraL std_rDataBi_inter

    % Create Degree matrix and compute node degree
    %==============================================
    [DataDegre] = PBCT_CreationDataDegre(nbStructure,NomStruct,txtDataExcel, numDataExcel);
    AbsDataDegre = abs(DataDegre);
    DataUtil = AbsDataDegre;
    nbData = size(DataUtil,1);
    [deg] = degrees_und(DataUtil);

    % Compute additional network metrics
    %===============================
    BC = betweenness_bin(DataUtil);
    E=efficiency_bin(DataUtil,0);
    C=clustering_coef_bu(DataUtil);
    Mean_C = mean(C);
    r = assortativity_bin(DataUtil,0);
    [Trans]=transitivity_bu(DataUtil);
    
    % Save computed data into a table
    %==================================================
    % Tab_BC(nb_boot) = BC;
    Tab_E(nb_boot) = E;
    Tab_Mean_C(nb_boot) = Mean_C;
    Tab_r(nb_boot) = r;
    Tab_Trans(nb_boot) = Trans;
end

% End of bootstrap loop: sort result tables
%==================================================
Tab_Mean_C = sort(Tab_Mean_C);
Tab_r = sort(Tab_r);
Tab_E = sort(Tab_E);
Tab_Trans = sort(Tab_Trans);

% Remove NaN values from the Tab_r table
%===========================================
for i=1:nbLoopBoostrap
    if isnan(Tab_r(i))
        Tab_r(i:end) = [];
        break;
    end
end


% Write quasi-idempotence data to _COM Excel file, sheet 4
%===============================================================
% SUPPRIMER
% xlswrite(nomFicExcelCOM, {"UBootstrap"}, 4, 'C1');
% xlswrite(nomFicExcelCOM, UBootstrap', 4, 'C2');
% SUPPRIMER


% Write to Excel file, sheet 5
%=======================================
waitbar(1/5, hWait, 'Writing results');
NomAnalyse = {'Mean_C', 'r', 'E', 'Trans'};
xlswrite(nomFicExcelGT, NomAnalyse, 5, 'A1');
xlswrite(nomFicExcelGT, Tab_Mean_C', 5, 'A2');
xlswrite(nomFicExcelGT, Tab_r', 5, 'B2');
xlswrite(nomFicExcelGT, Tab_E', 5, 'C2');
xlswrite(nomFicExcelGT, Tab_Trans', 5, 'D2');

% Write to Excel file, sheet 3 (means) 
%===============================
waitbar(2/5, hWait, 'Writing results');
xlswrite(nomFicExcelGT, mean(Tab_Mean_C), 3, 'B4');
xlswrite(nomFicExcelGT, mean(Tab_r), 3, 'C4');
xlswrite(nomFicExcelGT, mean(Tab_E), 3, 'D4');
xlswrite(nomFicExcelGT, mean(Tab_Trans), 3, 'E4');

% Identify the lowest 2.5% of values
%====================
nMax = PG_MaxRandom;
waitbar(3/5, hWait, 'Writing results');
nDep = 2.5*nMax/100;
for i=nDep:nMax
    if ~isnan(Tab_Mean_C(i))
        min_Tab_Mean_C = Tab_Mean_C(i);
        break;
    end
end
nDep = round(2.5*size(Tab_r,2)/100);
min_Tab_r = Tab_r(nDep);
nDep = 2.5*nMax/100;
for i=nDep:nMax
    if ~isnan(Tab_E(i))
        min_Tab_E = Tab_E(i);
        break;
    end
end
nDep = 2.5*nMax/100;
for i=nDep:nMax
    if ~isnan(Tab_Trans(i))
        min_Tab_Trans = Tab_Trans(i);
        break;
    end
end
EcartMin_Tab_Mean_C = mean(Tab_Mean_C)-min_Tab_Mean_C;
EcartMin_Tab_r = mean(Tab_r)-min_Tab_r;
EcartMin_Tab_E = mean(Tab_E)-min_Tab_E;
EcartMin_Tab_Trans = mean(Tab_Trans)-min_Tab_Trans;
xlswrite(nomFicExcelGT, {'Network/Boot'}, 3, 'A8');
xlswrite(nomFicExcelGT, {'2.5% min'}, 3, 'A10');
xlswrite(nomFicExcelGT, min_Tab_Mean_C, 3, 'B10');
xlswrite(nomFicExcelGT, min_Tab_r, 3, 'C10');
xlswrite(nomFicExcelGT, min_Tab_E, 3, 'D10');
xlswrite(nomFicExcelGT, min_Tab_Trans, 3, 'E10');
xlswrite(nomFicExcelGT, {'CI min'}, 3, 'A13');
xlswrite(nomFicExcelGT, EcartMin_Tab_Mean_C, 3, 'B13');
xlswrite(nomFicExcelGT, EcartMin_Tab_r, 3, 'C13');
xlswrite(nomFicExcelGT, EcartMin_Tab_E, 3, 'D13');
xlswrite(nomFicExcelGT, EcartMin_Tab_Trans, 3, 'E13');

% Identify the highest 2.5% of values
%====================
waitbar(4/5, hWait, 'Writing results');
nDep = nMax-2.5*nMax/100;
for i=nDep:-1:1
    if ~isnan(Tab_Mean_C(i))
        max_Tab_Mean_C = Tab_Mean_C(i);
        break;
    end
end
nDep = round(size(Tab_r,2)-2.5*size(Tab_r,2)/100);
max_Tab_r = Tab_r(nDep);

nDep = nMax-2.5*nMax/100;
for i=nDep:-1:1
    if ~isnan(Tab_E(i))
        max_Tab_E = Tab_E(i);
        break;
    end
end
nDep = nMax-2.5*nMax/100;
for i=nDep:-1:1
    if ~isnan(Tab_Trans(i))
        max_Tab_Trans = Tab_Trans(i);
        break;
    end
end
EcartMax_Tab_Mean_C = max_Tab_Mean_C-mean(Tab_Mean_C);
EcartMax_Tab_r = max_Tab_r-mean(Tab_r);
EcartMax_Tab_E = max_Tab_E-mean(Tab_E);
EcartMax_Tab_Trans = max_Tab_Trans-mean(Tab_Trans);
xlswrite(nomFicExcelGT, {'2.5% max'}, 3, 'A9');
xlswrite(nomFicExcelGT, max_Tab_Mean_C, 3, 'B9');
xlswrite(nomFicExcelGT, max_Tab_r, 3, 'C9');
xlswrite(nomFicExcelGT, max_Tab_E, 3, 'D9');
xlswrite(nomFicExcelGT, max_Tab_Trans, 3, 'E9');
xlswrite(nomFicExcelGT, {'CI max'}, 3, 'A12');
xlswrite(nomFicExcelGT, EcartMax_Tab_Mean_C, 3, 'B12');
xlswrite(nomFicExcelGT, EcartMax_Tab_r, 3, 'C12');
xlswrite(nomFicExcelGT, EcartMax_Tab_E, 3, 'D12');
xlswrite(nomFicExcelGT, EcartMax_Tab_Trans, 3, 'E12');

% Bar Graph
%===========
valNetwork = xlsread(nomFicExcelGT, 3, 'B2:E2');
valRandom = xlsread(nomFicExcelGT, 3, 'B3:E3');
CImaxRand = xlsread(nomFicExcelGT, 3, 'B19:E19');
CIminRand = xlsread(nomFicExcelGT, 3, 'B20:E20');
figure
y_bar = [valNetwork(1) valRandom(1); valNetwork(2) valRandom(2); valNetwork(3) valRandom(3); valNetwork(4) valRandom(4)];
bar(y_bar);
set(gca, 'XTickLabel', {'Mean C' 'r' 'E' 'Trans'});
hold on
y_bar_err = [1 1; 1 1; 1 1; 1 1];
e = errorbar(y_bar, y_bar_err, '.');
e(1).UData = [EcartMax_Tab_Mean_C EcartMax_Tab_r EcartMax_Tab_E EcartMax_Tab_Trans];
e(1).LData = [EcartMin_Tab_Mean_C EcartMin_Tab_r EcartMin_Tab_E EcartMin_Tab_Trans];
e(2).UData = [CImaxRand(1) CImaxRand(2) CImaxRand(3) CImaxRand(4)];
e(2).LData = [CIminRand(1) CIminRand(2) CIminRand(3) CIminRand(4)];
e(1).XData = [0.85 1.85 2.85 3.85];
e(2).XData = [1.15 2.15 3.15 4.15];
legend('Network', 'Random');

% Save histogram as JPG file
%====================================
nomFicJPG = strcat(DataRep,titre,'_graph.jpg');
saveas(gcf,nomFicJPG);

% Activation menu
%==================
waitbar(5/5, hWait, 'Writing results');
close(hWait);
set(Wid_LancementBootStrap, 'BackgroundColor', PG_ColorBackG_Ok);

% Clear memory
%====================
clear i j n nDep nMax numDataExcel nbDataExcel txtDataExcel
clear nb_boot nbLoopBoostrap rDataBootS pDataBootS TabDataBootS
clear BC E r C Mean_C Trans AbsDataDegre DataDegre deg
clear vectTirage NomTri nomFicJPG NomAnalyse
clear Tab_Mean_C Tab_r Tab_E Tab_Trans e EPS IOTA U UBootstrap XN y_bar_err y_bar
clear max_Tab_Mean_C max_Tab_r max_Tab_E max_Tab_Trans
clear min_Tab_Mean_C min_Tab_r min_Tab_E min_Tab_Trans
clear EcartMin_Tab_Mean_C EcartMin_Tab_r EcartMin_Tab_E EcartMin_Tab_Trans
clear EcartMax_Tab_Mean_C EcartMax_Tab_r EcartMax_Tab_E EcartMax_Tab_Trans
clear valNetwork valRandom txtH txtLRi txtLRj txtS
clear hWait

