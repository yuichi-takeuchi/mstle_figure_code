function [sBasicStats, sStatsTest, pkstest2, No] = figure7b_sub()
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 7;
panel = 'b';
subpanel = 'sub';
inputFileName = 'Figure2_Fg641_OpenLoopStim.csv';
outputFileName = ['figure' num2str(figureNo) panel '_' subpanel '.mat'];

%% Data import
srcTb = readtable(['../data/' inputFileName]); % original csv data
Tb = srcTb(~logical(srcTb.Supra),:); % 
VarNames = srcTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );

%% Data extraction for Histogram and Cummurative curve of HPC electrograhic seiuzures
Off = Tb.CtxDrtn(Tb.MSEstm == false);
On  = Tb.CtxDrtn(Tb.MSEstm == true);
% Kolmogorv smirnov 2 sample test
[~,pkstest2] = kstest2(Off, On);

%% Histogram figure preparation
hfig = figure(1);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 5 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [6 5]... % width, height
    );

edges = 0:10:80;
h1 = histcounts(Off, edges, 'Normalization', 'probability');
h2 = histcounts(On, edges, 'Normalization', 'probability');

% building a plot
hax = axes;
[ hs ] = figf_BarPlot2(hax, edges(1:end-1), [h1;h2]');

% setting parametors of bars and plots
set(hs.bar, 'BarWidth', 1)
hs.bar(1).FaceColor = [1 1 1];
hs.bar(2).FaceColor = [1 0 0];

set(hs.xlbl, 'String', 'Duration (s)');
set(hs.ylbl, 'String', 'Probability');
set(hs.ttl, 'String', 'Ctx electrographic seizure');
hs.lgnd = legend({'Off', 'On'});

% global parameters
fontname = 'Arial';
fontsize = 5;

% axis parameter settings
set(hs.ax,...
    'XLim', [-5 85],...
    'XTick', 0:10:80,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(hs.lgnd,...
    'Location', 'northeast',...
    'FontName', fontname,...
    'FontSize', fontsize,...
    'Box', 'off');

% outputs
print(['../results/figure' num2str(figureNo) panel '_' subpanel '_hist.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel '_' subpanel '_hist.png'], '-dpng');

close all


%% Cumurative curve figure preparation
hfig = figure(2);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 5 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [6 5]... % width, height
    );

CVLabel = {'Cumulative probability'};
colorMat = [0 0 0; 1 0 0]; % sub

hax = axes;

edges = 0:80;
N1 = histcounts( Off, edges, 'Normalization', 'probability');
N2 = histcounts( On, edges, 'Normalization', 'probability');
Cumsum = [cumsum(N1); cumsum(N2)]';

edgesX = edges(1:end-1);
[ hs ] = figf_PlotWLegend3(hax, edgesX, Cumsum, {'Off', 'On'});

% setting parametors of bars and plots
set(hs.plt, 'LineWidth', 0.5);
set(hs.plt(1), 'Color', [0 0 0]);
set(hs.plt(2), 'Color', [1 0 0]);

set(hs.ylbl, 'String', 'Cumulative probability');
set(hs.xlbl, 'String', 'Duration (s)');
set(hs.ttl, 'String', 'Ctx electrographic seizure');

% global parameters
fontname = 'Arial';
fontsize = 5;

% axis parameter settings
set(hs.ax,...
    'XLim', [-5 85],...
    'XTick', 0:10:80,...
    'YLim', [0 1],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(hs.lgnd,...
    'Location', 'southeast',...
    'FontName', fontname,...
    'FontSize', fontsize,...
    'Box', 'off');

% outputs
print(['../results/figure' num2str(figureNo) panel '_' subpanel '_cumProb.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel '_' subpanel '_cumProb.png'], '-dpng');

%% Number of rats and trials
No.Rats = numel(unique(Tb.LTR));
No.Trials = height(Tb);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'pkstest2', 'No', '-v7.3')
disp('done')

end
