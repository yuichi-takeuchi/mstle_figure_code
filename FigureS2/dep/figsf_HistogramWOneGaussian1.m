function [ flag ] = figsf_HistogramWOneGaussian1( data, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase)
%
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;
fignum = 1;

binWidth = 0.1;

numGaussian = 1;
gmdist = fitgmdist(data, numGaussian);
gmsigma = gmdist.Sigma;
gmmu = gmdist.mu;
gmwt = gmdist.ComponentProportion;
x = linspace(-1, 1, 1000);
fitdata = pdf(gmdist, x')*gmwt(1)*binWidth;

% building a plot
[ hs ] = figf_HistogramWOneFit1( data, x, fitdata, fignum ); % data1, data2, fignum

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
set(hs.hp,...
    'Color', colorMat(2,:)...
    );

set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end
flag = 1;