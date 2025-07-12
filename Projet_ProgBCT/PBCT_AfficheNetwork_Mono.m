%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_AfficheNetwork_Mono                                    %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Initialize variables for intra-hemispheric connections
%======================================
nbConnectIntraSum = zeros(nbROI,1);
nbConnectIntraSumPos = zeros(nbROI,1);
nbConnectIntraSumNeg = zeros(nbROI,1);
nbConnectIntra = zeros(nbROI,1);
tabConnectIntra = [];
valCorIntra = [];

% Compute connections
%==================
for n=1:nbLigne
    % Loop through structures to cumulatively count source and target nodes  
    for i=1:nbROI
        if strcmp(NomStructInit{i},txtData{n,1})
            nbConnectIntraSum(i) = nbConnectIntraSum(i)+1;
            if numData(n,1) >= 0
                nbConnectIntraSumPos(i) = nbConnectIntraSumPos(i)+1;
            else
                nbConnectIntraSumNeg(i) = nbConnectIntraSumNeg(i)+1;
            end
        end
        if strcmp(NomStructInit{i},txtData{n,2})
            nbConnectIntraSum(i) = nbConnectIntraSum(i)+1;
            if numData(n,1) >= 0
                nbConnectIntraSumPos(i) = nbConnectIntraSumPos(i)+1;
            else
                nbConnectIntraSumNeg(i) = nbConnectIntraSumNeg(i)+1;
            end
        end
    end
    % Create connections within the right hemisphere  
    % Only consider R entries in the first column 
    % pointing to R entries in the second column
    for i=1:nbROI
    	if strcmp(NomStructInit{i},txtData{n,1})
            % Increment node count
            nbConnectIntra(i) = nbConnectIntra(i)+1;
            % Identify associated node
            for k=1:nbROI
                if strcmp(NomStructInit{k},txtData{n,2})
                    % Retrieve target node index and correlation value
                    tabConnectIntra(i,nbConnectIntra(i)) = k;
                    valCorIntra(i,nbConnectIntra(i)) = numData(n,1);
                end
            end
        end
    end
end

% Compute maximum values for graphical scaling
%=====================================================================
maxNbConnectIntra = max(nbConnectIntra);
maxNbConnect = maxNbConnectIntra;

% Create figure  
%=================
HfigIntra = figure('Name', 'Network','NumberTitle','off', 'Color', 'w', 'Position', [100 -30 800 800]);
hold on
axis equal off
axis([-0.1 2.1 -0.1 2.1]);
if PG_flagVisuNetwork_cercle
    rectangle('Position', [0 0 PG_rayon PG_rayon], 'Curvature', [1 1]);
end

% Draw connections on the circle, then plot structure positions
%==================================================================
for i=1:nbROI
    % Draw connections
    %-----------------
    for j=1:nbConnectIntra(i)
        k = tabConnectIntra(i,j);
        x=[tabPosRight(i,1) tabPosRight(k,1)];
        y=[tabPosRight(i,2) tabPosRight(k,2)];
        if (valCorIntra(i,j) >= 0)
            couleur = 'r';
        else
            couleur = 'b';
        end
        if (valCorMax-valCorMin) <=0
            epaisseur = 1;
        else
            epaisseur = 0.5+PG_coefEpaisseurLigne*(abs(valCorIntra(i,j))-valCorMin)/(valCorMax-valCorMin);
        end
        plot(x, y, 'Color', couleur, 'LineWidth', epaisseur);
    end
    
    % Plot structure positions with the name of the structures
    %---------------------------------------------
    angle = 90-i*angle_interval+angle_interval/2;
    taillePoint = (nbConnectIntraSum(i)+1)/PG_coefTaillePoint;
    rectangle('Position', [tabPosRight(i,1)-taillePoint/2 tabPosRight(i,2)-taillePoint/2 taillePoint taillePoint],...
              'Curvature', [1 1], 'EdgeColor', 'k', 'FaceColor', 'k');
    if angle >= -90
        text((tabPosRight(i,1)-1)*PG_coefRayonTxt+1, (tabPosRight(i,2)-1)*PG_coefRayonTxt+1, NomStructInit{i}, 'Color', 'k',...
             'FontSize', PG_tailleTxtStr, 'HorizontalAlignment', 'left', 'Rotation', angle);
    else
        text((tabPosRight(i,1)-1)*PG_coefRayonTxt+1, (tabPosRight(i,2)-1)*PG_coefRayonTxt+1, NomStructInit{i}, 'Color', 'k',...
             'FontSize', PG_tailleTxtStr, 'HorizontalAlignment', 'right', 'Rotation', angle-180);
    end
end

% Add title and group ROIs 
%=======================================
text(-0.4,2.3,titre, 'FontSize', PG_tailleTxtTitre);
PBCT_AfficheNetwork_GroupesROI;

% Save the result figure as a JPG file
%=================================
nomFicJPG = strcat(DataRep,titre,'_res.jpg');
saveas(gcf,nomFicJPG);

% Write connection counts to Excel file (sheet 4) 
% Sort by ascending total number of connections
%=======================================================

% Clear memory
%====================
clear i j k n x y angle nomS nomSC couleur epaisseur taillePoint
clear nbConnectIntra tabConnectIntra valCorIntra
clear maxNbConnectIntra maxNbConnect DataExcel
clear nbConnectIntraSum nbConnectIntraSumPos nbConnectIntraSumNeg
clear NomTri IndexTri nbConnectTri
clear DataExcel
clear HfigIntra

