%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_AfficheNetwork_Bi                                      %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021                                              %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Initialize variables for intra- and inter-group connections
%===============================================
nbConnectIntraSumR = zeros(nbROI,1);
nbConnectIntraSumRPos = zeros(nbROI,1);
nbConnectIntraSumRNeg = zeros(nbROI,1);
nbConnectIntraSumL = zeros(nbROI,1);
nbConnectIntraSumLPos = zeros(nbROI,1);
nbConnectIntraSumLNeg = zeros(nbROI,1);
nbConnectIntraR = zeros(nbROI,1);
nbConnectIntraL = zeros(nbROI,1);
nbConnectInterR = zeros(nbROI,1);
nbConnectInterL = zeros(nbROI,1);
nbConnectInterSumRPos = zeros(nbROI,1);
nbConnectInterSumRNeg = zeros(nbROI,1);
nbConnectInterSumLPos = zeros(nbROI,1);
nbConnectInterSumLNeg = zeros(nbROI,1);
tabConnectInterR = [];
tabConnectInterL = [];
tabConnectIntraR = [];
tabConnectIntraL = [];
valCorInterR = [];
valCorInterL = [];
valCorIntraR = [];
valCorIntraL = [];

% Compute connections and check if they are intra- or inter-group
%==============================================
for n=1:nbLigne
    %-------------------------------
    % Inter-group case

    %-------------------------------
    if txtData{n,3} == 'inter'
        for i=1:nbROI
	        % Only consider L entries from the first column 
                % pointing to R entries in the second column
            nomS = strcat(NomStructInit{i},'_L');
            if strcmp(nomS,txtData{n,1})
                % Initialize and increment node count at start
                nbConnectInterL(i) = nbConnectInterL(i)+1;
                %00000000000000000
                if numData(n,1) >= 0
                    nbConnectInterSumLPos(i) = nbConnectInterSumLPos(i)+1;
                else
                    nbConnectInterSumLNeg(i) = nbConnectInterSumLNeg(i)+1;
                end
                %00000000000000000
                % Find nodes connected exclusively to R targets
                for k=1:nbROI
                    nomSC = strcat(NomStructInit{k},'_R');
                    if strcmp(nomSC,txtData{n,2})
                        % Retrieve target node index and correlation value
                        tabConnectInterL(i,nbConnectInterL(i)) = k;
                        valCorInterL(i,nbConnectInterL(i)) = numData(n,1);
                        % Increment target node count
                        nbConnectInterR(k) = nbConnectInterR(k)+1;
                        %00000000000000000
                        if numData(n,1) >= 0
                            nbConnectInterSumRPos(k) = nbConnectInterSumRPos(k)+1;
                        else
                            nbConnectInterSumRNeg(k) = nbConnectInterSumRNeg(k)+1;
                        end
                        %00000000000000000
                    end
                end
            end
        end
    end
    
    %-------------------------------
    % Intra-group case
    %-------------------------------
    if txtData{n,3} == 'intra'
        % Loop through structures to cumulatively count 
        % source and target nodes
        for i=1:nbROI
            nomS = strcat(NomStructInit{i},'_L');
            if strcmp(nomS,txtData{n,1})
                nbConnectIntraSumL(i) = nbConnectIntraSumL(i)+1;
                %00000000000000000
                if numData(n,1) >= 0
                    nbConnectIntraSumLPos(i) = nbConnectIntraSumLPos(i)+1;
                else
                    nbConnectIntraSumLNeg(i) = nbConnectIntraSumLNeg(i)+1;
                end
                %00000000000000000
            end
            nomS = strcat(NomStructInit{i},'_R');
            if strcmp(nomS,txtData{n,2})
                nbConnectIntraSumR(i) = nbConnectIntraSumR(i)+1;
                %00000000000000000
                if numData(n,1) >= 0
                    nbConnectIntraSumRPos(i) = nbConnectIntraSumRPos(i)+1;
                else
                    nbConnectIntraSumRNeg(i) = nbConnectIntraSumRNeg(i)+1;
                end
                %00000000000000000
            end
        end
        % Loop through structures to cumulatively count 
        % source and target nodes
        for i=1:nbROI
            nomS = strcat(NomStructInit{i},'_R');
            if strcmp(nomS,txtData{n,1})
                nbConnectIntraSumR(i) = nbConnectIntraSumR(i)+1;
                %00000000000000000
                if numData(n,1) >= 0
                    nbConnectIntraSumRPos(i) = nbConnectIntraSumRPos(i)+1;
                else
                    nbConnectIntraSumRNeg(i) = nbConnectIntraSumRNeg(i)+1;
                end
                %00000000000000000
            end
            nomS = strcat(NomStructInit{i},'_L');
            if strcmp(nomS,txtData{n,2})
                nbConnectIntraSumL(i) = nbConnectIntraSumL(i)+1;
                %00000000000000000
                if numData(n,1) >= 0
                    nbConnectIntraSumLPos(i) = nbConnectIntraSumLPos(i)+1;
                else
                    nbConnectIntraSumLNeg(i) = nbConnectIntraSumLNeg(i)+1;
                end
                %00000000000000000
            end
        end
        % Create connections within the right hemisphere  
        % Only consider R entries in the first column 
        % pointing to R entries in the second column
        if strcmp(txtData{n,4}, 'right')
            for i=1:nbROI
                nomS = strcat(NomStructInit{i},'_R');
                if strcmp(nomS,txtData{n,1})
                    % Increment node count
                    nbConnectIntraR(i) = nbConnectIntraR(i)+1;
                    % Identify nodes connected exclusively to R targets
                    for k=1:nbROI
                        nomSC = strcat(NomStructInit{k},'_R');
                        if strcmp(nomSC,txtData{n,2})
                            % Retrieve target node index and correlation value
                            tabConnectIntraR(i,nbConnectIntraR(i)) = k;
                            valCorIntraR(i,nbConnectIntraR(i)) = numData(n,1);
                        end
                    end
                end
            end
        % Create connections within the left hemisphere  
        % Only consider L entries in the first column 
        % pointing to L entries in the second column
        elseif txtData{n,4} == 'left'
            for i=1:nbROI
                nomS = strcat(NomStructInit{i},'_L');
                if strcmp(nomS,txtData{n,1})
                    % Increment node count
                    nbConnectIntraL(i) = nbConnectIntraL(i)+1;
                    % Identify nodes connected exclusively to L targets
                    for k=1:nbROI
                        nomSC = strcat(NomStructInit{k},'_L');
                        if strcmp(nomSC,txtData{n,2})
                            % Retrieve target node index and correlation value
                            tabConnectIntraL(i,nbConnectIntraL(i)) = k;
                            valCorIntraL(i,nbConnectIntraL(i)) = numData(n,1);
                        end
                    end
                end
            end
        end
    end
end


% Compute various maxima for graphical rescaling
%=====================================================================
maxNbConnectIntraR = max(nbConnectIntraR);
maxNbConnectIntraL = max(nbConnectIntraL);
maxNbConnectInterR = max(nbConnectInterR);
maxNbConnectInterL = max(nbConnectInterL);
maxNbConnectIntra = max(maxNbConnectIntraR, maxNbConnectIntraL);
maxNbConnectInter = max(maxNbConnectInterR, maxNbConnectInterL);
maxNbConnect = max(maxNbConnectIntra, maxNbConnectInter);

% INTRA: Create figure 
%=========================
HfigIntra = figure('Name', 'Network INTRA','NumberTitle','off', 'Color', 'w', 'Position', [100 -30 800 800]);
hold on
axis equal off
axis([-0.1 2.1 -0.1 2.1]);
if PG_flagVisuNetwork_cercle
    rectangle('Position', [0 0 PG_rayon PG_rayon], 'Curvature', [1 1]);
end

% INTRA: Draw connections on the circle, then plot structure positions
%=========================================================================
for i=1:nbROI
    % Draw connections on the right hemisphere
    %--------------------------------------
    for j=1:nbConnectIntraR(i)
        k = tabConnectIntraR(i,j);
        x=[tabPosRight(i,1) tabPosRight(k,1)];
        y=[tabPosRight(i,2) tabPosRight(k,2)];
        if (valCorIntraR(i,j) >= 0)
            couleur = 'r';
        else
            couleur = 'b';
        end
        if (valCorMax-valCorMin) <=0
            epaisseur = 1;
        else
            epaisseur = 0.5+PG_coefEpaisseurLigne*(abs(valCorIntraR(i,j))-valCorMin)/(valCorMax-valCorMin);
        end
        plot(x, y, 'Color', couleur, 'LineWidth', epaisseur);
    end
    
    % Plot positions with structure names on the right hemisphere
    %------------------------------------------------------------------
    angle = 90-i*angle_interval+angle_interval/2;
    taillePoint = (nbConnectIntraSumR(i)+1)/PG_coefTaillePoint;
    %taillePoint = PG_rayon/PG_coefTaillePointMini+PG_rayon/PG_coefTaillePointInc*nbConnectIntraSumR(i)/maxNbConnect;
    rectangle('Position', [tabPosRight(i,1)-taillePoint/2 tabPosRight(i,2)-taillePoint/2 taillePoint taillePoint],...
              'Curvature', [1 1], 'EdgeColor', 'k', 'FaceColor', 'k');
    text((tabPosRight(i,1)-1)*PG_coefRayonTxt+1, (tabPosRight(i,2)-1)*PG_coefRayonTxt+1, NomStructInit{i}, 'Color', 'k',...
         'FontSize', PG_tailleTxtStr, 'HorizontalAlignment', 'left', 'Rotation', angle);

    % Draw connections on the left hemisphere
    %---------------------------------------
    for j=1:nbConnectIntraL(i)
        k = tabConnectIntraL(i,j);
        x=[tabPosLeft(i,1) tabPosLeft(k,1)];
        y=[tabPosLeft(i,2) tabPosLeft(k,2)];
        if (valCorIntraL(i,j) >= 0)
            couleur = 'r';
        else
            couleur = 'b';
        end
        if (valCorMax-valCorMin) <=0
            epaisseur = 1;
        else
            epaisseur = 0.5+PG_coefEpaisseurLigne*(abs(valCorIntraL(i,j))-valCorMin)/(valCorMax-valCorMin);
        end
        plot(x, y, 'Color', couleur, 'LineWidth', epaisseur);
    end
    
    % Plot positions with structure names on the left hemisphere
    %-------------------------------------------------------------------
    angle = 90+i*angle_interval-angle_interval/2;
    taillePoint = (nbConnectIntraSumL(i)+1)/PG_coefTaillePoint;
    %taillePoint = PG_rayon/PG_coefTaillePointMini+PG_rayon/PG_coefTaillePointInc*nbConnectIntraSumL(i)/maxNbConnect;
    rectangle('Position', [tabPosLeft(i,1)-taillePoint/2 tabPosLeft(i,2)-taillePoint/2 taillePoint taillePoint], ...
              'Curvature', [1 1], 'EdgeColor', 'k', 'FaceColor', 'k');
    text((tabPosLeft(i,1)-1)*PG_coefRayonTxt+1, (tabPosLeft(i,2)-1)*PG_coefRayonTxt+1, NomStructInit{i+nbROI}, 'Color', 'k',...
         'FontSize', PG_tailleTxtStr, 'HorizontalAlignment', 'right', 'Rotation', angle-180);
end

% INTRA: Add title, draw dashed midline, and group ROIs
%========================================================================
text(-0.4,2.3,titre, 'FontSize', PG_tailleTxtTitre);
plot([1 1], [0 2], 'Color', 'k', 'LineWidth', 0.5, 'LineStyle', ':');
PBCT_AfficheNetwork_GroupesROI;

% Save resIntra figure as a JPG file
%======================================
nomFicJPG = strcat(DataRep,titre,'_resIntra.jpg');
saveas(gcf,nomFicJPG);


% INTER :  Create figure 
%=========================
HfigInter = figure('Name', 'Network INTER','NumberTitle','off', 'Color', 'w', 'Position', [150 -50 800 800]);
hold on
axis equal off
axis([-0.1 2.1 -0.1 2.1]);
if PG_flagVisuNetwork_cercle
    rectangle('Position', [0 0 PG_rayon PG_rayon], 'Curvature', [1 1]);
end


% INTER : Draw connections on the circle, then plot structure positions
%=========================================================================
for i=1:nbROI
    % Draw connections between the two hemispheres
    %-----------------------------------------
    for j=1:nbConnectInterL(i)
        k = tabConnectInterL(i,j);
        x=[tabPosLeft(i,1) tabPosRight(k,1)];
        y=[tabPosLeft(i,2) tabPosRight(k,2)];
        if (valCorInterL(i,j) >= 0)
            couleur = 'r';
        else
            couleur = 'b';
        end
        if (valCorMax-valCorMin) <=0
            epaisseur = 1;
        else
            epaisseur = 0.5+PG_coefEpaisseurLigne*(abs(valCorInterL(i,j))-valCorMin)/(valCorMax-valCorMin);
        end
        plot(x, y, 'Color', couleur, 'LineWidth', epaisseur);
    end
end
for i=1:nbROI
    % Plot positions with structure names on the right hemisphere
    %------------------------------------------------------------------
    angle = 90-i*angle_interval+angle_interval/2;
    taillePoint = (nbConnectInterR(i)+1)/PG_coefTaillePoint;
    %taillePoint = PG_rayon/PG_coefTaillePointMini+PG_rayon/PG_coefTaillePointInc*nbConnectInterR(i)/maxNbConnect;
    rectangle('Position', [tabPosRight(i,1)-taillePoint/2 tabPosRight(i,2)-taillePoint/2 taillePoint taillePoint],...
              'Curvature', [1 1], 'EdgeColor', 'k', 'FaceColor', 'k');
    text((tabPosRight(i,1)-1)*PG_coefRayonTxt+1, (tabPosRight(i,2)-1)*PG_coefRayonTxt+1, NomStructInit{i}, 'Color', 'k',...
         'FontSize', PG_tailleTxtStr, 'HorizontalAlignment', 'left', 'Rotation', angle);
    
    % Plot positions with structure names on the left hemisphere
    %-------------------------------------------------------------------
    angle = 90+i*angle_interval-angle_interval/2;
    taillePoint = (nbConnectInterL(i)+1)/PG_coefTaillePoint;
    %taillePoint = PG_rayon/PG_coefTaillePointMini+PG_rayon/PG_coefTaillePointInc*nbConnectInterL(i)/maxNbConnect;
    rectangle('Position', [tabPosLeft(i,1)-taillePoint/2 tabPosLeft(i,2)-taillePoint/2 taillePoint taillePoint], ...
              'Curvature', [1 1], 'EdgeColor', 'k', 'FaceColor', 'k');
    text((tabPosLeft(i,1)-1)*PG_coefRayonTxt+1, (tabPosLeft(i,2)-1)*PG_coefRayonTxt+1, NomStructInit{i+nbROI}, 'Color', 'k',...
         'FontSize', PG_tailleTxtStr, 'HorizontalAlignment', 'right', 'Rotation', angle-180);
end

% INTER : Add title, draw dashed midline, and group ROIs
%========================================================================
text(-0.4,2.3,titre, 'FontSize', PG_tailleTxtTitre);
plot([1 1], [0 2], 'Color', 'k', 'LineWidth', 0.5, 'LineStyle', ':');
PBCT_AfficheNetwork_GroupesROI;     

% Save resInter figure as a JPG file
%======================================
nomFicJPG = strcat(DataRep,titre,'_resInter.jpg');
saveas(gcf,nomFicJPG);

% Write INTRA connection count to Excel file (sheet 4)
%========================================================

% Write INTER connection count to Excel file (sheet 5)
%========================================================

% Clear memory
%====================
clear i j k n x y angle nomS nomSC couleur epaisseur
clear nbConnectIntraSumR nbConnectIntraSumL
clear nbConnectInterR nbConnectInterL nbConnectIntraR nbConnectIntraL
clear tabConnectInterR tabConnectInterL tabConnectIntraR tabConnectIntraL
clear valCorInterR valCorInterL valCorIntraR valCorIntraL
clear maxNbConnectIntraR maxNbConnectIntraL maxNbConnectInterR maxNbConnectInterL
clear maxNbConnectIntra maxNbConnectInter maxNbConnect
clear nbConnectInterSumRPos nbConnectInterSumRNeg nbConnectInterSumLPos nbConnectInterSumLNeg
clear nbConnectIntraSumRPos nbConnectIntraSumRNeg nbConnectIntraSumLPos nbConnectIntraSumLNeg
clear nbConnectTri IndexTri NomTri
clear DataExcel
clear HfigInter HfigIntra

