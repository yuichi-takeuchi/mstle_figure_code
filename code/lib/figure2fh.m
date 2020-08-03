function [sBasicStatsSub, sStatsTestSub, sBasicStatsSubMI, sStatsTestSubMI, chi2] = figure2fh()
% Calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 2;
fgNo = 641;
panel = 'EH';
panel1 = 'E';
panel2 = 'H';
control = 'Open';
gThreshold = 0.4515;
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_' control 'LoopStim_MIDist.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% sub
[ sBasicStatsSub, sStatsTestSub ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );

%% Calculation of parameters (MI)
% getting parameters
subHPCOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
subHPCOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
subMI = (subHPCOn-subHPCOff)./(subHPCOn+subHPCOff);
clear subHPCOff subHPCOn

index = isnan(subMI);
subMI(index) = 0;
clear index

%% Skewness test
subMIpos = subMI(subMI >= 0);
subMIneg = subMI(subMI <= 0);
[ sBasicStatsSubMI, sStatsTestSubMI ] = statsf_getBasicStatsAndTestStructs2( subMIpos, abs(subMIneg) );

%% Separation of data by the global threshold of MI (output is ~supraTbTh or ~subTbTh.csv file)
% Figure preparation of histgram with separation line as well
threshold = gThreshold;
outputGraph = [1 1]; % pdf, png
colorMat = [0.75 0.75 0.75; 0 0 0]; % [R G B]

% sub
outputFileNameBase = ['Figure' num2str(figureNo) panel1 '_Sub' control 'Loop_MIDistWithFit'];
[ flag ] = figsf_HistogramWThreshold1( subMI, threshold, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag; close all

% CSV file output
tempMI = subMI;

indMI = interleave(tempMI, tempMI);
indThrshld = tempMI > threshold;

indThrshld = interleave(indThrshld, indThrshld);
tempTb = table(indMI, indThrshld, 'VariableNames',{'MI','Thresholded'});

subTbTh = [subTb, tempTb];
writetable(subTbTh, ['tmp/Figure' num2str(figureNo) '_subTbTh.csv'])

%% Proportion of thresholded (labeled) conditions
tempTbTh = subTbTh;
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

%% Figure prepration for fraction of conditioned trials (Sub)
% parameters
unqcond = unique(subTbTh.(12));
CTitle = 'Fraction of seizure-inducted trial';
CVLabel = 'Fraction';
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 0];
CHLabel = 'MS stimulation frequency (Hz)';

outputFileNameBase = ['Figure' num2str(figureNo) panel2 '_Sub' control 'Loop_PercThrshlded'];
[ flag ] = figsf_Plot2( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag; close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSub', 'sStatsTestSub', 'sBasicStatsSubMI', 'sStatsTestSubMI', 'chi2', 'No', '-v7.3')

end