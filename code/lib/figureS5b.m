function [No] = figureS5b()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 5;
panel = 'b';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% data import
tb_80_1 = readtable('../data/LTR1_80_closed1_resultantVec.csv'); % closed-loop
tb_99_100_0 = readtable('../data/LTR1_99_100_closed0_resultantVec.csv'); % open-loop
tb_99_100_1 = readtable('../data/LTR1_99_100_closed1_resultantVec.csv'); % closed-loop
tb_127_128_0 = readtable('../data/LTR1_127_128_closed0_resultantVec.csv'); % open-loop
tb_127_128_1 = readtable('../data/LTR1_127_128_closed1_resultantVec.csv'); % closed-loop
tb_129_130_0 = readtable('../data/LTR1_129_130_closed0_resultantVec.csv'); % open-loop
tb_129_130_1 = readtable('../data/LTR1_129_130_closed1_resultantVec.csv'); % closed-loop

%% data extraction
[~,~, X_80_1, Y_80_1] = extractParamsFromTb_LTR_delay_jitter(tb_80_1, 80, 0, 0);
[~,~, X_99_0, Y_99_0] = extractParamsFromTb_LTR_delay_jitter(tb_99_100_0, 99, 0, 0);
[~,~, X_99_1, Y_99_1] = extractParamsFromTb_LTR_delay_jitter(tb_99_100_1, 99, 0, 0);
[~,~, X_100_0, Y_100_0] = extractParamsFromTb_LTR_delay_jitter(tb_99_100_0, 100, 0, 0);
[~,~, X_100_1, Y_100_1] = extractParamsFromTb_LTR_delay_jitter(tb_99_100_1, 100, 0, 0);
[~,~, X_127_0, Y_127_0] = extractParamsFromTb_LTR_delay_jitter(tb_127_128_0, 127, 0, 0);
[~,~, X_127_1, Y_127_1] = extractParamsFromTb_LTR_delay_jitter(tb_127_128_1, 127, 0, 0);
[~,~, X_128_0, Y_128_0] = extractParamsFromTb_LTR_delay_jitter(tb_127_128_0, 128, 0, 0);
[~,~, X_128_1, Y_128_1] = extractParamsFromTb_LTR_delay_jitter(tb_127_128_1, 128, 0, 0);
[~,~, X_129_0, Y_129_0] = extractParamsFromTb_LTR_delay_jitter(tb_129_130_0, 129, 0, 0);
[~,~, X_129_1, Y_129_1] = extractParamsFromTb_LTR_delay_jitter(tb_129_130_1, 129, 0, 0);
[~,~, X_130_0, Y_130_0] = extractParamsFromTb_LTR_delay_jitter(tb_129_130_0, 130, 0, 0);
[~,~, X_130_1, Y_130_1] = extractParamsFromTb_LTR_delay_jitter(tb_129_130_1, 130, 0, 0);

%% calculate mean resultant vectors per animal
meanXY_80_1 = mean([X_80_1 Y_80_1]);
meanXY_99_0 = mean([X_99_0 Y_99_0]);
meanXY_99_1 = mean([X_99_1 Y_99_1]);
meanXY_100_0 = mean([X_100_0 Y_100_0]);
meanXY_100_1 = mean([X_100_1 Y_100_1]);
meanXY_127_0 = mean([X_127_0 Y_127_0]);
meanXY_127_1 = mean([X_127_1 Y_127_1]);
meanXY_128_0 = mean([X_128_0 Y_128_0]);
meanXY_128_1 = mean([X_128_1 Y_128_1]);
meanXY_129_0 = mean([X_129_0 Y_129_0]);
meanXY_129_1 = mean([X_129_1 Y_129_1]);
meanXY_130_0 = mean([X_130_0 Y_130_0]);
meanXY_130_1 = mean([X_130_1 Y_130_1]);

%% Figure preparation
close all
hfig = figure(1);

% left part (open-loop)
hax(1) = subplot(1, 2, 1);
max_lim = 1;
x_fake = [0 max_lim 0 -max_lim];
y_fake = [max_lim 0 -max_lim 0];
h_fake = compass(x_fake,y_fake);
hold on
hcmpss_0_1 = compass(X_99_0, Y_99_0);
hcmpss_0_2 = compass(X_100_0, Y_100_0);
hcmpss_0_3 = compass(X_127_0, Y_127_0);
hcmpss_0_4 = compass(X_128_0, Y_128_0);
hcmpss_0_5 = compass(X_129_0, Y_129_0);
hcmpss_0_6 = compass(X_130_0, Y_130_0);
hcmpss_0_m_1 = compass(meanXY_99_0(1), meanXY_99_0(2));
hcmpss_0_m_2 = compass(meanXY_100_0(1), meanXY_100_0(2));
hcmpss_0_m_3 = compass(meanXY_127_0(1), meanXY_127_0(2));
hcmpss_0_m_4 = compass(meanXY_128_0(1), meanXY_128_0(2));
hcmpss_0_m_5 = compass(meanXY_129_0(1), meanXY_129_0(2));
hcmpss_0_m_6 = compass(meanXY_130_0(1), meanXY_130_0(2));
hold off
set(h_fake,'Visible','off');
htt(1)  = title('open-loop');

set(hcmpss_0_1,'LineWidth', 0.3, 'Color', defaultColor(1));
set(hcmpss_0_2,'LineWidth', 0.3 ,'Color', defaultColor(2));
set(hcmpss_0_3,'LineWidth', 0.3 ,'Color', defaultColor(3));
set(hcmpss_0_4,'LineWidth', 0.3 ,'Color', defaultColor(4));
set(hcmpss_0_5,'LineWidth', 0.3 ,'Color', defaultColor(5));
set(hcmpss_0_6,'LineWidth', 0.3 ,'Color', defaultColor(6));
set(hcmpss_0_m_1, 'LineWidth', 2, 'Color', defaultColor(1)*0.5);
set(hcmpss_0_m_2, 'LineWidth', 2, 'Color', defaultColor(2)*0.5);
set(hcmpss_0_m_3, 'LineWidth', 2, 'Color', defaultColor(3)*0.5);
set(hcmpss_0_m_4, 'LineWidth', 2, 'Color', defaultColor(4)*0.5);
set(hcmpss_0_m_5, 'LineWidth', 2, 'Color', defaultColor(5)*0.5);
set(hcmpss_0_m_6, 'LineWidth', 2, 'Color', defaultColor(6)*0.5);

% right part (closed-loop)
hax(2) = subplot(1, 2, 2);
max_lim = 1;
x_fake = [0 max_lim 0 -max_lim];
y_fake = [max_lim 0 -max_lim 0];
h_fake = compass(x_fake,y_fake);
hold on
hcmpss_1_1 = compass(X_99_1, Y_99_1);
hcmpss_1_2 = compass(X_100_1, Y_100_1);
hcmpss_1_3 = compass(X_127_1, Y_127_1);
hcmpss_1_4 = compass(X_128_1, Y_128_1);
hcmpss_1_5 = compass(X_129_1, Y_129_1);
hcmpss_1_6 = compass(X_130_1, Y_130_1);
hcmpss_1_7 = compass(X_80_1, Y_80_1);
hcmpss_1_m_1 = compass(meanXY_99_1(1), meanXY_99_1(2));
hcmpss_1_m_2 = compass(meanXY_100_1(1), meanXY_100_1(2));
hcmpss_1_m_3 = compass(meanXY_127_1(1), meanXY_127_1(2));
hcmpss_1_m_4 = compass(meanXY_128_1(1), meanXY_128_1(2));
hcmpss_1_m_5 = compass(meanXY_129_1(1), meanXY_129_1(2));
hcmpss_1_m_6 = compass(meanXY_130_1(1), meanXY_130_1(2));
hcmpss_1_m_7 = compass(meanXY_80_1(1), meanXY_80_1(2));
hold off
set(h_fake,'Visible','off');
htt(2)  = title('closed-loop');

set(hcmpss_1_1,'LineWidth', 0.3, 'Color', defaultColor(1));
set(hcmpss_1_2,'LineWidth', 0.3 ,'Color', defaultColor(2));
set(hcmpss_1_3,'LineWidth', 0.3 ,'Color', defaultColor(3));
set(hcmpss_1_4,'LineWidth', 0.3 ,'Color', defaultColor(4));
set(hcmpss_1_5,'LineWidth', 0.3 ,'Color', defaultColor(5));
set(hcmpss_1_6,'LineWidth', 0.3 ,'Color', defaultColor(6));
set(hcmpss_1_7,'LineWidth', 0.3 ,'Color', defaultColor(7));
set(hcmpss_1_m_1, 'LineWidth', 2, 'Color', defaultColor(1)*0.5);
set(hcmpss_1_m_2, 'LineWidth', 2, 'Color', defaultColor(2)*0.5);
set(hcmpss_1_m_3, 'LineWidth', 2, 'Color', defaultColor(3)*0.5);
set(hcmpss_1_m_4, 'LineWidth', 2, 'Color', defaultColor(4)*0.5);
set(hcmpss_1_m_5, 'LineWidth', 2, 'Color', defaultColor(5)*0.5);
set(hcmpss_1_m_6, 'LineWidth', 2, 'Color', defaultColor(6)*0.5);
set(hcmpss_1_m_7, 'LineWidth', 2, 'Color', defaultColor(7)*0.5);

fontname = 'Arial';
fontsize = 8;

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 9 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [10 5] ... % width, height
    );

th = findall(gcf,'Type','text');
for i = 1:length(th)
    set(th(i),'FontName', fontname)
    set(th(i),'FontSize', fontsize)
end

% outputs
print('../results/figureS5b.pdf', '-dpdf');
print('../results/figureS5b.png', '-dpng');
close all

%% Number of rats and trials
No.trials_0 = sum([height(tb_99_100_0), height(tb_127_128_0), height(tb_129_130_0)]);
No.trials_1 = sum([height(tb_80_1), height(tb_99_100_1), height(tb_127_128_1), height(tb_129_130_1)]);

%% Save
save(['../results/' outputFileName], 'No')
disp('done')

end
