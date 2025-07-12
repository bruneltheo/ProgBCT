%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CompareCorrelations                                    %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Select the two files
%=============================
[DataFile1, DataRep1]=uigetfile([DataRep,'*_Corr.mat'], 'Selection of the first correlation file');
if DataFile1 == 0 return; end
[DataFile2, DataRep2]=uigetfile([DataRep,'*_Corr.mat'], 'Selection of the second correlation file');
if DataFile2 == 0 return; end
nomFicMatCorr1=[DataRep1,DataFile1];
nomFicMatCorr2=[DataRep2,DataFile2];

% Create appropriate colormap  
%===========================
clear colorN
for n=1:63        
    if PG_ColorTypeMantel == 1
        % Bicolor : Red/Blue
        colorN(64-n,:) = [1 1-n/63 1-n/63];
        colorN(n+64,:) = [1-n/63 1-n/63 1];
    else
        % Monocolor : Red
        val0 = 0.8;
        valcolR = ((n-1)/63)*(1-val0) + val0;
        valcolVB = n/63;
        colorN(n,:) = [valcolR valcolVB valcolVB];
        colorN(128-n,:) = [valcolR valcolVB valcolVB];
    end
end
colorN(64,:) = [1 1 1];

% Load files and extract relevant data
%=======================================================
load (nomFicMatCorr1);
rData1 = rData;
load (nomFicMatCorr2);
rData2 = rData;

% Mantel test
%================
if size(rData1,1) > 9
    nbIter = PG_NbIterationMantel;
else
    nbIter = factorial(size(rData1,1));
end
if TypeCorr == 1
    [observation pval pval2] = Mantel_bramila_mantel(1-rData1, 1-rData2, nbIter, 'pearson');
else
    [observation pval pval2] = Mantel_bramila_mantel(1-rData1, 1-rData2, nbIter, 'spearman');
end

% Compute difference between the two matrices
%========================================
titreFif = sprintf('Mantel (%d iter) : p-value=%.5f (%.5f) / Obs=%.5f', nbIter, pval, pval2, observation);
rDiff = rData1 - rData2;
refFig = figure('Name', titreFif, 'NumberTitle', 'off');
axis ij
axis equal
axis off
hold on;
coef = max(max(max(rDiff)), min(min(abs(rDiff))));
refImg = imagesc(rDiff/coef*2);
colormap(colorN);


% Clear memory
%====================
clear rData rData1 rData2 rDiff coef titreFif colorN nbIter
clear DataFile1 DataRep1 nomFicMatCorr1
clear DataFile2 DataRep2 nomFicMatCorr2


