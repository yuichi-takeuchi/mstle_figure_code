function [sBasicStatsSupra, sStatsTestSupra, supraCorStatTest, No] = figure6b()
% This script prepares correlations between modulation index of dulation of
% HPC electrographic seizures and delta Ctx, delta RS.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
supplement = '';
figureNo = 6;
figureNo_input = 2;
fgNo = 641;
panel = 'B';
control = 'Open';
inputFileName = ['Figure' supplement num2str(figureNo_input) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' supplement num2str(figureNo) panel '_' control 'LoopStim_MICor.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Calculation of parameters (MI, dCtx, dRS)
% getting parameters (supra)
HPCOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
HPCOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
supraMI = (HPCOn-HPCOff)./(HPCOn+HPCOff);
clear HPCOff HPCOn
CtxOff = supraTb.(VarNames{5})(logical(supraTb.(10)) == false);
CtxOn  = supraTb.(VarNames{5})(logical(supraTb.(10)) == true);
supradCtx = CtxOn-CtxOff;
clear CtxOff CtxOn
RSOff = supraTb.(VarNames{1})(logical(supraTb.(10)) == false);
RSOn  = supraTb.(VarNames{1})(logical(supraTb.(10)) == true);
supradRS = RSOn-RSOff;
clear RSOff RSOn

% getting a regression line
supraMIdCtxCoeff = polyfit(supraMI, supradCtx, 1);
supraMIdRSCoeff = polyfit(supraMI, supradRS, 1);
supradCtxdRSCoeff = polyfit(supradCtx, supradRS, 1);

% Correlation test
% HPC vs dCtx
supraCorStatTest(1).Label = 'HPC vs dCtx';
R = corrcoef(supraMI, supradCtx);
supraCorStatTest(1).coefR = R;
[rho, pval] = corr(supraMI, supradCtx, 'Type', 'Pearson');
supraCorStatTest(1).PearsonRho = rho;
supraCorStatTest(1).PearsonP = pval;
[rho, pval] = corr(supraMI, supradCtx, 'Type', 'Spearman');
supraCorStatTest(1).SpearmanRho = rho;
supraCorStatTest(1).SpearmanP = pval;
% HPC vs dRS
supraCorStatTest(2).Label = 'HPC vs dRS';
R = corrcoef(supraMI, supradRS);
supraCorStatTest(2).coefR = R;
[rho, pval] = corr(supraMI, supradRS, 'Type', 'Pearson');
supraCorStatTest(2).PearsonRho = rho;
supraCorStatTest(2).PearsonP = pval;
[rho, pval] = corr(supraMI, supradRS, 'Type', 'Spearman');
supraCorStatTest(2).SpearmanRho = rho;
supraCorStatTest(2).SpearmanP = pval;
% dCtx vs dRS
supraCorStatTest(3).Label = 'dCtx vs dRS';
R = corrcoef(supradCtx, supradRS);
supraCorStatTest(3).coefR = R;
[rho, pval] = corr(supradCtx, supradRS, 'Type', 'Pearson');
supraCorStatTest(3).PearsonRho = rho;
supraCorStatTest(3).PearsonP = pval;
[rho, pval] = corr(supradCtx, supradRS, 'Type', 'Spearman');
supraCorStatTest(3).SpearmanRho = rho;
supraCorStatTest(3).SpearmanP = pval;
clear R rho pval

%% Figure prepration
% parameters
CTitle = {'HPC seizure vs Ctx seizure', 'HPC seizure vs Motor seizure', 'Ctx seizure vs Motor seizure'};
CVLabel = {'\DeltaCtx seizure duration (s)', '\DeltaRacine''s scale', '\DeltaRacine''s scale'};
CHLabel = {'Modulation index of HPC seizures', 'Modulation index of HPC seizures', '\DeltaCtx seizure duration (s)'};
outputGraph = [1 1]; % pdf, png
colorMatSupra = [0 0 0]; % RGB
  
% supra
outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Supra' control 'Cor_HPCvsCtx'];
[ flag ] = figsf_ScatRefline1( supraMI, supradCtx, supraMIdCtxCoeff, supraCorStatTest(1).coefR, CTitle{1}, CVLabel{1}, CHLabel{1}, colorMatSupra, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag outputFileNameBase; close all

outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Supra' control 'Cor_HPCvsRS'];
[ flag ] = figsf_ScatRefline1( supraMI, supradRS, supraMIdRSCoeff, supraCorStatTest(2).coefR, CTitle{2}, CVLabel{2}, CHLabel{2}, colorMatSupra, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag outputFileNameBase; close all

outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Supra' control 'Cor_CtxvsRS'];
[ flag ] = figsf_ScatRefline1( supradCtx, supradRS, supradCtxdRSCoeff, supraCorStatTest(3).coefR, CTitle{3}, CVLabel{3}, CHLabel{3}, colorMatSupra, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag outputFileNameBase; close all

%% Number of rats and trials
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSupra', 'sStatsTestSupra', 'supraCorStatTest', 'No', '-v7.3')
disp('done')

end
