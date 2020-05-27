function [ flag ] = figsf_BarScatPairedGray1( srcTable, VarNames, sBasicStats, CTitle, CVLabel, outputGraph, outputFileNameBase)
%
% 
% (c) Yuichi Takeuchi 2018

close all
flag = 0;
for i = 1:length(VarNames)
    Off = srcTable.(VarNames{i})(srcTable.MSEstm == 0);
    On  = srcTable.(VarNames{i})(srcTable.MSEstm == 1);
    
    % building a plot
    [ hs ] = figf_BarPlotPaired1( sBasicStats(i).Mean, [Off'; On'], i ); % srcVecBar, srcMatScat, fignum
 
    % setting parametors of bars and plots
    set(hs.hb,'EdgeColor',[0 0 0],'LineWidth', 0.5);
    set(hs.hb(1), 'FaceColor',[1 1 1]);
    set(hs.hb(2), 'FaceColor',[0.5 0.5 0.5]);
    
    set(hs.hp, 'LineWidth', 0.5, 'MarkerSize', 4);
    set(hs.hylabel, 'String', CVLabel{i});
    set(hs.hxlabel, 'String', 'Estim');
    set(hs.htitle, 'String', CTitle{i});
    
    % global parameters
    fontname = 'Arial';
    fontsize = 5;

    % figure parameter settings
    set(hs.hfig,...
        'PaperUnits', 'centimeters',...
        'PaperPosition', [0.5 0.5 4 4],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [5 5]... % width, height
        );

    % patch
    yl = get(hs.hax, 'YLim');
    % set(hs.h.ptch, 'YData', [yl(1); yl(1); yl(2); yl(2)]);
    
    % axis parameter settings
    set(hs.hax,...
        'YLim', yl,...
        'XLim', [0.5 2.5],...
        'XTick', [1 2],...
        'XTickLabel', {'Off', 'On'},...
        'FontName', fontname,...
        'FontSize', fontsize...
        );

    % outputs
    if outputGraph(1)
        print([outputFileNameBase VarNames{i} '.pdf'], '-dpdf');
    end
    if outputGraph(2)
        print([outputFileNameBase VarNames{i} '.png'], '-dpng');
    end
end
flag = 1;