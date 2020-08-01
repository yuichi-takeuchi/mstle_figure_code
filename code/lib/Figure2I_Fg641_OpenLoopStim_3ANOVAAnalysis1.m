% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts three-way ANOVA statistical analyses and graph outputs of
% summarized data in csv (control vs. treatment with conditioning, like
% delay or stimulus Hz)
% Copyright(c) Yuichi Takeuchi 2019
clc; clear; close all
%% Organizing MetaInfo
% setting parameters
FigureNo = 2;
FgNo = 641;
Panel = 'I';
bitLabel = [0 0]; % for [open or closed, estim or optogenetic]
if bitLabel(1)
    control = 'Closed';
else
    control = 'Open';
end
% building the MetaInfo structure
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Research\Scrivener\MSTLE\Figures\Figure' num2str(FigureNo) '\Analysis'],...
    'inputFileName', ['Figure' num2str(FigureNo) '_Fg' num2str(FgNo) '_' control 'LoopStim.csv'],...
    'outputFileName', ['Figure' num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_3ANOVA.mat'],...
    'mFileCopyName',  ['Figure' num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_3ANOVAAnalysis1.m'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo...
    );
clear FigureNo FgNo bitLabel control Panel

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import 1 and parameter settings
orgTb = readtable(MetaInfo.inputFileName); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
supraTb = orgTb(logical(orgTb.Supra),:); % 
dataVarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
OnOffVarName = orgTb.Properties.VariableNames{10};
linearVarName = orgTb.Properties.VariableNames{12};
condVec = unique(orgTb.(12));

%% Data import 2
condition = [0]; % 0 for sub, 1 for supra
if condition
    supraTbTh = readtable(['Figure' num2str(MetaInfo.FigureNo) '_supraTbTh.csv']);
    ThrshldVarName = supraTbTh.Properties.VariableNames{23};
else
    subTbTh = readtable(['Figure' num2str(MetaInfo.FigureNo) '_subTbTh.csv']);
    ThrshldVarName = subTbTh.Properties.VariableNames{23};
end

%% Basic statistics and Statistical tests
if condition 
    % supra
    [ sBasicStatsSupra, sStatsTestSupra ] = statsf_get3ANOVAStatsStructs1( supraTbTh, dataVarNames, OnOffVarName, linearVarName, ThrshldVarName);
else
    % sub
    [ sBasicStatsSub, sStatsTestSub ] = statsf_get3ANOVAStatsStructs1( subTbTh, dataVarNames, OnOffVarName, linearVarName, ThrshldVarName);
end
clear linearVarName OnOffVarName ThrshldVarName
close all

%% Figure preparation
% Legned
CLegend = {'Off';'On non-induction'; 'On induction'};
colorMat = [0 0 0; 0 0 0; 1 0 0]; % RGB
% Common labelings for graphs
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png
if condition % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_3ANOVA_']; 
    sBasicStats = sBasicStatsSupra;
else % sub
    outputFileNameBase = ['Sub' MetaInfo.control 'Loop_3ANOVA_']; 
    sBasicStats = sBasicStatsSub;
end
[ flag ] = figsf_3ANOVAColorMat1( sBasicStats, dataVarNames, condVec, MetaInfo.bitLabel(1), CTitle, CVLabel, CLegend, colorMat, outputGraph, outputFileNameBase);
clear flag sBasicStats CTitle CVLabel CLegend colorMat outputFileNameBase outputGraph
close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR)

%% Save
cd(MetaInfo.DataFolder)
save(MetaInfo.outputFileName)

%% Copy this script to the data folder
cd(MetaInfo.MatlabFolder)
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_3ANOVAAnalysis1.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_3ANOVAAnalysis1.m'],...
    MetaInfo.DataFolder);
clear flag
% cd(MetaInfo.DataFolder)