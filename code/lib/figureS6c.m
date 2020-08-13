function [sBasicStats_clsd, sStatsTest_clsd,...
    sBasicStats_jttr, sStatsTest_jttr,...
    sBasicStats_clsd_pa, sStatsTest_clsd_pa,...
    sBasicStats_jttr_pa, sStatsTest_jttr_pa] = figureS6c()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 6;
panel = 'C';
outputFileName = ['Figure' supplement num2str(figureNo) panel '.mat'];

%% data import
tb_82_83_0 = readtable('../data/LTR1_82_83_closed0_resultantVec.csv'); % open-loop
tb_82_83_1 = readtable('../data/LTR1_82_83_closed1_resultantVec.csv'); % closed-loop
tb_119_120_0 = readtable('../data/LTR1_99_100_closed0_resultantVec.csv'); % open-loop
tb_119_120_1 = readtable('../data/LTR1_99_100_closed1_resultantVec.csv'); % closed-loop

%% data extraction
[r_82_0, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_82_83_0, 82, 0);
[r_82_1, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_82_83_1, 82, 0);
[r_83_0, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_82_83_0, 83, 0);
[r_83_1, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_82_83_1, 83, 0);
[r_82_1_j, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_82_83_1, 82, 1);
[r_83_1_j, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_82_83_1, 83, 1);
[r_119_0, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_119_120_0, 119, 0);
[r_119_1, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_119_120_1, 119, 0);
[r_120_0, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_119_120_0, 120, 0);
[r_120_1, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_119_120_1, 120, 0);
[r_119_1_j, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_119_120_1, 119, 1);
[r_120_1_j, ~, ~, ~] = extractParamsFromTb_LTR_jitter(tb_119_120_1, 120, 1);

%% get basic stats and tests on vector length per trial
r_open = [r_82_0;r_83_0;r_119_0;r_120_0];
r_closed = [r_82_1;r_83_1;r_119_1;r_120_1];
r_jitter =[r_82_1_j;r_83_1_j;r_119_1_j;r_120_1_j];
% open vs. closed-loop
[ sBasicStats_clsd, sStatsTest_clsd ] = statsf_getBasicStatsAndTestStructs2( r_open, r_closed );
% closed vs. jitter
[ sBasicStats_jttr, sStatsTest_jttr ] = statsf_getBasicStatsAndTestStructs2( r_closed, r_jitter );

%% get basic stats and tests on vector length per animal
r_open_pa = cellfun(@mean, {r_82_0;r_83_0;r_119_0;r_120_0});
r_closed_pa = cellfun(@mean, {r_82_1;r_83_1;r_119_1;r_120_1});
r_jitter_pa = cellfun(@mean, {r_82_1_j;r_83_1_j;r_119_1_j;r_120_1_j});
% open vs. closed-loop
[ sBasicStats_clsd_pa, sStatsTest_clsd_pa ] = statsf_getBasicStatsAndTestStructs2( r_open_pa, r_closed_pa );
% closed vs. jitter
[ sBasicStats_jttr_pa, sStatsTest_jttr_pa ] = statsf_getBasicStatsAndTestStructs2( r_closed_pa, r_jitter_pa );

%% graph 
dataTb = [tb_82_83_0; tb_82_83_1; tb_119_120_0; tb_119_120_1];

cndtnVec = zeros(size(dataTb.LTR));
cndtnVec(dataTb.closed == 0) = 1;
cndtnVec(dataTb.closed == 1 & dataTb.jitter == 0) = 2;
cndtnVec(dataTb.closed == 1 & dataTb.jitter == 1) = 3;

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
print('../results/figureS6c.pdf', '-dpdf');
print('../results/figureS6c.png', '-dpng');
close all

%% Number of rats and trials
% No.trials_0 = sum(height(tb_99_100_0));
% No.trials_1 = sum(height(tb_80_1), height(tb_99_100_1));

%% Save
save(['../results/' outputFileName], ...
    'sBasicStats_clsd', ...
    'sStatsTest_clsd', ...
    'sBasicStats_jttr', ...
    'sStatsTest_jttr', ...
    'sBasicStats_clsd_pa', ...
    'sStatsTest_clsd_pa', ...
    'sBasicStats_jttr_pa', ...
    'sStatsTest_jttr_pa')
disp('done')

end

