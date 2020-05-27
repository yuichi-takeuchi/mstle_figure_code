function [ flag ] = figsf_3ANOVAColorMat1( sBasicStats, dataVarNames, condVec, control, CTitle, CVLabel, CLeg, colorMat, outputGraph, outputFileNameBase)
%
% control: 0 for open-loop and 1 for closed-loop
%
% Copyright (c) Yuichi Takeuchi 2018, 2019

close all
flag = 0;
for i = 1:length(dataVarNames)
    Mean = sBasicStats(i).Mean;
    Std = sBasicStats(i).Std;
    
    % building a plot
    [ hs ] = figf_PlotWEBLegend1( condVec, Mean', Std', CLeg, i); % srcMatX, srcMatY, srcMatEB, legendstr, fignum
    
    % setting parametors of bars and plots
    set(hs.heb, 'LineWidth', 0.75, 'MarkerSize', 4);
    set(hs.heb(1), 'YNegativeDelta',[], 'Color', colorMat(1,:));
    set(hs.heb(2), 'YNegativeDelta',[], 'LineStyle', '--', 'Color', colorMat(2,:));
    set(hs.heb(3), 'YNegativeDelta',[], 'LineStyle', '--', 'Color', colorMat(3,:));
    set(hs.hylabel, 'String', CVLabel{i});
    if(control)
        set(hs.hxlabel, 'String', 'MS stimulation delay (ms)'); 
    else
        set(hs.hxlabel, 'String', 'MS stimulation frequency (Hz)');
    end
    set(hs.htitle, 'String', CTitle{i});

    % global arameters
    fontname = 'Arial';
    fontsize = 5;

    % figure parameter settings
    set(hs.hfig,...
        'PaperUnits', 'centimeters',...
        'PaperPosition', [0.5 0.5 4 4],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [5 5]... % width, height
        );

    % axis parameter settings
    yl = get(hs.hax, 'YLim');
    set(hs.hax,...
        'XLim', [min(condVec)-3, max(condVec)+3],...
        'XTick', condVec',...
        'YLim', [0, yl(2)],...
        'FontName', fontname,...
        'FontSize', fontsize...
        );

    % outputs
    if outputGraph(1)
        print([outputFileNameBase dataVarNames{i} '.pdf'], '-dpdf');
    end
    if outputGraph(2)
        print([outputFileNameBase dataVarNames{i} '.png'], '-dpng');
    end
end
flag = 1;