function [sBasicStatsSupra, sStatsTestSupra, sBasicStatsSupraMI, sStatsTestSupraMI, No] = figure2d()
%
% Calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) Yuichi Takeuchi 2019, 2020

%% params
figureNo = 2;
fgNo = 641;
panel = 'D';
control = 'Open';
inputFileName = ['../data/Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['../results/Figure' num2str(figureNo) panel '_' control 'LoopStim_MIDist.mat'];

%% Data import
orgTb = readtable(inputFileName); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Calculation of parameters (MI)
% getting parameters (supra)
HPCOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
HPCOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
supraMI = (HPCOn-HPCOff)./(HPCOn+HPCOff);
clear HPCOff HPCOn


%% Skewness test
supraMIpos = supraMI(supraMI >= 0);
supraMIneg = supraMI(supraMI <= 0);
[ sBasicStatsSupraMI, sStatsTestSupraMI ] = statsf_getBasicStatsAndTestStructs2( supraMIpos, abs(supraMIneg) );
clear supraMIpos supraMIneg

%% Figure preparation of MI with curve fitting with one Gaussian component
outputGraph = [1 1]; % pdf, png
colorMat = [0.75 0.75 0.75; 0 0 0];

% supra
outputFileNameBase = ['Figure' num2str(figureNo) panel '_Supra' control 'Loop_MIDistWithFit'];
[ flag ] = figsf_HistogramWOneGaussian1( supraMI, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag; close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(outputFileName, 'sBasicStatsSupra', 'sStatsTestSupra', 'sBasicStatsSupraMI', 'sStatsTestSupraMI', 'No', '-v7.3')

end