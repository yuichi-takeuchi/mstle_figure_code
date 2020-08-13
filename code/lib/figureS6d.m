function [sBasicStats_offset, sStatsTest_offset,...
          sBasicStats_offset_pa, sStatsTest_offset_pa] = figureS6d()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 6;
panel = 'D';
outputFileName = ['Figure' supplement num2str(figureNo) panel '.mat'];

%% data import
tb_82_83_1 = readtable('../data/LTR1_82_83_closed1_resultantVec.csv'); % closed-loop
tb_119_120_1 = readtable('../data/LTR1_119_120_closed1_resultantVec.csv'); % closed-loop

%% get basic stats and tests on vector length per trial
tb_stack = [tb_82_83_1;tb_119_120_1];
tb_clsd = tb_stack(tb_stack.jitter ~= 1, :);

[sBasicStats_offset] = stats_sBasicStats_anova1( tb_clsd.r, tb_clsd.offset );
[sStatsTest_offset] = stats_ANOVA1StatsStructs1( tb_clsd.r, tb_clsd.offset );

%% get basic stats and tests on vector length per animal
[MeanPerAnimal, ~, offsetVec] = statsf_meanPer1With2(tb_clsd.r, tb_clsd.LTR, tb_clsd.offset);

[sBasicStats_offset_pa] = stats_sBasicStats_anova1( MeanPerAnimal, offsetVec );
[sStatsTest_offset_pa] = stats_ANOVA1StatsStructs1( MeanPerAnimal, offsetVec );

%% graph 
cndtnVec = zeros(size(tb_clsd.LTR));
cndtnVec(tb_clsd.offset == 0) = 1;
cndtnVec(tb_clsd.offset == 20) = 2;
cndtnVec(tb_clsd.offset == 40) = 3;

close all
fignum = 1;
% building a plot
[ hs ] = figf_BarMeanScat1( tb_clsd.LTR, tb_clsd.r, cndtnVec, fignum );
 
% setting parametors of bars and plots
set(hs.hb,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth', 0.5);
set(hs.hsct, 'MarkerSize', 4);
set(hs.hylabel, 'String', 'r');
set(hs.hxlabel, 'String', 'Time after seizure onset (s)');
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
    'XTickLabel', {'0 – 20', '20 – 40', '40 – 60'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% outputs
print('../results/figureS6d.pdf', '-dpdf');
print('../results/figureS6d.png', '-dpng');
close all

%% Number of rats and trials
% No.trials_0 = sum(height(tb_99_100_0));
% No.trials_1 = sum(height(tb_80_1), height(tb_99_100_1));

%% Save
save(['../results/' outputFileName], ...
    'sBasicStats_offset',...
    'sStatsTest_offset',...
    'sBasicStats_offset_pa',...
    'sStatsTest_offset_pa'... 
    )
disp('done')

end

