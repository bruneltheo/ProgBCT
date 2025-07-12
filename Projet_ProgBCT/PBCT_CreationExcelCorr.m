%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_CalcCreationExcelCorr                                  %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
function [nbDataExcel,nbDataExcelBi_intraR,nbDataExcelBi_intraL,nbDataExcelBi_inter,...
          numDataExcel,txtDataExcel,std_rDataTot,std_rDataBi_intraR,std_rDataBi_intraL,std_rDataBi_inter]...
          = PBCT_CreationExcelCorr(ModeMonoBi,nbROI,nbStructure,rData,pData,SeuilTest,NomStruct)


% Generate thresholded data for Excel export
%==============================================
nbDataExcel = 0;
nbDataExcelBi_intraR = 0;
nbDataExcelBi_intraL = 0;
nbDataExcelBi_inter = 0;
std_rDataTot =  [];
std_rDataBi_intraR = [];
std_rDataBi_intraL = [];
std_rDataBi_inter = [];
numDataExcel = [];
txtDataExcel = [];

%clear numDataExcel txtDataExcel
for i=1:nbStructure
    for j=1:nbStructure
	% Loop through cells in the upper diagonal of the matrix
        %------------------------------------------------------
        if i <= j
	    % Retrieve only data below the threshold  
            % Also generate all structure names

            %----------------------------------------------
            if pData(i,j) <= SeuilTest
                nbDataExcel = nbDataExcel + 1;
                numDataExcel(nbDataExcel, 1) = rData(i,j);
                numDataExcel(nbDataExcel, 2) = pData(i,j);
                std_rDataTot(nbDataExcel) = rData(i,j);
                if ModeMonoBi == 1
                    % Mono-lateral mode
                    %~~~~~~~~~~~~~~~~~~~
                    txtDataExcel{nbDataExcel, 1} = char(NomStruct(i));
                    txtDataExcel{nbDataExcel, 2} = char(NomStruct(j));
                else
                    % Bilateral mode
                    %~~~~~~~~~~~~~~~~~
                    LRi = ~isempty(strfind(char(NomStruct(i)),'_L'));
                    LRj = ~isempty(strfind(char(NomStruct(j)),'_L'));
                    if LRi ~= LRj
%                    if i<=nbROI && j>nbROI
                        txtH = 'inter';
                        txtS = 'null';
                        nbDataExcelBi_inter = nbDataExcelBi_inter + 1;
                        std_rDataBi_inter(nbDataExcelBi_inter) = rData(i,j);
                    else
                        txtH = 'intra';
                        if LRi == 1
%                        if i<=nbROI
                            txtS = 'left';
                            nbDataExcelBi_intraL = nbDataExcelBi_intraL + 1;
                            std_rDataBi_intraL(nbDataExcelBi_intraL) = rData(i,j);
                        else
                            txtS = 'right';
                            nbDataExcelBi_intraR = nbDataExcelBi_intraR + 1;
                            std_rDataBi_intraR(nbDataExcelBi_intraR) = rData(i,j);
                        end
                    end
                    txtDataExcel{nbDataExcel, 1} = char(NomStruct(i));
                    txtDataExcel{nbDataExcel, 2} = char(NomStruct(j));
                    txtDataExcel{nbDataExcel, 3} = txtH;
                    txtDataExcel{nbDataExcel, 4} = txtS;
                end
            end
        end
    end
end

end
