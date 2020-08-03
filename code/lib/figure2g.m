function [sBasicStatsSub, sStatsTestSub, No] = figure2g()
% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts statistical analyses and bar graph outputs of
% summarized data in csv (control vs. treatment)
% Copyright(c) 2018, 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 2;
fgNo = 641;
panel = 'G';
control = 'Open';
graphSuffix = 'Hz';
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_' control 'LoopStim_PooledOnOff.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Data import 2
subTbTh = readtable(['tmp/Figure' num2str(figureNo) '_subTbTh.csv']);

%% Basic statistics and Statistical tests
% sub
[ sBasicStatsSub, sStatsTestSub ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );

%% Figure preparation (clustered)
colorMat = [0 0 0; 1 0 0]; % RGB
% Common labelings
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

% MS Estim
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Sub' control 'Loop_Pooled' graphSuffix '_'];
[ flag ] = figsf_BarScatPairedGray2( subTbTh, VarNames, sBasicStatsSub, CTitle, CVLabel, colorMat, outputGraph, outputFileNameBase);
for i = 1:length(VarNames)
    movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
    movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
end
clear flag outputFileNameBase; close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSub', 'sStatsTestSub', 'No', '-v7.3')

end