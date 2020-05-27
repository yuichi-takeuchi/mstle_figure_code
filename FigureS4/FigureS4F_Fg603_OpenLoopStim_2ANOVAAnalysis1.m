% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts two-way ANOVA statistical analyses and graph outputs of
% summarized data in csv (control vs. treatment with conditioning, like
% daly, stimulus Hz etc.
% Copyright (c) Yuichi Takeuchi 2018, 2019
clc; clear; close all
%% Organizing MetaInfo
% setting parameters
Supplement = 'S';
FigureNo = 4;
FgNo = 603;
Panel = 'F';
bitLabel = [0 1]; % for [open or closed, estim or optogenetic]
if bitLabel(1)
    control = 'Closed';
else
    control = 'Open';
end
% building the MetaInfo structure
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Research\Scrivener\MSTLE\Figures\Figure' Supplement num2str(FigureNo) '\Analysis'],...
    'inputFileName', ['Figure' Supplement num2str(FigureNo) '_Fg' num2str(FgNo) '_' control 'LoopStim.csv'],...
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_2ANOVA.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_2ANOVAAnalysis1.m'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo...
    );
clear FigureNo FgNo bitLabel control Panel Supplement

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import and parameter settings
orgTb = readtable(MetaInfo.inputFileName); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
supraTb = orgTb(logical(orgTb.Supra),:); % 
dataVarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
OnOffVarName = orgTb.Properties.VariableNames{10};
linearVarName = orgTb.Properties.VariableNames{12};
condVec = unique(orgTb.(12));

%% Basic statistics and Statistical tests
if ~MetaInfo.bitLabel(1)
    % sub
    [ sBasicStatsSub, sStatsTestSub ] = statsf_get2ANOVAStatsStructs1( subTb, dataVarNames, OnOffVarName, linearVarName);
end
close all
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_get2ANOVAStatsStructs1( supraTb, dataVarNames, OnOffVarName, linearVarName);
close all

%% Figure preparation
% Common labelings for graphs
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

if MetaInfo.bitLabel(2) % optogenetics
%     if ~MetaInfo.bitLabel(1)% sub (open)
%         outputFileNameBase = ['Sub' MetaInfo.control 'Loop_2ANOVA_']; 
%         [ flag ] = figsf_2ANOVAOpt1( sBasicStatsSub, dataVarNames, condVec, 0, CTitle, CVLabel, outputGraph, outputFileNameBase);
%         clear flag outputFileNameBase
%     end
    % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_2ANOVA_']; 
    [ flag ] = figsf_2ANOVAOpt1( sBasicStatsSupra, dataVarNames, condVec, MetaInfo.bitLabel(1), CTitle, CVLabel, outputGraph, outputFileNameBase);
    clear flag outputFileNameBase
else
%     if ~MetaInfo.bitLabel(1)% sub
%         outputFileNameBase = ['Sub' MetaInfo.control 'Loop_2ANOVA_']; 
%         [ flag ] = figsf_2ANOVAGray1( sBasicStatsSub, dataVarNames, condVec, 0, CTitle, CVLabel, outputGraph, outputFileNameBase);
%         clear flag outputFileNameBase
%     end
    % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_2ANOVA_']; 
    [ flag ] = figsf_2ANOVAGray1( sBasicStatsSupra, dataVarNames, condVec, MetaInfo.bitLabel(1), CTitle, CVLabel, outputGraph, outputFileNameBase);
    clear flag outputFileNameBase
end
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
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_2ANOVAAnalysis1.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_2ANOVAAnalysis1.m'],...
    MetaInfo.DataFolder );
clear flag
cd(MetaInfo.DataFolder)