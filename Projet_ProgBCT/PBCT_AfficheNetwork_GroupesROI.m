%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_AfficheNetwork_GroupesROI                              %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

if PG_flagVisuNetwork_groupesROI && nbRegionStr > 0
    for i=1:nbRegionStr
        % Right hemisphere for bilateral mode (Bi), full circle for unilateral mode (Mono)
        %------------------------------------------------------
        angle = 90-regionStr(i).ind(1)*angle_interval+angle_interval/2+PG_angleOffsetReg;
        x(1) = cosd(angle)*PG_coefRayonReg+1;
        y(1) = sind(angle)*PG_coefRayonReg+1;
        x(2) = (tabPosRight(regionStr(i).ind(1),1)-1)*PG_coefRayonReg+1;
        y(2) = (tabPosRight(regionStr(i).ind(1),2)-1)*PG_coefRayonReg+1;
        plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
        x(2) = cosd(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
        y(2) = sind(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
        plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
        for j=regionStr(i).ind(1):regionStr(i).ind(2)-1
            x(1) = (tabPosRight(j,1)-1)*PG_coefRayonReg+1;
            y(1) = (tabPosRight(j,2)-1)*PG_coefRayonReg+1;
            x(2) = (tabPosRight(j+1,1)-1)*PG_coefRayonReg+1;
            y(2) = (tabPosRight(j+1,2)-1)*PG_coefRayonReg+1;
            plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
        end
        angle = 90-regionStr(i).ind(2)*angle_interval+angle_interval/2-PG_angleOffsetReg;
        x(1) = cosd(angle)*PG_coefRayonReg+1;
        y(1) = sind(angle)*PG_coefRayonReg+1;
        x(2) = (tabPosRight(regionStr(i).ind(2),1)-1)*PG_coefRayonReg+1;
        y(2) = (tabPosRight(regionStr(i).ind(2),2)-1)*PG_coefRayonReg+1;
        plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
        x(2) = cosd(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
        y(2) = sind(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
        plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
        % Left hemisphere (only in bilateral mode (Bi))
        %--------------------------------------
        if ModeMonoBi == 2
            angle = 90+regionStr(i).ind(1)*angle_interval-angle_interval/2-PG_angleOffsetReg;
            x(1) = cosd(angle)*PG_coefRayonReg+1;
            y(1) = sind(angle)*PG_coefRayonReg+1;
            x(2) = (tabPosLeft(regionStr(i).ind(1),1)-1)*PG_coefRayonReg+1;
            y(2) = (tabPosLeft(regionStr(i).ind(1),2)-1)*PG_coefRayonReg+1;
            plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
            x(2) = cosd(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
            y(2) = sind(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
            plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
            for j=regionStr(i).ind(1):regionStr(i).ind(2)-1
                x(1) = (tabPosLeft(j,1)-1)*PG_coefRayonReg+1;
                y(1) = (tabPosLeft(j,2)-1)*PG_coefRayonReg+1;
                x(2) = (tabPosLeft(j+1,1)-1)*PG_coefRayonReg+1;
                y(2) = (tabPosLeft(j+1,2)-1)*PG_coefRayonReg+1;
                plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
            end
            angle = 90+regionStr(i).ind(2)*angle_interval-angle_interval/2+PG_angleOffsetReg;
            x(1) = cosd(angle)*PG_coefRayonReg+1;
            y(1) = sind(angle)*PG_coefRayonReg+1;
            x(2) = (tabPosLeft(regionStr(i).ind(2),1)-1)*PG_coefRayonReg+1;
            y(2) = (tabPosLeft(regionStr(i).ind(2),2)-1)*PG_coefRayonReg+1;
            plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
            x(2) = cosd(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
            y(2) = sind(angle)*(PG_coefRayonReg-PG_coefRepereReg)+1;
            plot(x, y, 'Color', PG_colorReg, 'LineWidth', 1);
        end
    end
end

% Clear memory
%====================
clear i j x y angle