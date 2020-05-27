function [ flag ] = figsf_HistogramWThreshold1( data, threshold, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase)
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
fignum = 1;

binWidth = 0.1;
x = linspace(-1, 1, 1000);

% building a plot
[ hs ] = figf_HistogramNormPDF1(data, fignum);

% global parameters
fontname = 'Arial';
fontsize = 5;

% figure parameter settings
set(hs.hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 4 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [5 5]... % width, height
    );

% axis parameter settings
set(hs.hax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% histgram parameter settings
set(hs.hst,...
    'BinEdges', [-1:binWidth:1],...
    'Normalization', 'probability',...
    'FaceColor', colorMat(1,:)...
    );
%     'EdgeColor', 'none');

set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

% separation line
figure(hs.hfig)
yLimits = get(gca,'YLim');
hl = line(gca, [threshold threshold], yLimits);

set(hl,...
    'LineStyle', ':',...
    'LineWidth', 1,...
    'Color', colorMat(2,:));

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end
flag = 1;