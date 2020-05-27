% This script calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) Yuichi Takeuchi 2019, 2020
clc; clear; close all
%% Organizing MetaInfo
Supplement = '';
FigureNo = 5;
FgNo = 627;
Panel = 'FH';
bitLabel = [1 1]; % for [open or closed, estim or optogenetic]
gThreshold = -0.4515;
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
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MIDist.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MIDist1.m'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'graphSuffix', graphSuffix,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo,...
    'gThreshold', gThreshold...
    );
clear FigureNo FgNo control graphSuffix bitLabel Panel Supplement gThreshold

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

%% Calculation of parameters (MI)
% getting parameters (supra)
HPCOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
HPCOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
supraMI = (HPCOn-HPCOff)./(HPCOn+HPCOff);
clear HPCOff HPCOn

if ~MetaInfo.bitLabel(1) % sub    
    % getting parameters
    subHPCOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
    subHPCOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
    subMI = (subHPCOn-subHPCOff)./(subHPCOn+subHPCOff);
    clear subHPCOff subHPCOn

    index = isnan(subMI);
    subMI(index) = 0;
    clear index
end

%% Skewness test
supraMIpos = supraMI(supraMI >= 0);
supraMIneg = supraMI(supraMI <= 0);
[ sBasicStatsSupraMI, sStatsTestSupraMI ] = statsf_getBasicStatsAndTestStructs2( supraMIpos, abs(supraMIneg) );
clear supraMIpos supraMIneg

if ~MetaInfo.bitLabel(1) % sub    
    subMIpos = subMI(subMI >= 0);
    subMIneg = subMI(subMI <= 0);
    [ sBasicStatsSubMI, sStatsTestSubMI ] = statsf_getBasicStatsAndTestStructs2( subMIpos, abs(subMIneg) );
    clear supraMIpos supraMIneg
end

%% Figure preparation of MI with curve fitting with one Gaussian component
% condition = [1]; % 0 for sub, 1 for supra
% outputGraph = [1 1]; % pdf, png
% colorMat = [0.75 0.75 0.75; 0 0 0];
% 
% if condition
%     % supra
%     outputFileNameBase = ['Supra' MetaInfo.control 'Loop_MIDistWithFit'];
%     [ flag ] = figsf_HistogramWOneGaussian1( supraMI, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
%      clear flag; close all
% else
%     % sub
%     outputFileNameBase = ['Sub' MetaInfo.control 'Loop_MIDistWithFit'];
%     [ flag ] = figsf_HistogramWOneGaussian1( subMI, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
%     clear flag; close all
% end
% clear condition outputGraph colorMat

%% Figure preparation of MI with curve fitting of two Gaussian components
% condition = [1]; % 0 for sub, 1 for supra
% threshold = MetaInfo.gThreshold;
% outputGraph = [1 1]; % pdf, png
% colorMat = [0.75 0.75 0.75; 0 0 0; 0 0 0; 0 0 1]; % [R G B]
% 
% if condition
%     % supra
%     outputFileNameBase = ['Supra' MetaInfo.control 'Loop_MIDistWithFit'];
%     [ flag ] = figsf_HistogramWTwoGaussians2( supraMI, threshold, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
%     clear flag; close all
% else
%     % sub
%     outputFileNameBase = ['Sub' MetaInfo.control 'Loop_MIDistWithFit'];
%     [ flag ] = figsf_HistogramWTwoGaussians2( subMI, threshold, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
%     clear flag; close all
% end
% clear condition outputGraph colorMat outputFileNameBase

%% Figure preparation of histgram with a threshold line without any fitting 
% Parameters
condition = [1]; % 0 for sub, 1 for supra
outputGraph = [1 1]; % pdf, png
colorMat = [0.75 0.75 0.75; 0 0 0]; % [R G B]

threshold = MetaInfo.gThreshold;

if condition
    % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_MIDistWithFit'];
    [ flag ] = figsf_HistogramWThreshold1( supraMI, threshold, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
    clear flag; close all
else
    % sub
    outputFileNameBase = ['Sub' MetaInfo.control 'Loop_MIDistWithFit'];
    [ flag ] = figsf_HistogramWThreshold1( subMI, threshold, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
    clear flag; close all
end
clear outputGraph colorMat threshold condition

%% Separation of data by the global threshold of MI (output is ~supraTbTh or ~subTbTh.csv file)
% parameters
condition = [1]; % 0 for sub, 1 for supra
direction = [0]; % 0 for lower, 1 for upper

threshold = MetaInfo.gThreshold;

% CSV file output
if condition
    tempMI = supraMI;
else
    tempMI = subMI;
end
indMI = interleave(tempMI, tempMI);
if direction
    indThrshld = tempMI > threshold;
else
    indThrshld = tempMI < threshold;
end
indThrshld = interleave(indThrshld, indThrshld);
tempTb = table(indMI, indThrshld, 'VariableNames',{'MI','Thresholded'});
if condition
    supraTbTh = [supraTb, tempTb];
    writetable(supraTbTh, ['Figure' num2str(MetaInfo.FigureNo) '_supraTbTh.csv'])
else
    subTbTh = [subTb, tempTb];
    writetable(subTbTh, ['Figure' num2str(MetaInfo.FigureNo) '_subTbTh.csv'])
end
clear indMI condition indThrshld tempTb threshold

%% Proportion of thresholded (labeled) conditions
condition = [1];  % 0 for sub, 1 for supra
if condition
    tempTbTh = supraTbTh;
else
    tempTbTh = subTbTh;
end
condVec = tempTbTh.(12);
unqcond = unique(condVec);
stimVec = tempTbTh.(10);
thrshldVec = tempTbTh.(23);
for i = 1:length(unqcond)
    n(i) = nnz(stimVec(condVec == unqcond(i) & thrshldVec == 1)); % Number of thresholded trials
    N(i) = nnz(stimVec(condVec == unqcond(i))); % No trial
end
if condition
    [ chi2hSupra, chi2pSupra, chi2statsSupra ] = statsf_chi2test( n, N ); % chi-square test
else
    [ chi2hSub, chi2pSub, chi2statsSub ] = statsf_chi2test( n, N ); % chi-square test
end
percThrshlded = n./N;
clear i n N condVec unqcond stimVec thrshldVec tempTbTh condition

%% Figure prepration for fraction of conditioned trials (Supra)
% parameters
unqcond = unique(supraTbTh.(12));
CTitle = {'Fraction of success trial pairs'};
CVLabel = {'Fraction'};
outputGraph = [1 1]; % pdf, png

if MetaInfo.bitLabel(2) % optogenetics
    colorMat = [0 0 1]; % RGB
    if MetaInfo.bitLabel(1)
        CHLabel = 'MS illumination delay (ms)';
    else
        CHLabel = 'MS illumination frequency (Hz)';
    end
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_PercThrshlded'];
    [ flag ] = figsf_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
else
    colorMat = [0 0 0];
    if MetaInfo.bitLabel(1)
        CHLabel = 'MS stimulation delay (ms)';
    else
        CHLabel = 'MS stimulation frequency (Hz)';
    end
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_PercThrshlded'];
    [ flag ] = figsf_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
end
clear flag outputFileNameBase colorMat CTitle CVLabel CHLabel outputGraph unqcond; close all

%% Figure prepration for fraction of conditioned trials (Sub)
% % parameters
% unqcond = unique(subTbTh.(12));
% CTitle = {'Fraction of seizure-inducted trial'};
% CVLabel = {'Fraction'};
% outputGraph = [1 1]; % pdf, png
% 
% if MetaInfo.bitLabel(2) % optogenetics
%     colorMat = [0 0 1];
%     if MetaInfo.bitLabel(1)
%         CHLabel = 'MS illumination delay (ms)';
%     else
%         CHLabel = 'MS illumination frequency (Hz)';
%     end
%     outputFileNameBase = ['Sub' MetaInfo.control 'Loop_PercThrshlded']; 
%     [ flag ] = figsf_Plot2( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
% else
%     colorMat = [0 0 0];
%     if MetaInfo.bitLabel(1)
%         CHLabel = 'MS stimulation delay (ms)';
%     else
%         CHLabel = 'MS stimulation frequency (Hz)';
%     end
%     outputFileNameBase = ['Sub' MetaInfo.control 'Loop_PercThrshlded'];
%     [ flag ] = figsf_Plot2( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
% end
% clear flag outputFileNameBase colorMat CTitle CVLabel CHLabel outputGraph unqcond; close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR)

%% Save
cd(MetaInfo.DataFolder)
save(MetaInfo.outputFileName, '-v7.3')

%% Copy this script to the data folder
cd(MetaInfo.MatlabFolder)
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_MIDistribution1.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\eplpsys_MIDistribution1.m'],...
    MetaInfo.DataFolder );
clear flag
% cd(MetaInfo.DataFolder)