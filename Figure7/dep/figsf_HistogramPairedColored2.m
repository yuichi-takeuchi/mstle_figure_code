function [ flag ] = figsf_HistogramPairedColored2( srcTable, VarNames, CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase)
%
% for classical side-by-side histograms
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
% instantaneous graph
for i = 1:length(VarNames)
    Off = srcTable.(VarNames{i})(srcTable.(10) == 0);
    On  = srcTable.(VarNames{i})(srcTable.(10) == 1);
    edges = [0:10:120];
    
    h1 = histcounts(Off, edges, 'Normalization', 'probability');
    h2 = histcounts(On, edges, 'Normalization', 'probability');

    % building a plot
    [ hs ] = figf_BarPlot1(edges(1:end-1), [h1;h2]', i);
     
    % setting parametors of bars and plots
    hs.hb(1).BarWidth = 1;
    hs.hb(2).BarWidth = 1;
    hs.hb(1).FaceColor = colorMat(1,:);
    hs.hb(2).FaceColor = colorMat(2,:);

    set(hs.hylabel, 'String', CVLabel{i});
    set(hs.hxlabel, 'String', CHLabel{i});
    set(hs.htitle, 'String', CTitle{i});
    hs.hlgnd = legend(CLeg);
    
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
        'FontName', fontname,...
        'FontSize', fontsize...
        );
    
    set(hs.hlgnd,...
        'Location', 'northeast',...
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