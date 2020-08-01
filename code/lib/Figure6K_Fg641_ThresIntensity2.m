% Kindling threshold intensities for after-discharges and secondary
% generalization with optogenetic interventions
% Copyright (c) Yuichi Takeuchi 2018, 2019
clear; close all
%% Organizing MetaInfo
Supplement = '';
FigureNo = 6;
FgNo = 641;
Panel = 'K';
bitLabel = [0]; % 0 and 1 for Estim and Optogenetics, respectively
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Research\Scrivener\MSTLE\Figures\Figure' Supplement num2str(FigureNo) '\Analysis'],...
    'inputFileName', ['Figure' Supplement num2str(FigureNo) '_Fg' num2str(FgNo) '_ThresIntensity.csv'],...
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_ThresIntensity.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_ThresIntensity2.m'],...
    'bitLabel', bitLabel,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo...
    );
clear FigureNo FgNo bitLabel Panel Supplement

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import
orgTb = readtable(MetaInfo.inputFileName); % original csv data
VarNames = orgTb.Properties.VariableNames; VarNames = VarNames(10:11); % {ADThrs, sGSThrs}

% Conditioing by conditining stimulus duration
orgTb05 = orgTb(orgTb.(7) == 5,:);
orgTb60 = orgTb(orgTb.(7) == 60,:);

%% Basic statistics and Statistical tests
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( orgTb05, VarNames, orgTb05.(6)); % orgTb.(6) = Laser or MSEStm
Stats(1).Basic = sBasicStats;
Stats(1).Test = sStatsTest;
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( orgTb60, VarNames, orgTb60.(6)); % orgTb.(6) = Laser or MSEStm
Stats(2).Basic = sBasicStats;
Stats(2).Test = sStatsTest;
clear sBasicStats sStatsTest

%% Figure preparation
% Labelings 
CTitle = {'Threshold for HPC', 'Threshold for Ctx'};
CVLabel = {'Intensity (uA)', 'Intensity (uA)'};
outputGraph = [1 1]; % pdf, png
outputFileNameBase05 = ['Fg' num2str(MetaInfo.FgNo) '_ThrsInt05_'];
outputFileNameBase60 = ['Fg' num2str(MetaInfo.FgNo) '_ThrsInt60_'];
% 5 s conditioning
if MetaInfo.bitLabel
    % for optogenetic stimulus
    [ flag ] = figsf_BarScatPairedOpt1( orgTb05, VarNames, Stats(1).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase05);
else
    % for E-stim stimulus
    [ flag ] = figsf_BarScatPairedGray1( orgTb05, VarNames, Stats(1).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase05);
end
close all

% 60 s conditioning
if MetaInfo.bitLabel
    % for optogenetic stimulus
    [ flag ] = figsf_BarScatPairedOpt1( orgTb60, VarNames, Stats(2).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase60);
else
    % for E-stim stimulus
    [ flag ] = figsf_BarScatPairedGray1( orgTb60, VarNames, Stats(2).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase60);
end
close all

clear flag outputGraph outputFileNameBase05 outputFileNameBase60

%% Number of rats and trials
No(1).subRats = length(unique(orgTb05.LTR));
No(1).subTrials = length(orgTb05.LTR);
No(2).subRats = length(unique(orgTb60.LTR));
No(2).subTrials = length(orgTb60.LTR);

%% Save
cd(MetaInfo.DataFolder)
save(MetaInfo.outputFileName)

%% Copy this script to the data folder
cd(MetaInfo.MatlabFolder)
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_ThresIntensity2.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_ThresIntensity2.m'],...
    MetaInfo.DataFolder);
clear flag
cd(MetaInfo.DataFolder)
