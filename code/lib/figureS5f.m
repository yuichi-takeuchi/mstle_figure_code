function [sBasicStats, sStatsTest, sBasicStats_pa, sStatsTest_pa] = figureS5f()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 5;
panel = 'F';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% data import
tb_80_1 = readtable('../data/LTR1_80_closed1_resultantVec.csv'); % closed-loop
tb_99_100_1 = readtable('../data/LTR1_99_100_closed1_resultantVec.csv'); % closed-loop
tb_127_128_1 = readtable('../data/LTR1_127_128_closed1_resultantVec.csv'); % closed-loop
tb_129_130_1 = readtable('../data/LTR1_129_130_closed1_resultantVec.csv'); % closed-loop

%% get basic stats and tests on vector length per trial
tb_stack = [tb_99_100_1; tb_127_128_1; tb_129_130_1; tb_80_1];
tb_clsd = tb_stack(tb_stack.jitter ~= 1, :);

[sBasicStats] = stats_sBasicStats_anova1( tb_clsd.r, tb_clsd.delay );
[sStatsTest] = stats_ANOVA1StatsStructs1( tb_clsd.r, tb_clsd.delay, 'bonferroni');

%% get basic stats and tests on vector length per animal
[MeanPerAnimal, ~, delayVec] = statsf_meanPer1With2(tb_clsd.r, tb_clsd.LTR, tb_clsd.delay);

[sBasicStats_pa] = stats_sBasicStats_anova1( MeanPerAnimal, delayVec );
[sStatsTest_pa] = stats_ANOVA1StatsStructs1( MeanPerAnimal, delayVec, 'bonferroni');

%% graph 
cndtnVec = zeros(size(tb_clsd.LTR));
cndtnVec(tb_clsd.delay == 0) = 1;
cndtnVec(tb_clsd.delay == 20) = 2;
cndtnVec(tb_clsd.delay == 40) = 3;
cndtnVec(tb_clsd.delay == 60) = 4;

close all
fignum = 1;
% building a plot
[ hs ] = figf_BarMeanScat1( tb_clsd.LTR, tb_clsd.r, cndtnVec, fignum );
 
% setting parametors of bars and plots
set(hs.bar,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth', 0.5);
set(hs.sct, 'MarkerSize', 4);
set(hs.ylbl, 'String', 'r');
set(hs.xlbl, 'String', 'Stimulus delay (ms)');
set(hs.ttl, 'String', 'Length of resultant vector');

% global arameters
fontname = 'Arial';
fontsize = 6;

% parameter settings
set(hs.fig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 14 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [15 5] ... % width, height
    );

% axis parameter settings
set(hs.ax,...
    'YLim', [0 1],...
    'XLim', [0 5],...
    'XTick', [1 2 3 4],...
    'XTickLabel', {'0', '20', '40', '60'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% outputs
print('../results/figureS5f.pdf', '-dpdf');
print('../results/figureS5f.png', '-dpng');
close all

%% Number of rats and trials
% No.trials_0 = sum(height(tb_99_100_0));
% No.trials_1 = sum(height(tb_80_1), height(tb_99_100_1));

%% Save
save(['../results/' outputFileName], ...
    'sBasicStats',...
    'sStatsTest',...
    'sBasicStats_pa',...
    'sStatsTest_pa'... 
    )
disp('done')

end

