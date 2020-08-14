function [sBasicStats_intrvntn, sStatsTest_intrvntn, sBasicStats_intrvntn_pa,sStatsTest_intrvntn_pa] = figureS5c()
% Copyright (c) 2020 Yuichi Takeuchi
%% params
supplement = 'S';
figureNo = 5;
panel = 'C';
outputFileName = ['Figure' supplement num2str(figureNo) panel '.mat'];

%% data import
% tb_80_0 = readtable('../data/LTR1_80_closed0_resultantVec.csv'); % open-loop
tb_80_1 = readtable('../data/LTR1_80_closed1_resultantVec.csv'); % closed-loop
tb_99_100_0 = readtable('../data/LTR1_99_100_closed0_resultantVec.csv'); % open-loop
tb_99_100_1 = readtable('../data/LTR1_99_100_closed1_resultantVec.csv'); % closed-loop

%% data reorganization
dataTb = [tb_80_1; tb_99_100_0; tb_99_100_1];
cndtnVec = zeros(size(dataTb.LTR));
cndtnVec(dataTb.closed == 0) = 1;
cndtnVec(dataTb.closed == 1 & dataTb.jitter == 0) = 2;
cndtnVec(dataTb.closed == 1 & dataTb.jitter == 1) = 3;

%% get basic stats and tests on vector length per trial
[sBasicStats_intrvntn] = stats_sBasicStats_anova1( dataTb.r, cndtnVec );
[sStatsTest_intrvntn] = stats_ANOVA1StatsStructs1( dataTb.r, cndtnVec , 'bonferroni');

%% get basic stats and tests on vector length per animal
% [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(dataTb.r, dataTb.LTR, cndtnVec);
[MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(dataTb.r, dataTb.LTR, cndtnVec);
% [sBasicStats_intrvntn_pa] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
[sBasicStats_intrvntn_pa] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
[sStatsTest_intrvntn_pa] = stats_ANOVA1StatsStructs1( MeanPerAnimal, intrvntnVec, 'bonferroni');

%% graph 
close all
fignum = 1;
% building a plot
[ hs ] = figf_BarMeanScat1( dataTb.LTR, dataTb.r, cndtnVec, fignum );
 
% setting parametors of bars and plots
set(hs.hb,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth', 0.5);
set(hs.hsct, 'MarkerSize', 4);
set(hs.hylabel, 'String', 'r');
set(hs.hxlabel, 'String', 'intervention');
set(hs.htitle, 'String', 'Length of resultant vector');

% global arameters
fontname = 'Arial';
fontsize = 6;

% parameter settings
set(hs.hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 9 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [10 5] ... % width, height
    );

% axis parameter settings
set(hs.hax,...
    'YLim', [0 1],...
    'XLim', [0 4],...
    'XTick', [1 2 3],...
    'XTickLabel', {'open', 'closed', 'closed + jitter'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% outputs
print('../results/figureS5c.pdf', '-dpdf');
print('../results/figureS5c.png', '-dpng');
close all

%% Number of rats and trials
% No.trials_0 = sum(height(tb_99_100_0));
% No.trials_1 = sum(height(tb_80_1), height(tb_99_100_1));

%% Save
save(['../results/' outputFileName],...
    'sBasicStats_intrvntn',...
    'sStatsTest_intrvntn',...
    'sBasicStats_intrvntn_pa',...
    'sStatsTest_intrvntn_pa')
disp('done')

end

