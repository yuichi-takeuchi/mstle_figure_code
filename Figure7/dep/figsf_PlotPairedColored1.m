function [ flag ] = figsf_PlotPairedColored1( srcX, srcMatY, VarNames, CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase)
%
% 
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
for i = 1:length(VarNames)
    fignum = 1;

    % building a plot
    [ hs ] = figf_PlotWLegend1( srcX, srcMatY, CLeg, i);

    % setting parametors of bars and plots
    set(hs.hp, 'LineWidth', 0.5);
    set(hs.hp(1), 'Color', colorMat(1,:), 'Marker', 'none');
    set(hs.hp(2), 'Color', colorMat(2,:), 'Marker', 'none');
    set(hs.hylabel, 'String', CVLabel{i});
    set(hs.hxlabel, 'String', CHLabel{i});
    set(hs.htitle, 'String', CTitle{i});

    % global parameters
    fontname = 'Arial';
    fontsize = 5;

    % figure parameter settings
    set(hs.hfig,...
        'PaperUnits', 'centimeters',...
        'PaperPosition', [0.5 0.5 5 4],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [6 5]... % width, height
        );

    % axis parameter settings
    set(hs.hax,...
        'XLim', [-7.5 127.5],...
        'XTick', [0:20:120],...
        'YLim', [0 1],...
        'FontName', fontname,...
        'FontSize', fontsize...
        );

    set(hs.hlgnd,...
        'Location', 'southeast',...
        'FontName', fontname,...
        'FontSize', fontsize,...
        'Box', 'off');
    
    % outputs
    if outputGraph(1)
        print([outputFileNameBase VarNames{i} '.pdf'], '-dpdf');
    end
    if outputGraph(2)
        print([outputFileNameBase VarNames{i} '.png'], '-dpng');
    end
end
flag = 1;
