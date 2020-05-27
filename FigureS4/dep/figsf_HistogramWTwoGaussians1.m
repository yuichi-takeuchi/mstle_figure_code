function [ flag ] = figsf_HistogramWTwoGaussians1( data, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase)
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
fignum = 1;

binWidth = 0.1;

numGaussian = 2;
gmdist = fitgmdist(data, numGaussian);
gmsigma = gmdist.Sigma;
gmmu = gmdist.mu;
gmwt = gmdist.ComponentProportion;
x = linspace(-1, 1, 1000);
fit1 = pdf(gmdist, x')*binWidth;
fit2 = pdf('Normal', x, gmmu(1), gmsigma(1)^0.5)*gmwt(1)*binWidth;
fit3 = pdf('Normal', x, gmmu(2), gmsigma(2)^0.5)*gmwt(2)*binWidth;

% building a plot
[ hs ] = figf_HistogramWThreeFits1( data, x, fit1, fit2, fit3, fignum ); % data1, data2, fignum

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

% fitting curve parameter settings
set(hs.hp1,...
    'Color', colorMat(2,:)...
    );

set(hs.hp2,...
    'LineStyle', '--',...
    'LineWidth', 1,...
    'Color', colorMat(3,:)...
    );

set(hs.hp3,...
    'LineStyle', '--',...
    'LineWidth', 1,...
    'Color', colorMat(4,:)...
    );

set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

% separation line
[ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( data );
figure(hs.hfig)
yLimits = get(gca,'YLim');
hl = line(gca, [x(indForSeparation) x(indForSeparation)], yLimits);

set(hl,...
    'LineStyle', ':',...
    'LineWidth', 1,...
    'Color', [0 0 0]);

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end
flag = 1;