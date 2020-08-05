function [Stats, No] = figure6h()
% Kindling threshold intensities for after-discharges and secondary
% generalization with optogenetic interventions
% Copyright (c) 2018, 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 6;
fgNo = 602;
panel = 'H';
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_ThresIntensity.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_Fg' num2str(fgNo) '_ThresIntensity.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
VarNames = orgTb.Properties.VariableNames(10:11); % {ADThrs, sGSThrs}

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

% 5 s conditioning
outputFileNameBase = ['Figure' num2str(figureNo) panel '_ThrsInt05_'];
[ flag ] = figsf_BarScatPairedOpt1( orgTb05, VarNames, Stats(1).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase);
for i = 1:length(VarNames)
    movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
    movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
end
close all

% 60 s conditioning
outputFileNameBase = ['Figure' num2str(figureNo) panel '_ThrsInt60_'];
[ flag ] = figsf_BarScatPairedOpt1( orgTb60, VarNames, Stats(2).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase);
for i = 1:length(VarNames)
    movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
    movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
end
close all

%% Number of rats and trials
No(1).subRats = length(unique(orgTb05.LTR));
No(1).subTrials = length(orgTb05.LTR);
No(2).subRats = length(unique(orgTb60.LTR));
No(2).subTrials = length(orgTb60.LTR);

%% Save
save(['../results/' outputFileName], 'Stats', 'No', '-v7.3')

end
