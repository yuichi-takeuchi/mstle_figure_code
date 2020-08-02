function [sBasicStatsSub, sStatsTestSub, No] = figure2i()
% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% Conducts three-way ANOVA statistical analyses and graph outputs of
% summarized data in csv (control vs. treatment with conditioning, like
% delay or stimulus Hz)
% Copyright(c) Yuichi Takeuchi 2019, 2020

%% params
figureNo = 2;
fgNo = 641;
panel = 'I';
control = 'Open';
inputFileName = ['../data/Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['../results/Figure' num2str(figureNo) panel '_' control 'LoopStim_3ANOVA.mat'];

%% Data import 1
orgTb = readtable(inputFileName); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
dataVarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
OnOffVarName = orgTb.Properties.VariableNames{10};
linearVarName = orgTb.Properties.VariableNames{12};
condVec = unique(orgTb.(12));

%% Data import 2
subTbTh = readtable(['tmp/Figure' num2str(figureNo) '_subTbTh.csv']);
ThrshldVarName = subTbTh.Properties.VariableNames{23};

%% Basic statistics and Statistical tests
% sub
[ sBasicStatsSub, sStatsTestSub ] = statsf_get3ANOVAStatsStructs1( subTbTh, dataVarNames, OnOffVarName, linearVarName, ThrshldVarName);
close all

%% Figure preparation
% Legned
CLegend = {'Off';'On non-induction'; 'On induction'};
colorMat = [0 0 0; 0 0 0; 1 0 0]; % RGB
% Common labelings for graphs
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

% sub
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Sub' control 'Loop_3ANOVA_']; 
sBasicStats = sBasicStatsSub;
[ flag ] = figsf_3ANOVAColorMat1( sBasicStats, dataVarNames, condVec, 0, CTitle, CVLabel, CLegend, colorMat, outputGraph, outputFileNameBase);
for i = 1:length(dataVarNames)
    movefile([outputFileNameBase dataVarNames{i} '.pdf'], ['../results/' outputFileNameBase dataVarNames{i} '.pdf'])
    movefile([outputFileNameBase dataVarNames{i} '.png'], ['../results/' outputFileNameBase dataVarNames{i} '.png'])
end
close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);

%% Save
save(outputFileName, 'sBasicStatsSub', 'sStatsTestSub', 'No', '-v7.3')

end