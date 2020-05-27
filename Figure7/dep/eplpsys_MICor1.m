% This script prepares correlations between modulation index of dulation of
% HPC electrographic seizures and delta Ctx, delta RS.
% Copyright (c) Yuichi Takeuchi 2019
clc; clear; close all
%% Organizing MetaInfo
Supplement = '';
FigureNo = 7;
FgNo = 641;
Panel = 'C';
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
    'DataFolder', ['C:\Users\Lenovo\Dropbox\Scrivener\MSTLE\Figures\Figure' Supplement num2str(FigureNo) '\Analysis'],...
    'inputFileName', ['Figure' Supplement num2str(FigureNo) '_Fg' num2str(FgNo) '_' control 'LoopStim.csv'],...
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MICor.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MICor1.m'],...
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

if ~MetaInfo.bitLabel(1) % sub    
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
end

%% Figure prepration
% parameters
CTitle = {'HPC seizure vs Ctx seizure', 'HPC seizure vs Motor seizure', 'Ctx seizure vs Motor seizure'};
CVLabel = {'\DeltaCtx seizure duration (s)', '\DeltaRacine''s scale', '\DeltaRacine''s scale'};
CHLabel = {'Modulation index of HPC seizures', 'Modulation index of HPC seizures', '\DeltaCtx seizure duration (s)'};
outputGraph = [1 1]; % pdf, png
  
% supra
outputFileNameBase = ['Supra' MetaInfo.control 'Cor_HPCvsCtx_'];
[ flag ] = figsf_ScatRefline1( supraMI, supradCtx, supraMIdCtxCoeff, supraCorStatTest(1).coefR, CTitle{1}, CVLabel{1}, CHLabel{1}, outputGraph, outputFileNameBase);
clear flag outputFileNameBase; close all

outputFileNameBase = ['Supra' MetaInfo.control 'Cor_HPCvsRS_'];
[ flag ] = figsf_ScatRefline1( supraMI, supradRS, supraMIdRSCoeff, supraCorStatTest(2).coefR, CTitle{2}, CVLabel{2}, CHLabel{2}, outputGraph, outputFileNameBase);
clear flag outputFileNameBase; close all

outputFileNameBase = ['Supra' MetaInfo.control 'Cor_CtxvsRS_'];
[ flag ] = figsf_ScatRefline1( supradCtx, supradRS, supradCtxdRSCoeff, supraCorStatTest(3).coefR, CTitle{3}, CVLabel{3}, CHLabel{3}, outputGraph, outputFileNameBase);
clear flag outputFileNameBase; close all

if ~MetaInfo.bitLabel(1) % sub
    outputFileNameBase = ['Sub' MetaInfo.control 'Cor_HPCvsCtx_'];
    [ flag ] = figsf_ScatRefline1( subMI, subdCtx, subMIdCtxCoeff, subCorStatTest(1).coefR, CTitle{1}, CVLabel{1}, CHLabel{1}, outputGraph, outputFileNameBase);
    clear flag outputFileNameBase; close all

    outputFileNameBase = ['Sub' MetaInfo.control 'Cor_HPCvsRS_'];
    [ flag ] = figsf_ScatRefline1( subMI, subdRS, subMIdRSCoeff, subCorStatTest(2).coefR, CTitle{2}, CVLabel{2}, CHLabel{2}, outputGraph, outputFileNameBase);
    clear flag outputFileNameBase; close all

    outputFileNameBase = ['Sub' MetaInfo.control 'Cor_CtxvsRS_'];
    [ flag ] = figsf_ScatRefline1( subdCtx, subdRS, subdCtxdRSCoeff, subCorStatTest(3).coefR, CTitle{3}, CVLabel{3}, CHLabel{3}, outputGraph, outputFileNameBase);
    clear flag outputFileNameBase; close all
end

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
copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_MICor1.m'],...
    [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% dependency
[ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_MICor1.m'],...
    [MetaInfo.DataFolder '\dep'] );
clear flag
cd(MetaInfo.DataFolder)
