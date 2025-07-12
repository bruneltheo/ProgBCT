%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_VISU_Affichage                                         %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2023 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

% Plot structures on the INTRA LEFT background image
%=====================================================
if Wid_toggleVisuIntraL.Value == 0
    hFigIntraL.Visible = 'off';
else
    % image visibility
    %------------------
    hFigIntraL.Visible = 'on';
    figure(hFigIntraL);
    cla
    imshow(imgIntraL);
    hold on
    
    % Plot all reference structures  
    % Otherwise, only plot those that are used

    %---------------------------------------------
    if PG_VISU_FlagAllStruct == 1
        for i=1:DefStrIntraL.Nb
            xpos = DefStrIntraL.x(i)-PG_VISU_Rayon;
            ypos = DefStrIntraL.y(i)-PG_VISU_Rayon;
            color = [DefStrIntraL.RVB(i,1) DefStrIntraL.RVB(i,2) DefStrIntraL.RVB(i,3)];
            rectangle('Position', [xpos ypos 2*PG_VISU_Rayon 2*PG_VISU_Rayon], 'Curvature', [1 1], 'EdgeColor', color, 'FaceColor', color);
            if PG_VISU_FlagNomStruct == 1
            	text(xpos+PG_VISU_Rayon, ypos+PG_VISU_Rayon, DefStrIntraL.nom(i), 'Color', 'k',...
                     'FontSize', PG_VISU_TailleTxt, 'HorizontalAlignment', 'center');
            end
        end
    end
    
    % Plot used structures
    %-------------------------------
    for i=1:DefStrIntraL.nbConnect
        % First structure (source)
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        i1 = DefStrIntraL.tabConnect(i,1);
        xpos1 = DefStrIntraL.x(i1)-PG_VISU_Rayon;
        ypos1 = DefStrIntraL.y(i1)-PG_VISU_Rayon;
        % Second structure (target)
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~
        i2 = DefStrIntraL.tabConnect(i,2);
        xpos2 = DefStrIntraL.x(i2)-PG_VISU_Rayon;
        ypos2 = DefStrIntraL.y(i2)-PG_VISU_Rayon;
        % Plot connections if requested, then plot structures
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if PG_VISU_FlagLienStruct == 1
            x=[xpos1+PG_VISU_Rayon xpos2+PG_VISU_Rayon];
            y=[ypos1+PG_VISU_Rayon ypos2+PG_VISU_Rayon];
            plot(x, y, 'Color', 'k', 'LineWidth', 1);
        end
        color = [DefStrIntraL.RVB(i1,1) DefStrIntraL.RVB(i1,2) DefStrIntraL.RVB(i1,3)];
        rectangle('Position', [xpos1 ypos1 2*PG_VISU_Rayon 2*PG_VISU_Rayon], 'Curvature', [1 1], 'EdgeColor', color, 'FaceColor', color);
        if PG_VISU_FlagNomStruct == 1
            text(xpos1+PG_VISU_Rayon, ypos1+PG_VISU_Rayon, DefStrIntraL.nom(i1), 'Color', 'k',...
                 'FontSize', PG_VISU_TailleTxt, 'HorizontalAlignment', 'center');
        end
        color = [DefStrIntraL.RVB(i2,1) DefStrIntraL.RVB(i2,2) DefStrIntraL.RVB(i2,3)];
        rectangle('Position', [xpos2 ypos2 2*PG_VISU_Rayon 2*PG_VISU_Rayon], 'Curvature', [1 1], 'EdgeColor', color, 'FaceColor', color);
        if PG_VISU_FlagNomStruct == 1
            text(xpos2+PG_VISU_Rayon, ypos2+PG_VISU_Rayon, DefStrIntraL.nom(i2), 'Color', 'k',...
                 'FontSize', PG_VISU_TailleTxt, 'HorizontalAlignment', 'center');
        end
    end
end



% Plot structures on the INTRA RIGHT background image
%======================================================
if Wid_toggleVisuIntraR.Value == 0
    hFigIntraR.Visible = 'off';
else
    % image visibility
    %------------------
    hFigIntraR.Visible = 'on';
    figure(hFigIntraR);
    cla
    imshow(imgIntraR);
    hold on
    
    % Plot all reference structures  
    % Otherwise, only plot those that are used
    %---------------------------------------------
    if PG_VISU_FlagAllStruct == 1
        for i=1:DefStrIntraR.Nb
            xpos = DefStrIntraR.x(i)-PG_VISU_Rayon;
            ypos = DefStrIntraR.y(i)-PG_VISU_Rayon;
            color = [DefStrIntraR.RVB(i,1) DefStrIntraR.RVB(i,2) DefStrIntraR.RVB(i,3)];
            rectangle('Position', [xpos ypos 2*PG_VISU_Rayon 2*PG_VISU_Rayon], 'Curvature', [1 1], 'EdgeColor', color, 'FaceColor', color);
            if PG_VISU_FlagNomStruct == 1
            	text(xpos+PG_VISU_Rayon, ypos+PG_VISU_Rayon, DefStrIntraR.nom(i), 'Color', 'k',...
                     'FontSize', PG_VISU_TailleTxt, 'HorizontalAlignment', 'center');
            end
        end
    end
    % Plot used structures
    %-------------------------------
    for i=1:DefStrIntraR.nbConnect
        % First structure (source)
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        i1 = DefStrIntraR.tabConnect(i,1);
        xpos1 = DefStrIntraR.x(i1)-PG_VISU_Rayon;
        ypos1 = DefStrIntraR.y(i1)-PG_VISU_Rayon;
        % Second structure (target)
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~
        i2 = DefStrIntraR.tabConnect(i,2);
        xpos2 = DefStrIntraR.x(i2)-PG_VISU_Rayon;
        ypos2 = DefStrIntraR.y(i2)-PG_VISU_Rayon;
        % Plot connections if requested, then plot structures
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if PG_VISU_FlagLienStruct == 1
            x=[xpos1+PG_VISU_Rayon xpos2+PG_VISU_Rayon];
            y=[ypos1+PG_VISU_Rayon ypos2+PG_VISU_Rayon];
            plot(x, y, 'Color', 'k', 'LineWidth', 1);
        end
        color = [DefStrIntraR.RVB(i1,1) DefStrIntraR.RVB(i1,2) DefStrIntraR.RVB(i1,3)];
        rectangle('Position', [xpos1 ypos1 2*PG_VISU_Rayon 2*PG_VISU_Rayon], 'Curvature', [1 1], 'EdgeColor', color, 'FaceColor', color);
        if PG_VISU_FlagNomStruct == 1
            text(xpos1+PG_VISU_Rayon, ypos1+PG_VISU_Rayon, DefStrIntraR.nom(i1), 'Color', 'k',...
                 'FontSize', PG_VISU_TailleTxt, 'HorizontalAlignment', 'center');
        end
        color = [DefStrIntraR.RVB(i2,1) DefStrIntraR.RVB(i2,2) DefStrIntraR.RVB(i2,3)];
        rectangle('Position', [xpos2 ypos2 2*PG_VISU_Rayon 2*PG_VISU_Rayon], 'Curvature', [1 1], 'EdgeColor', color, 'FaceColor', color);
        if PG_VISU_FlagNomStruct == 1
            text(xpos2+PG_VISU_Rayon, ypos2+PG_VISU_Rayon, DefStrIntraR.nom(i2), 'Color', 'k',...
                 'FontSize', PG_VISU_TailleTxt, 'HorizontalAlignment', 'center');
        end
    end
end



% Clear memory
%====================
clear fid i i1 i2 x xpos xpos1 xpos2 y ypos ypos1 ypos2 color

