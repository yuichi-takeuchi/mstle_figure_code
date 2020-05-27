% Open or closed-loop septum optogenetic stimulation for kindling-induced 
% evoked temporal lobe seizures
% This script conducts statistical analyses and bar graph outputs of
% summarized data in csv (control vs. treatment)
% Copyright(c) Yuichi Takeuchi 2018, 2019
clc; clear; close all
%% Organizing MetaInfo
Supplement = '';
FigureNo = 3;
FgNo = 641;
Panel = 'F';
bitLabel = [1 0]; % for [open or closed, estim or optogenetic]
if bitLabel(1)
    control = 'Closed';
    graphSuffix = 'Dly';
else
    control = 'Open';
    graphSuffix = 'Hz';
end
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Research\Scrivener\MSTLE\Figures\Figure' Supplement num2str(FigureNo) '\Analysis'],...
    'inputFileName', ['Figure' Supplement num2str(FigureNo) '_Fg' num2str(FgNo) '_' control 'LoopStim.csv'],...
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_PooledOnOff.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_PooledOnOffAnalysis2.m'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'graphSuffix', graphSuffix,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo...
    );
clear FigureNo FgNo control graphSuffix bitLabel Panel Supplement

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import 1
orgTb = readtable(MetaInfo.inputFileName); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames; VarNames = VarNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Data import 2
condition = [1]; % 0 for sub, 1 for supra
if condition
    supraTbTh = readtable(['Figure' num2str(MetaInfo.FigureNo) '_supraTbTh.csv']);
else
    subTbTh = readtable(['Figure' num2str(MetaInfo.FigureNo) '_subTbTh.csv']);
end

%% Basic statistics and Statistical tests
if ~MetaInfo.bitLabel(1)
    % sub
    [ sBasicStatsSub, sStatsTestSub ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );
end
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Figure preparation (non-clustered)
% % Common labelings 
% CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
% CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
% outputGraph = [1 1]; % pdf, png
% 
% if MetaInfo.bitLabel(2) % Optogenetics
% %     if ~MetaInfo.bitLabel(1) % sub
% %         outputFileNameBase = ['Sub' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
% %         [ flag ] = figsf_BarScatPairedOpt1( subTb, VarNames, sBasicStatsSub, CTitle, CVLabel, outputGraph, outputFileNameBase);
% %         clear flag outputFileNameBase; close all
% %     end
%     % supra
%     outputFileNameBase = ['Supra' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
%     [ flag ] = figsf_BarScatPairedOpt1( supraTb, VarNames, sBasicStatsSupra, CTitle, CVLabel, outputGraph, outputFileNameBase);
%     clear flag outputFileNameBase; close all
% end
% 
% if ~MetaInfo.bitLabel(2) % MS Estim
% %     if ~MetaInfo.bitLabel(1) % sub
% %         outputFileNameBase = ['Sub' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
% %         [ flag ] = figsf_BarScatPairedGray1( subTb, VarNames, sBasicStatsSub, CTitle, CVLabel, outputGraph, outputFileNameBase);
% %         clear flag outputFileNameBase; close all
% %     end
%     % supra
%     outputFileNameBase = ['Supra' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
%     [ flag ] = figsf_BarScatPairedGray1( supraTb, VarNames, sBasicStatsSupra, CTitle, CVLabel, outputGraph, outputFileNameBase);
%     clear flag outputFileNameBase; close all
% end
% clear colaorMatsupra CTitle CVLabel outputGraph

%% Figure preparation (clustered)
colorMat = [0 0 0; 0 0 1]; % RGB
% Common labelings
CTitle = {'Motor seizure', 'Wet-dog shaking', 'AD duration', 'HPC electrographic seizure', 'Ctx electrographic seizure'};
CVLabel = {'Racine''s scale', 'Behavior No', 'Duration (s)', 'Duration (s)', 'Duration (s)'};
outputGraph = [1 1]; % pdf, png

if MetaInfo.bitLabel(2) % Optogenetics
    if ~condition % sub
        outputFileNameBase = ['Sub' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
        [ flag ] = figsf_BarScatPairedOpt1( subTbTh, VarNames, sBasicStatsSub, CTitle, CVLabel, outputGraph, outputFileNameBase);
        clear flag outputFileNameBase; close all
    else
        % supra
        outputFileNameBase = ['Supra' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
        [ flag ] = figsf_BarScatPairedOpt2( supraTbTh, VarNames, sBasicStatsSupra, CTitle, CVLabel, colorMat, outputGraph, outputFileNameBase);
        clear flag outputFileNameBase; close all
    end
else % MS Estim
    if ~condition % sub
        outputFileNameBase = ['Sub' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
        [ flag ] = figsf_BarScatPairedGray2( subTbTh, VarNames, sBasicStatsSub, CTitle, CVLabel, colorMat, outputGraph, outputFileNameBase);
        clear flag outputFileNameBase; close all
    else
        % supra
        outputFileNameBase = ['Supra' MetaInfo.control 'Loop_Pooled' MetaInfo.graphSuffix '_'];
        [ flag ] = figsf_BarScatPairedGray2( supraTbTh, VarNames, sBasicStatsSupra, CTitle, CVLabel, colorMat, outputGraph, outputFileNameBase);
        clear flag outputFileNameBase; close all
    end
end
clear colorMat CTitle CVLabel outputGraph condition

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
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_PooledOnOffAnalysis2.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_PooledOnOffAnalysis2.m'],...
    MetaInfo.DataFolder);
clear flag
% cd(MetaInfo.DataFolder)
