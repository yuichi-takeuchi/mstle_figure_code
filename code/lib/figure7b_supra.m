function [sBasicStats, sStatsTest, pkstest2, No] = figure7b_supra()
% Prepares cumulative distribution analysis, statistics of
% dulation of HPC electrographic seizure
% summarized data in csv (control vs. treatment)
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 7;
fgNo = 641;
panel = 'B';
subpanel = 'supra';
control = 'Open';
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_' subpanel '_HPCDistribution.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Data extraction for Histogram and Cummurative curve of HPC electrograhic seiuzures
% getting parameters (supra)
supraOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
supraOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
% Kolmogorv smirnov 2 sample test
[~,pkstest2] = kstest2(supraOff, supraOn);

%% Histogram figure preparation
% parameters
CTitle = {'HPC electrographic seizure'};
CVLabel = {'Probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

colorMat = [1 1 1; 0.25 0.25 0.25]; % supra
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Supra' control 'Loop_Dist_'];
[ flag ] = figsf_HistogramPairedColored2( supraTb, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase VarNames{4} '.pdf'], ['../results/' outputFileNameBase VarNames{4} '.pdf'])
movefile([outputFileNameBase VarNames{4} '.png'], ['../results/' outputFileNameBase VarNames{4} '.png'])
close all

%% Cumurative cureve calculation
% cumurative probability parameters
edges = [0:1:120];
edgesX = edges(1:end-1);

% supra
supraOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
supraOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
N1 = histcounts(supraOff, edges, 'Normalization', 'probability');
N2 = histcounts(supraOn, edges, 'Normalization', 'probability');
cumsum1 = cumsum(N1);
cumsum2 = cumsum(N2);
cumsumSupra = [cumsum1;cumsum2];

%% Cumurative curve figure preparation
% figure parameters
CTitle = {'HPC electrographic seizure'};
CVLabel = {'Cumulative probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 0; 0.40 0.40 0.40]; % supra
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Supra' control 'Loop_CumProb_'];
[ flag ] = figsf_PlotPairedColored1( edgesX, cumsumSupra, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase VarNames{4} '.pdf'], ['../results/' outputFileNameBase VarNames{4} '.pdf'])
movefile([outputFileNameBase VarNames{4} '.png'], ['../results/' outputFileNameBase VarNames{4} '.png'])
close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'pkstest2', 'No', '-v7.3')
disp('done')

end
