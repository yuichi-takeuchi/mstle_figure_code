function [sBasicStats, sStatsTest, pkstest2, No] = figure7c_sub()
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 7;
panel = 'c';
subpanel = 'sub';
inputFileName = 'Figure2_Fg641_OpenLoopStim.csv';
outputFileName = ['figure' num2str(figureNo) panel '_' subpanel '.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );

%% Data extraction for Histogram and Cummurative curve of HPC electrograhic seiuzures
subOff = subTb.(VarNames{5})(logical(subTb.(10)) == false);
subOn  = subTb.(VarNames{5})(logical(subTb.(10)) == true);
% Kolmogorv smirnov 2 sample test
[~,pkstest2] = kstest2(subOff, subOn);

%% Histogram figure preparation
% parameters
CTitle = {'Ctx electrographic seizure'};
CVLabel = {'Probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

colorMat = [1 1 1; 1 0 0]; % sub
outputFileNameBase = ['figure' num2str(figureNo) panel '_' subpanel '_hist'];
[ flag ] = figsf_HistogramPairedColored2( subTb, VarNames(5), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase VarNames{5} '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase VarNames{5} '.png'], ['../results/' outputFileNameBase '.png'])
close all

%% Cumurative cureve calculation
% cumurative probability parameters
edges = [0:1:120];
edgesX = edges(1:end-1);

subOff = subTb.(VarNames{5})(logical(subTb.(10)) == false);
subOn  = subTb.(VarNames{5})(logical(subTb.(10)) == true);
N1 = histcounts(subOff,edges, 'Normalization', 'probability');
N2 = histcounts(subOn,edges, 'Normalization', 'probability');
cumsum1 = cumsum(N1);
cumsum2 = cumsum(N2);
cumsumSub = [cumsum1;cumsum2];

%% Cumurative curve figure preparation
% figure parameters
CTitle = {'Ctx electrographic seizure'};
CVLabel = {'Cumulative probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 0; 1 0 0]; % sub
outputFileNameBase = ['figure' num2str(figureNo) panel '_' subpanel '_cumProb'];
[ flag ] = figsf_PlotPairedColored1( edgesX, cumsumSub, VarNames(5), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase VarNames{5} '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase VarNames{5} '.png'], ['../results/' outputFileNameBase '.png'])
close all

%% Number of rats and trials
No.Rats = length(unique(subTb.LTR));
No.Trials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'pkstest2', 'No', '-v7.3')
disp('done')

end
