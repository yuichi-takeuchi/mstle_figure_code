function [sBasicStats, sStatsTest, pkstest2, No] = figure7b_sub()
% This script prepare cumulative distribution analysis, statistics of
% dulation of HPC electrographic seizure
% summarized data in csv (control vs. treatment)
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 7;
fgNo = 641;
panel = 'B';
subpanel = 'sub';
control = 'Open';
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_' subpanel '_HPCDistribution.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );

%% Data extraction for Histogram and Cummurative curve of HPC electrograhic seiuzures
subOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
subOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
% Kolmogorv smirnov 2 sample test
[~,pkstest2] = kstest2(subOff, subOn);

%% Histogram figure preparation
% parameters
CTitle = {'HPC electrographic seizure'};
CVLabel = {'Probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

colorMat = [1 1 1; 1 0 0]; % sub
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Sub' control 'Loop_Dist_'];
[ flag ] = figsf_HistogramPairedColored2( subTb, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase VarNames{4} '.pdf'], ['../results/' outputFileNameBase VarNames{4} '.pdf'])
movefile([outputFileNameBase VarNames{4} '.png'], ['../results/' outputFileNameBase VarNames{4} '.png'])
close all

%% Cumurative cureve calculation
% cumurative probability parameters
edges = [0:1:120];
edgesX = edges(1:end-1);

subOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
subOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
N1 = histcounts(subOff,edges, 'Normalization', 'probability');
N2 = histcounts(subOn,edges, 'Normalization', 'probability');
cumsum1 = cumsum(N1);
cumsum2 = cumsum(N2);
cumsumSub = [cumsum1;cumsum2];

%% Cumurative curve figure preparation
% figure parameters
CTitle = {'HPC electrographic seizure'};
CVLabel = {'Cumulative probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 0; 1 0 0]; % sub
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Sub' control 'Loop_CumProb_'];
[ flag ] = figsf_PlotPairedColored1( edgesX, cumsumSub, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase VarNames{4} '.pdf'], ['../results/' outputFileNameBase VarNames{4} '.pdf'])
movefile([outputFileNameBase VarNames{4} '.png'], ['../results/' outputFileNameBase VarNames{4} '.png'])
close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'pkstest2', 'No', '-v7.3')

end