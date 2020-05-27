% This script prepare cumulative distribution analysis, statistics of
% dulation of HPC electrographic seizure
% summarized data in csv (control vs. treatment)
% Copyright (c) Yuichi Takeuchi 2019
clc; clear; close all
%% Organizing MetaInfo
Supplement = '';
FigureNo = 7;
FgNo = 641;
Panel = 'B';
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
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_HPCDistribution.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_HPCDistribution1.m'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'graphSuffix', graphSuffix...
    );
clear FigureNo FgNo control graphSuffix bitLabel Panel Supplement

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import
orgTb = readtable(MetaInfo.inputFileName); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames; VarNames = VarNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
if ~MetaInfo.bitLabel(1)
    % sub
    [ sBasicStatsSub, sStatsTestSub ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );
end
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Data extraction for Histogram and Cummurative curve of HPC electrograhic seiuzures
% getting parameters (supra)
supraOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
supraOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
% Kolmogorv smirnov 2 sample test
[~,pkstest2supra] = kstest2(supraOff, supraOn)
clear pkstest2supra supraOff supraOn

if ~MetaInfo.bitLabel(1)
    subOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
    subOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
    % Kolmogorv smirnov 2 sample test
    [~,pkstest2sub] = kstest2(subOff, subOn)
    clear pkstest2sub subOff subOn
end

%% Histogram figure preparation
% parameters
CTitle = {'HPC electrographic seizure'};
CVLabel = {'Probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

if ~MetaInfo.bitLabel(1) 
    colorMat = [1 1 1; 1 0 0]; % sub
    outputFileNameBase = ['Sub' MetaInfo.control 'Loop_Dist_'];
    [ flag ] = figsf_HistogramPairedColored2( subTb, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
    clear flag colorMat outputFileNameBase; close all
    
    colorMat = [1 1 1; 0.25 0.25 0.25]; % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_Dist_'];
    [ flag ] = figsf_HistogramPairedColored2( supraTb, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
    clear flag colorMat outputFileNameBase; close all
else
    colorMat = [1 1 1; 0 0 1]; % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_Dist_'];
    [ flag ] = figsf_HistogramPairedColored2( supraTb, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
    clear flag colorMat outputFileNameBase; close all
end
clear CHLabel CLeg CTitle CVLabel outputGraph

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
clear cumsum1 cumsum2 N1 N2 supraOff supraOn

%sub
if ~MetaInfo.bitLabel(1)
    subOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
    subOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
    N1 = histcounts(subOff,edges, 'Normalization', 'probability');
    N2 = histcounts(subOn,edges, 'Normalization', 'probability');
    cumsum1 = cumsum(N1);
    cumsum2 = cumsum(N2);
    cumsumSub = [cumsum1;cumsum2];
    clear cumsum1 cumsum2 N1 N2 subOff subOn
end
clear edges

%% Cumurative curve figure preparation
% figure parameters
CTitle = {'HPC electrographic seizure'};
CVLabel = {'Cumulative probability'};
CHLabel = {'Duration (s)'};
CLeg = {'Off', 'On'};
outputGraph = [1 1]; % pdf, png

if ~MetaInfo.bitLabel(1) 
    colorMat = [0 0 0; 1 0 0]; % sub
    outputFileNameBase = ['Sub' MetaInfo.control 'Loop_CumProb_'];
    [ flag ] = figsf_PlotPairedColored1( edgesX, cumsumSub, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
    clear flag colorMat outputFileNameBase; close all
    
    colorMat = [0 0 0; 0.40 0.40 0.40]; % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_CumProb_'];
    [ flag ] = figsf_PlotPairedColored1( edgesX, cumsumSupra, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
    clear flag colorMat outputFileNameBase; close all
else
    colorMat = [0 0 0; 0 0 1]; % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_CumProb_'];
    [ flag ] = figsf_PlotPairedColored1( edgesX, cumsumSupra, VarNames(4), CTitle, CVLabel, CHLabel, CLeg, colorMat, outputGraph, outputFileNameBase);
    clear flag colorMat outputFileNameBase; close all
end
clear flag CHLabel CLeg CTitle CVLabel outputGraph

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
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_HPCDistribution1.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_HPCDistribution1.m'],...
    [MetaInfo.DataFolder '\dep'] );
clear flag
cd(MetaInfo.DataFolder)
