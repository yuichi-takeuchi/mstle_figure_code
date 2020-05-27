function [ flag ] = figsf_HistogramPairedColored1( srcTable, VarNames, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase)
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
% instantaneous graph
for i = 1:length(VarNames)
    Off = srcTable.(VarNames{i})(srcTable.(10) == 0);
    On  = srcTable.(VarNames{i})(srcTable.(10) == 1);

    % building a plot
    [ hs ] = figf_HistogramPaired1( Off, On, i ); % data1, data2, fignum
    hs.hlgnd = legend({'Off','On'});
    
    % setting parametors of bars and plots
    hs.h1.Normalization = 'probability';
    hs.h1.BinEdges = [0:5:120];
    hs.h1.FaceColor = colorMat(1,:);
    hs.h2.Normalization = 'probability';
    hs.h2.BinEdges = [0:5:120];
    hs.h2.FaceColor = colorMat(2,:);
    
    set(hs.hylabel, 'String', CVLabel{i});
    set(hs.hxlabel, 'String', CHLabel{i});
    set(hs.htitle, 'String', CTitle{i});
    
    % global parameters
    fontname = 'Arial';
    fontsize = 5;

    % figure parameter settings
    set(hs.hfig,...
        'PaperUnits', 'centimeters',...
        'PaperPosition', [0.5 0.5 5 5],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [6 6]... % width, height
        );
    
    % axis parameter settings
    set(hs.hax,...
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