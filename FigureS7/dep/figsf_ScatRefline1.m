function [ flag ] = figsf_ScatRefline1( xData, yData, coef, R, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase)
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
fignum = 1;
% building a plot
[ hs ] = figf_ScatRefline1( xData, yData, coef, R, fignum); % data1, data2, fignum

set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

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
    'FontSize', fontsize);

set(hs.hrl,...
    'Color', colorMat,...
    'LineWidth', 1);

set(hs.htxt,...
    'fontsize', fontsize,...
    'verticalalignment', 'top',...
    'horizontalalignment', 'left');

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end
flag = 1;