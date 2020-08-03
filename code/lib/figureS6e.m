function [sBasicStatsSupra, sStatsTestSupra, No] = figureS6e()
% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts statistical analyses and bar graph outputs of
% summarized data in csv (control vs. treatment)
% Copyright(c) 2018, 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 6;
fgNo = 602;
panel = 'E';
control = 'Open';
graphSuffix = 'Hz';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' supplement num2str(figureNo) panel '_' control 'LoopStim_PooledOnOff.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Figure preparation (non-clustered)
% Common labelings 
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

% supra
outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Supra' control 'Loop_Pooled' graphSuffix '_'];
[ flag ] = figsf_BarScatPairedOpt1( supraTb, VarNames, sBasicStatsSupra, CTitle, CVLabel, outputGraph, outputFileNameBase);
for i = 1:length(VarNames)
    movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
    movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
end
close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSupra', 'sStatsTestSupra', 'No', '-v7.3')

end
