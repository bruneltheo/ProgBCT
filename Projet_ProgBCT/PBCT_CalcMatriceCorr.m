%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CalcMatriceCorr                                        %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Load original data
%================================
PBCT_LectureDataExcel;
if flagErreur == 1
    return;
end
set(Wid_CalcMatriceCorr, 'BackgroundColor', PG_ColorBackG_Calc);
drawnow;

% Perform Pearson or Spearman test on original data
%=================================================
if TypeCorr == 1
    [rData,pData] = corr(TabData, 'Type', 'Pearson');
else
    [rData,pData] = corr(TabData, 'Type', 'Spearman');
end

% Create overlay Colormap  
% Initialize background image to be displayed using the 'gray' colormap  
% The colormap contains 64 values from black to white  
% Initialize image with value 32 (mid-gray)
%==========================================================
nbColor = 8;
for i=1:nbColor
    mapSuperpose(i,1) = i/nbColor;
    mapSuperpose(i,2) = i/nbColor;
    mapSuperpose(i,3) = 1;
end
for i=nbColor+1:2*nbColor
    mapSuperpose(i,1) = 1;
    mapSuperpose(i,2) = (2*nbColor+1-i)/nbColor;
    mapSuperpose(i,3) = (2*nbColor+1-i)/nbColor;
end
nbColor = 2*nbColor;
ImageFondDegrade = ones(nbROI*ModeMonoBi,nbROI*ModeMonoBi)*PG_couleurGriseDeFond;
ImageFondUni = ones(nbROI*ModeMonoBi,nbROI*ModeMonoBi)*PG_couleurGriseDeFond;

% Compute transparency (initialized to 0) to display only selected values  
% These will be overlaid using the previously defined colormap (mapSuperpose)
%===============================================================
AlphaData = zeros(nbStructure,nbStructure);
for i=1:nbStructure
    for j=1:nbStructure
        % Optionally recompute the background image using rData values  
        % This image will be displayed using the 'gray' colormap  
        % The line below can be commented out to keep a uniform gray background
        %-------------------------------------------------------------------
        ImageFondDegrade(i,j) = (rData(i,j)+1.0)/2.0*64;
        ImageFondUni(i,j) = PG_couleurGriseImage;
        % Loop through cells in the upper diagonal
        %------------------------------------------------------
        if i <= j
            % If p < threshold, set transparency to 1  
            % This means the value will be displayed in color
            %---------------------------------------------------
            if pData(i,j) <= PG_SeuilTest
                AlphaData(i,j) = 1.0;
            end
        % Remove lower diagonal part
        %-----------------------------------------
        else
            AlphaData(i,j) = 0.0;
            ImageFondDegrade(i,j) = PG_couleurGriseDeFond;
            ImageFondUni(i,j) = PG_couleurGriseDeFond;
        end
    end
end

% Generate original data for Excel export
%==============================================
nbDataOriginal = 0;
clear rDataExcelOriginal pDataExcelOriginal
for i=1:nbStructure
    for j=1:nbStructure
        % Loop through cells in the upper diagonal
        %------------------------------------------------------
        if i <= j
            % Retrieve all data for file writing
            %-------------------------------------------------------------
            nbDataOriginal = nbDataOriginal+1;
            rDataExcelOriginal(nbDataOriginal, 1) = rData(i,j);
            pDataExcelOriginal(nbDataOriginal, 1) = pData(i,j);
            % Retrieve all data for writing to file
            %----------------------------------------------
            if ModeMonoBi == 1
                % Mono-lateral mode
                %~~~~~~~~~~~~~~~~~~~
                txtDataExcelOriginal{nbDataOriginal, 1} = char(NomStruct(i));
                txtDataExcelOriginal{nbDataOriginal, 2} = char(NomStruct(j));
            else
                % Bilateral mode
                %~~~~~~~~~~~~~~~~~
                if i<=nbROI && j>nbROI
                    txtH = 'inter';
                    txtS = 'null';
                else
                    txtH = 'intra';
                    if i<=nbROI txtS = 'left';
                    else        txtS = 'right';
                    end
                end
                txtDataExcelOriginal{nbDataOriginal, 1} = char(NomStruct(i));
                txtDataExcelOriginal{nbDataOriginal, 2} = char(NomStruct(j));
                txtDataExcelOriginal{nbDataOriginal, 3} = txtH;
                txtDataExcelOriginal{nbDataOriginal, 4} = txtS;
            end
        end
    end
end


% Generate thresholded data for Excel export
%==============================================
[nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
 numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter] ...
 = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructure,rData,pData,PG_SeuilTest,NomStruct);


% Create display window and show correlation matrix with grey variations
%========================================================================
refFigDegrade = figure('Name', 'Correlation matrix', 'NumberTitle', 'off');
axis ij
axis equal
axis off
hold on;
% Display background image using the 'gray' colormap
%----------------------------------------------
ImageFondDegrade = round(ImageFondDegrade);
ImageFondDegrade = ind2rgb(ImageFondDegrade, gray(64));
refImgDegrade = image(ImageFondDegrade);
% Display overlay image with transparency
%----------------------------------------------------
rData2 = (rData+1)/2*size(colormap(mapSuperpose),1);
hFig = image(rData2);
set(hFig,'AlphaData',AlphaData);
% Display structure labels
%-------------------------------------
for i=1:size(NomStruct,2)
    text(i,0,NomStruct{i}, 'FontSize', 6, 'Rotation', 90);
    text((size(NomStruct,2)+1),i,NomStruct{i}, 'FontSize', 6);
end
% Set plot boundaries
%------------------------------
xlim([0 size(NomStruct,2)+15]);
ylim([-10 size(NomStruct,2)+5]);
% Save image to JPG file
%-----------------------------------
nomFicJPG = strcat(DataRep,titre,'_mapDegrade.jpg');
saveas(gcf,nomFicJPG);
nomFicMAT = strcat(DataRep,titre,'_Corr.mat');
save(nomFicMAT, 'rData');


% Create display window and show correlation matrix with fixed grey
%====================================================================
refFigUni = figure('Name', 'Correlation matrix', 'NumberTitle', 'off');
axis ij
axis equal
axis off
hold on;
% Display background image using the 'gray' colormap
%----------------------------------------------
ImageFondUni = round(ImageFondUni);
ImageFondUni = ind2rgb(ImageFondUni, gray(64));
refImgUni = image(ImageFondUni);
% Display overlay image with transparency
%----------------------------------------------------
rData2 = (rData+1)/2*size(colormap(mapSuperpose),1);
hFig = image(rData2);
set(hFig,'AlphaData',AlphaData);
% Display structure labels
%-------------------------------------
for i=1:size(NomStruct,2)
    text(i,0,NomStruct{i}, 'FontSize', 6, 'Rotation', 90);
    text((size(NomStruct,2)+1),i,NomStruct{i}, 'FontSize', 6);
end
% Set plot boundaries
%------------------------------
xlim([0 size(NomStruct,2)+15]);
ylim([-10 size(NomStruct,2)+5]);
% Save image to JPG file
%-----------------------------------
nomFicJPG = strcat(DataRep,titre,'_mapUni.jpg');
saveas(gcf,nomFicJPG);


% Write data to Excel file according to selected mode
%=========================================================
nomFicExcelCorr = strcat(DataRep,titre,'_Corr.xlsx');
if Wid_ModeMB.Value == 1
    % Sheet 1 : corr and pvalue
    DataExcel{1,1} = 'ROI1';
    DataExcel{1,2} = 'ROI2';
    DataExcel{1,3} = 'corr';
    DataExcel{1,4} = 'pvalue';
    xlswrite(nomFicExcelCorr, DataExcel, 1, 'A1');
    xlswrite(nomFicExcelCorr, txtDataExcel, 1, 'A2');
    xlswrite(nomFicExcelCorr, numDataExcel, 1, 'C2');
    % Sheet 3 : all rData and original pDate
    xlswrite(nomFicExcelCorr, DataExcel, 3, 'A1');
    xlswrite(nomFicExcelCorr, txtDataExcelOriginal, 3, 'A2');
    xlswrite(nomFicExcelCorr, rDataExcelOriginal, 3, 'C2');
    xlswrite(nomFicExcelCorr, pDataExcelOriginal, 3, 'D2');
    % Sheet 2 : percentage and Rmean
    clear DataExcel numDataExcel
    nbItem = size(NomStruct,2);
    DataExcel{1,2} = 'N%';
    DataExcel{1,3} = 'R_mean';
    DataExcel{1,4} = 'R_std';
    DataExcel{2,1} = 'Total';
    xlswrite(nomFicExcelCorr, DataExcel, 2, 'A1');  
    numDataExcel(1, 1) = nbDataExcel / ((nbItem*(nbItem+1))/2.0) * 100.0;
    numDataExcel(1, 2) = mean(std_rDataTot);
    numDataExcel(1, 3) = std(std_rDataTot);
    xlswrite(nomFicExcelCorr, numDataExcel, 2, 'B2');
else
    % Sheet 1 : corr and pvalue
    DataExcel{1,1} = 'ROI1';
    DataExcel{1,2} = 'ROI2';
    DataExcel{1,3} = 'hemisphere';
    DataExcel{1,4} = 'side';
    DataExcel{1,5} = 'corr';
    DataExcel{1,6} = 'pvalue';
    xlswrite(nomFicExcelCorr, DataExcel, 1, 'A1');
    xlswrite(nomFicExcelCorr, txtDataExcel, 1, 'A2');
    xlswrite(nomFicExcelCorr, numDataExcel, 1, 'E2');
    % Sheet 3 : all rData and original pDate
    xlswrite(nomFicExcelCorr, DataExcel, 3, 'A1');
    xlswrite(nomFicExcelCorr, txtDataExcelOriginal, 3, 'A2');
    xlswrite(nomFicExcelCorr, rDataExcelOriginal, 3, 'E2');
    xlswrite(nomFicExcelCorr, pDataExcelOriginal, 3, 'F2');
    % Sheet 2 : percentage and Rmean
    clear DataExcel numDataExcel
    nbItem = size(NomStruct,2)/2;
    DataExcel{1,2} = 'N%';
    DataExcel{1,3} = 'R_mean';
    DataExcel{1,4} = 'R_std';
    DataExcel{2,1} = 'intraL';
    DataExcel{3,1} = 'intraR';
    DataExcel{4,1} = 'inter';
    DataExcel{5,1} = 'Total';
    xlswrite(nomFicExcelCorr, DataExcel, 2, 'A1');  
    numDataExcel(1, 1) = nbDataExcelBi_intraL / ((nbItem*(nbItem+1))/2.0) * 100.0;
    numDataExcel(1, 2) = mean(std_rDataBi_intraL);
    numDataExcel(1, 3) = std(std_rDataBi_intraL);
    numDataExcel(2, 1) = nbDataExcelBi_intraR / ((nbItem*(nbItem+1))/2.0) * 100.0;
    numDataExcel(2, 2) = mean(std_rDataBi_intraR);
    numDataExcel(2, 3) = std(std_rDataBi_intraR);
    numDataExcel(3, 1) = nbDataExcelBi_inter / (nbItem*nbItem) * 100.0;
    numDataExcel(3, 2) = mean(std_rDataBi_inter);
    numDataExcel(3, 3) = std(std_rDataBi_inter);
    nbItemTot = ((2*nbItem)*((2*nbItem)+1))/2;
    numDataExcel(4, 1) = nbDataExcel / nbItemTot * 100.0;
    numDataExcel(4, 2) = mean(std_rDataTot);
    numDataExcel(4, 3) = std(std_rDataTot);
    xlswrite(nomFicExcelCorr, numDataExcel, 2, 'B2');
end

% Display scales if requested
%===============================
if PG_AfficheEchelles
    refEch = figure('Name', 'Scales', 'Color', [1 1 1]);
    ImageFond = [16:-1:1]';
    ImageFond = round(ImageFond);
    subplot(1,2,1);
    axis ij
    axis equal
    axis off
    hold on;
    refImgEch = image(ind2rgb(ImageFond, gray(16)));
    subplot(1,2,2);
    axis ij
    axis equal
    axis off
    hold on;
    refImgEch2 = image(ind2rgb(ImageFond, colormap(mapSuperpose)));
end


% Compute connection strength from the thresholded correlation matrix
%===============================================================
rDataSeuillee = zeros(size(rData,1),size(rData,2));
for i=1:size(rData,1)
    for j=1:size(rData,2)
        if pData(i,j) <= PG_SeuilTest
            rDataSeuillee(i,j) = rData(i,j);
        end
    end
end
[Spos,Sneg,vpos,vneg] = strengths_und_sign(rDataSeuillee);
clear DataExcel
DataExcel{1,1} = 'NomStruct';
DataExcel{1,2} = 'ForcePos';
DataExcel{1,3} = 'ForceNeg';
xlswrite(nomFicExcelCorr, DataExcel, 4, 'A1');
xlswrite(nomFicExcelCorr, NomStruct', 4, 'A2');
xlswrite(nomFicExcelCorr, Spos', 4, 'B2');
xlswrite(nomFicExcelCorr, Sneg', 4, 'C2');


% Enable menu option for network visualization
%======================================
set(Wid_CalcMatriceCorr, 'BackgroundColor', PG_ColorBackG_Ok);
set(Wid_NetworkDisplay, 'Enable', 'on');

% Clear memory
%====================
clear DataExcel txtDataExcel numDataExcel mapSuperpose pData
clear std_rDataTot std_rDataBi_inter std_rDataBi_intraL std_rDataBi_intraR
clear rDataExcelOriginal pDataExcelOriginal txtDataExcelOriginal
clear i j nbItem nbColor
clear ImageFond AlphaData rData2 hFig refImg refFig
clear txtH txtLRi txtLRj txtS nomFicJPG nomFicMAT
clear refImgEch refImgEch2 refEch nbItemTot
clear nbDataOriginal nbDataExcel nbDataExcelBi_intraR nbDataExcelBi_intraL nbDataExcelBi_inter
clear Spos Sneg vpos vneg NomStructTmp

