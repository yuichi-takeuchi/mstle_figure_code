function [sBasicStatsSub, sStatsTestSub, subCorStatTest, No] = figure6a()
% This script prepares correlations between modulation index of dulation of
% HPC electrographic seizures and delta Ctx, delta RS.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
supplement = '';
figureNo = 6;
figureNo_input = 2;
fgNo = 641;
panel = 'A';
control = 'Open';
inputFileName = ['Figure' supplement num2str(figureNo_input) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['Figure' supplement num2str(figureNo) panel '_' control 'LoopStim_MICor.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% sub
[ sBasicStatsSub, sStatsTestSub ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );

%% Calculation of parameters (MI, dCtx, dRS)
% sub    
% getting parameters
subHPCOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
subHPCOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
subMI = (subHPCOn-subHPCOff)./(subHPCOn+subHPCOff);
clear subHPCOff subHPCOn
subCtxOff = subTb.(VarNames{5})(logical(subTb.(10)) == false);
subCtxOn  = subTb.(VarNames{5})(logical(subTb.(10)) == true);
subdCtx = subCtxOn-subCtxOff;
clear subCtxOff subCtxOn
subRSOff = subTb.(VarNames{1})(logical(subTb.(10)) == false);
subRSOn  = subTb.(VarNames{1})(logical(subTb.(10)) == true);
subdRS = subRSOn-subRSOff;
clear subRSOff subRSOn
index = ~isnan(subMI);
subMI = subMI(index);
subdCtx = subdCtx(index);
subdRS = subdRS(index);
clear index

% getting a regression line
subMIdCtxCoeff = polyfit(subMI, subdCtx, 1);
subMIdRSCoeff = polyfit(subMI, subdRS, 1);
subdCtxdRSCoeff = polyfit(subdCtx, subdRS, 1);

% Correlation test
% HPC vs dCtx
subCorStatTest(1).Label = 'HPC vs dCtx';
R = corrcoef(subMI, subdCtx);
subCorStatTest(1).coefR = R;
[rho, pval] = corr(subMI, subdCtx, 'Type', 'Pearson');
subCorStatTest(1).PearsonRho = rho;
subCorStatTest(1).PearsonP = pval;
[rho, pval] = corr(subMI, subdCtx, 'Type', 'Spearman');
subCorStatTest(1).SpearmanRho = rho;
subCorStatTest(1).SpearmanP = pval;
% HPC vs dRS
subCorStatTest(2).Label = 'HPC vs dRS';
R = corrcoef(subMI, subdRS);
subCorStatTest(2).coefR = R;
[rho, pval] = corr(subMI, subdRS, 'Type', 'Pearson');
subCorStatTest(2).PearsonRho = rho;
subCorStatTest(2).PearsonP = pval;
[rho, pval] = corr(subMI, subdRS, 'Type', 'Spearman');
subCorStatTest(2).SpearmanRho = rho;
subCorStatTest(2).SpearmanP = pval;
% dCtx vs dRS
subCorStatTest(3).Label = 'dCtx vs dRS';
R = corrcoef(subdCtx, subdRS);
subCorStatTest(3).coefR = R;
[rho, pval] = corr(subdCtx, subdRS, 'Type', 'Pearson');
subCorStatTest(3).PearsonRho = rho;
subCorStatTest(3).PearsonP = pval;
[rho, pval] = corr(subdCtx, subdRS, 'Type', 'Spearman');
subCorStatTest(3).SpearmanRho = rho;
subCorStatTest(3).SpearmanP = pval;
clear R rho pval

%% Figure prepration
% parameters
CTitle = {'HPC seizure vs Ctx seizure', 'HPC seizure vs Motor seizure', 'Ctx seizure vs Motor seizure'};
CVLabel = {'\DeltaCtx seizure duration (s)', '\DeltaRacine''s scale', '\DeltaRacine''s scale'};
CHLabel = {'Modulation index of HPC seizures', 'Modulation index of HPC seizures', '\DeltaCtx seizure duration (s)'};
outputGraph = [1 1]; % pdf, png
colorMatSub = [1 0 0]; % RGB
  
outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Sub' control 'Cor_HPCvsCtx'];
[ flag ] = figsf_ScatRefline1( subMI, subdCtx, subMIdCtxCoeff, subCorStatTest(1).coefR, CTitle{1}, CVLabel{1}, CHLabel{1}, colorMatSub, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag outputFileNameBase; close all

outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Sub' control 'Cor_HPCvsRS'];
[ flag ] = figsf_ScatRefline1( subMI, subdRS, subMIdRSCoeff, subCorStatTest(2).coefR, CTitle{2}, CVLabel{2}, CHLabel{2}, colorMatSub, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag outputFileNameBase; close all

outputFileNameBase = ['Figure' supplement num2str(figureNo) panel '_Sub' control 'Cor_CtxvsRS'];
[ flag ] = figsf_ScatRefline1( subdCtx, subdRS, subdCtxdRSCoeff, subCorStatTest(3).coefR, CTitle{3}, CVLabel{3}, CHLabel{3}, colorMatSub, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag outputFileNameBase; close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStatsSub', 'sStatsTestSub', 'subCorStatTest', 'No', '-v7.3')
disp('done')

end
