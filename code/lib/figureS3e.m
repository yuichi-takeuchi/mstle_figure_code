function [sBasicStatsSupra, sStatsTestSupra, No] = figureS3e()
% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts statistical analyses and bar graph outputs of
% summarized data in csv (control vs. treatment)
% Copyright(c) 2018, 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 3;
fgNo = 624;
panel = 'E';
control = 'Closed';
graphSuffix = 'Dly';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' supplement num2str(figureNo) panel '_' control 'LoopStim_PooledOnOff.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Data import 2
supraTbTh = readtable(['tmp/Figure' num2str(figureNo) '_supraTbTh.csv']);

%% Basic statistics and Statistical tests
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Figure preparation (clustered)
colorMat = [0 0 0; 0 0 1]; % RGB
% Common labelings
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

% supra
outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Supra' control 'Loop_Pooled' graphSuffix '_'];
[ flag ] = figsf_BarScatPairedGray2( supraTbTh, VarNames, sBasicStatsSupra, CTitle, CVLabel, colorMat, outputGraph, outputFileNameBase);
for i = 1:length(VarNames)
    movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
    movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
end
clear flag outputFileNameBase; close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSupra', 'sStatsTestSupra', 'No', '-v7.3')

end