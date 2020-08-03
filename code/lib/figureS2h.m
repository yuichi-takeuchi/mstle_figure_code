function [sBasicStatsSupra, sStatsTestSupra, No] = figureS2h()
% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts two-way ANOVA statistical analyses and graph outputs of
% summarized data in csv (control vs. treatment with conditioning, like
% daly, stimulus Hz etc.
% Copyright (c) 2018, 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 2;
fgNo = 624;
panel = 'H';
control = 'Open';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' supplement num2str(figureNo) panel '_' control 'LoopStim_2ANOVA.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
dataVarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
OnOffVarName = orgTb.Properties.VariableNames{10};
linearVarName = orgTb.Properties.VariableNames{12};
condVec = unique(orgTb.(12));

%% Basic statistics and Statistical tests
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_get2ANOVAStatsStructs1( supraTb, dataVarNames, OnOffVarName, linearVarName);
close all

%% Figure preparation
% Common labelings for graphs
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

% supra
outputFileNameBase = ['Figure' supplement num2str(figureNo) '_Supra' control 'Loop_2ANOVA_']; 
[ flag ] = figsf_2ANOVAOpt1( sBasicStatsSupra, dataVarNames, condVec, 0, CTitle, CVLabel, outputGraph, outputFileNameBase);
for i = 1:length(dataVarNames)
    movefile([outputFileNameBase dataVarNames{i} '.pdf'], ['../results/' outputFileNameBase dataVarNames{i} '.pdf'])
    movefile([outputFileNameBase dataVarNames{i} '.png'], ['../results/' outputFileNameBase dataVarNames{i} '.png'])
end
close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSupra', 'sStatsTestSupra', 'No', '-v7.3')

end
