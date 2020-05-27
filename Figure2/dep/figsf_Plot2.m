function [ flag ] = figsf_Plot2( srcX, srcMatY, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase)
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;

fignum = 1;

% building a plot
[ hs ] = figf_Plot1( srcX, srcMatY, fignum );

% setting parametors of bars and plots
set(hs.hp, 'LineWidth', 0.5, 'MarkerSize', 4);
set(hs.hp(1), 'Color', colorMat, 'Marker', 'o', 'MarkerFaceColor', colorMat );
set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

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
% yl = get(hs.hax, 'YLim');
% set(hs.h.ptch, 'YData', [yl(1); yl(1); yl(2); yl(2)]);
xlm = get(hs.hax,'XLim');
% axis parameter settings
set(hs.hax,...
    'FontName', fontname,...
    'FontSize', fontsize,...
    'YLim', [0 1],...
    'XLim', [xlm(1)-5 xlm(2)+5],...
    'XTick', [1 8 20]...
    );
%     'XTickLabel', {'Off', 'On'},...

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end

flag = 1;