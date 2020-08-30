function [sBasicStats, sStatsTest, sBasicStats_pa, sStatsTest_pa, No] = figure5k()
% Copyright (c) 2018-2020 Yuichi Takeuchi

%% params
figureNo = 5;
panel = 'k';
inputFileName = ['Figure' num2str(figureNo) '_Fg641_ThresIntensity.csv'];
outputFileName = ['figure' num2str(figureNo) panel '.mat'];

%% Data import
srcTb = readtable(['../data/' inputFileName]); % original csv data
VarNames = srcTb.Properties.VariableNames(10:11); % {ADThrs, sGSThrs}
dataTb = srcTb(srcTb.stmDrtn == 60,:);

%% Basic statistics and Statistical tests
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( dataTb, VarNames, dataTb.MSEstm);

%% animal basis stats (independent)
for i = 1:length(VarNames)
    [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(dataTb.(VarNames{i}), dataTb.LTR, dataTb.MSEstm);
    [sBasicStats_pa(i)] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
    [sStatsTest_pa(i)] = statsf_2sampleTestsStatsStruct_cndtn( dataTb.(VarNames{i}), dataTb.MSEstm );
end

%% Figure preparation
% params
cndtnVec = dataTb.MSEstm + 1;
randCoeff = 0.4;
barWidth = 0.7;

close all
hfig = figure(1);

% parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 10 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [11 5] ... % width, height
    );

% global parameters
fontname = 'Arial';
fontsize = 5;

% left part (after discharge)
hax = subplot(1, 2, 1);
[ hs] = figf_BarMeanIndpndPlot1( dataTb.LTR, dataTb.ADThrs, cndtnVec, randCoeff, hax );

set(hs.bar, 'EdgeColor', [0 0 0], 'LineWidth', 0.5, 'BarWidth', barWidth);
set(hs.bar(1), 'FaceColor',[1 1 1]);
set(hs.bar(2), 'FaceColor',[0.5 0.5 0.5]);
for i = 1:length(hs.cplt)
    set(hs.cplt{i}, 'LineWidth', 0.5, 'MarkerSize', 4);
end
set(hs.xlbl, 'String', 'Estim');
set(hs.ylbl, 'String', 'Intensity (µA)');
set(hs.ttl, 'String', 'Threshold for HPC');

set(hs.ax,...
    'XLim', [0.5 2.5],...
    'XTick', [1 2],...
    'XTickLabel', {'Off', 'On'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% right panel
hax = subplot(1, 2, 2);
[ hs ] = figf_BarMeanIndpndPlot1( dataTb.LTR, dataTb.sGSThrs, cndtnVec, randCoeff, hax );
set(hs.bar,'EdgeColor',[0 0 0],'LineWidth', 0.5, 'BarWidth', barWidth);
set(hs.bar(1), 'FaceColor',[1 1 1]);
set(hs.bar(2), 'FaceColor',[0.5 0.5 0.5]);
for i = 1:length(hs.cplt)
    set(hs.cplt{i}, 'LineWidth', 0.5, 'MarkerSize', 4);
end
set(hs.xlbl, 'String', 'Estim');
set(hs.ylbl, 'String', 'Intensity (µA)');
set(hs.ttl, 'String', 'Threshold for HPC');

set(hs.ax,...
    'XLim', [0.5 2.5],...
    'XTick', [1 2],...
    'XTickLabel', {'Off', 'On'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% outputs
print(['../results/figure5' panel '.pdf'], '-dpdf');
print(['../results/figure5' panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(dataTb.LTR));
No.Trials = length(dataTb.LTR);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats',...
    'sStatsTest',...
    'sBasicStats_pa',...
    'sStatsTest_pa',...
    'No',...
    '-v7.3')
disp('done')

end
