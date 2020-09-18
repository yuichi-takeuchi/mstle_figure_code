function [sBasicStatsSupra, sStatsTestSupra, sBasicStatsSupraMI, sStatsTestSupraMI, chi2] = figureS9df()
% This script calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 9;
fgNo = 624;
panel1 = 'D';
panel2 = 'F';
control = 'Closed';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' supplement num2str(figureNo) panel1 panel2 '_' control 'LoopStim_MIDist.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
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

%% Get the threshold
[ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( supraMI );
x = linspace(-1, 1, 1000);
gThreshold = x(indForSeparation);

%% Figure preparation of MI with curve fitting of two Gaussian components
threshold = gThreshold;
outputGraph = [1 1]; % pdf, png
colorMat = [0.75 0.75 0.75; 0 0 0; 0 0 0; 0 0 1]; % [R G B]

% supra
outputFileNameBase = ['Figure' supplement num2str(figureNo) panel1 '_Supra' control 'Loop_MIDistWithFit'];
[ flag ] = figsf_HistogramWTwoGaussians2( supraMI, threshold, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag; close all

%% Separation of data by the global threshold of MI (output is ~supraTbTh or ~subTbTh.csv file)
% parameters
threshold = gThreshold;

% CSV file output
tempMI = supraMI;

indMI = interleave(tempMI, tempMI);
indThrshld = tempMI < threshold;

indThrshld = interleave(indThrshld, indThrshld);
tempTb = table(indMI, indThrshld, 'VariableNames',{'MI','Thresholded'});

supraTbTh = [supraTb, tempTb];
writetable(supraTbTh, ['tmp/Figure' supplement num2str(figureNo) '_supraTbTh.csv'])

%% Proportion of thresholded (labeled) conditions

tempTbTh = supraTbTh;
condVec = tempTbTh.(12);
unqcond = unique(condVec);
stimVec = tempTbTh.(10);
thrshldVec = tempTbTh.(23);

for i = 1:length(unqcond)
    n(i) = nnz(stimVec(condVec == unqcond(i) & thrshldVec == 1)); % Number of thresholded trials
    N(i) = nnz(stimVec(condVec == unqcond(i))); % No trial
end
[ chi2h, chi2p, chi2stats ] = statsf_chi2test( n, N ); % chi-square test
chi2 = struct(...
    'h', chi2h,...
    'p', chi2p,...
    'stats', chi2stats...
    );

percThrshlded = n./N;

%% Figure prepration for fraction of conditioned trials (Supra)
% parameters
unqcond = unique(supraTbTh.(12));
CTitle = {'Fraction of success trial pairs'};
CVLabel = {'Fraction'};
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 1]; % RGB
CHLabel = 'MS illumination delay (ms)';

outputFileNameBase = ['Figure' supplement num2str(figureNo) panel2 '_Supra' control 'Loop_PercThrshlded'];
[ flag ] = figsf_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSupra', 'sStatsTestSupra', 'sBasicStatsSupraMI', 'sStatsTestSupraMI', 'chi2', 'No', '-v7.3')
save(['tmp/' outputFileName], 'percThrshlded', '-v7.3')
disp('done')

end 
