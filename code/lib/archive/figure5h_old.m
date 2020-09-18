function [sBasicStatsSupra, sStatsTestSupra, No] = figure5h()
% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts three-way ANOVA statistical analyses and graph outputs of
% summarized data in csv (control vs. treatment with conditioning, like
% delay or stimulus Hz)
% Copyright(c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 5;
fgNo = 627;
panel = 'H';
control = 'Closed';
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_' control 'LoopStim_3ANOVA.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
dataVarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
OnOffVarName = orgTb.Properties.VariableNames{10};
linearVarName = orgTb.Properties.VariableNames{12};
condVec = unique(orgTb.(12));

%% Data import 2
supraTbTh = readtable(['tmp/Figure' num2str(figureNo) '_supraTbTh.csv']);
ThrshldVarName = supraTbTh.Properties.VariableNames{23};
    
%% Basic statistics and Statistical tests
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_get3ANOVAStatsStructs1( supraTbTh, dataVarNames, OnOffVarName, linearVarName, ThrshldVarName);
close all

%% Figure preparation
% Legned
CLegend = {'Off';'On non-success'; 'On success'};
colorMat = [0 0 0; 0 0 0; 0 0 1]; % RGB
% Common labelings for graphs
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

% supra
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Supra' control 'Loop_3ANOVA_']; 
sBasicStats = sBasicStatsSupra;
[ flag ] = figsf_3ANOVAColorMat1( sBasicStats, dataVarNames, condVec, 1, CTitle, CVLabel, CLegend, colorMat, outputGraph, outputFileNameBase);
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
