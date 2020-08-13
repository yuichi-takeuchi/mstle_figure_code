function [No] = figureS6b()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 6;
panel = 'B';
outputFileName = ['Figure' supplement num2str(figureNo) panel '.mat'];

%% data import
tb_82_83_0 = readtable('../data/LTR1_82_83_closed0_resultantVec.csv'); % open-loop
tb_82_83_1 = readtable('../data/LTR1_82_83_closed1_resultantVec.csv'); % closed-loop
tb_119_120_0 = readtable('../data/LTR1_119_120_closed0_resultantVec.csv'); % open-loop
tb_119_120_1 = readtable('../data/LTR1_119_120_closed1_resultantVec.csv'); % closed-loop

%% data extraction
[~,~, X_82_0, Y_82_0] = extractParamsFromTb_LTR_delay_jitter(tb_82_83_0, 82, 0, 0);
[~,~, X_82_1, Y_82_1] = extractParamsFromTb_LTR_delay_jitter(tb_82_83_1, 82, 0, 0);
[~,~, X_83_0, Y_83_0] = extractParamsFromTb_LTR_delay_jitter(tb_82_83_0, 83, 0, 0);
[~,~, X_83_1, Y_83_1] = extractParamsFromTb_LTR_delay_jitter(tb_82_83_1, 83, 0, 0);
[~,~, X_119_0, Y_119_0] = extractParamsFromTb_LTR_delay_jitter(tb_119_120_0, 119, 0, 0);
[~,~, X_119_1, Y_119_1] = extractParamsFromTb_LTR_delay_jitter(tb_119_120_1, 119, 0, 0);
[~,~, X_120_0, Y_120_0] = extractParamsFromTb_LTR_delay_jitter(tb_119_120_0, 120, 0, 0);
[~,~, X_120_1, Y_120_1] = extractParamsFromTb_LTR_delay_jitter(tb_119_120_1, 120, 0, 0);

%% calculate mean resultant vectors per animal
meanXY_82_0 = mean([X_82_0 Y_82_0]);
meanXY_82_1 = mean([X_82_1 Y_82_1]);
meanXY_83_0 = mean([X_83_0 Y_83_0]);
meanXY_83_1 = mean([X_83_1 Y_83_1]);
meanXY_119_0 = mean([X_119_0 Y_119_0]);
meanXY_119_1 = mean([X_119_1 Y_119_1]);
meanXY_120_0 = mean([X_120_0 Y_120_0]);
meanXY_120_1 = mean([X_120_1 Y_120_1]);

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
hcmpss_0_1 = compass(X_82_0, Y_82_0);
hcmpss_0_2 = compass(X_83_0, Y_83_0);
hcmpss_0_3 = compass(X_119_0, Y_119_0);
hcmpss_0_4 = compass(X_120_0, Y_120_0);
hcmpss_0_m_1 = compass(meanXY_82_0(1), meanXY_82_0(2));
hcmpss_0_m_2 = compass(meanXY_83_0(1), meanXY_83_0(2));
hcmpss_0_m_3 = compass(meanXY_119_0(1), meanXY_119_0(2));
hcmpss_0_m_4 = compass(meanXY_120_0(1), meanXY_120_0(2));
hold off
set(h_fake,'Visible','off');
htt(1)  = title('open-loop');

set(hcmpss_0_1, 'LineWidth', 1, 'Color', [1 0 1]);
set(hcmpss_0_2, 'LineWidth', 1, 'Color', [0 1 0]);
set(hcmpss_0_3, 'LineWidth', 1, 'Color', [0 1 1]);
set(hcmpss_0_4, 'LineWidth', 1, 'Color', [1 0 0]);
set(hcmpss_0_m_1, 'LineWidth', 3, 'Color', [0.3 0 0.3]);
set(hcmpss_0_m_2, 'LineWidth', 3, 'Color', [0 0.3 0]);
set(hcmpss_0_m_3, 'LineWidth', 3, 'Color', [0 0.3 0.3]);
set(hcmpss_0_m_4, 'LineWidth', 3, 'Color', [0.3 0 0]);

% right part (closed-loop)
hax(2) = subplot(1, 2, 2);
max_lim = 1;
x_fake = [0 max_lim 0 -max_lim];
y_fake = [max_lim 0 -max_lim 0];
h_fake = compass(x_fake,y_fake);
hold on
hcmpss_1_1 = compass(X_82_1, Y_82_1);
hcmpss_1_2 = compass(X_83_1, Y_83_1);
hcmpss_1_3 = compass(X_119_1, Y_119_1);
hcmpss_1_4 = compass(X_120_1, Y_120_1);
hcmpss_1_m_1 = compass(meanXY_82_1(1), meanXY_82_1(2));
hcmpss_1_m_2 = compass(meanXY_83_1(1), meanXY_83_1(2));
hcmpss_1_m_3 = compass(meanXY_119_1(1), meanXY_119_1(2));
hcmpss_1_m_4 = compass(meanXY_120_1(1), meanXY_120_1(2));
hold off
set(h_fake,'Visible','off');
htt(2)  = title('closed-loop');

set(hcmpss_1_1, 'LineWidth', 1, 'Color', [1 0 1]);
set(hcmpss_1_2, 'LineWidth', 1, 'Color', [0 1 0]);
set(hcmpss_1_3, 'LineWidth', 1, 'Color', [0 1 1]);
set(hcmpss_1_4, 'LineWidth', 1, 'Color', [1 0 0]);
set(hcmpss_1_m_1, 'LineWidth', 3, 'Color', [0.3 0 0.3]);
set(hcmpss_1_m_2, 'LineWidth', 3, 'Color', [0 0.3 0]);
set(hcmpss_1_m_3, 'LineWidth', 3, 'Color', [0 0.3 0.3]);
set(hcmpss_1_m_4, 'LineWidth', 3, 'Color', [0.3 0 0]);

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
print('../results/figureS6b.pdf', '-dpdf');
print('../results/figureS6b.png', '-dpng');
close all

%% Number of rats and trials
No.trials_0 = sum(height(tb_82_83_0), height(tb_119_120_0));
No.trials_1 = sum(height(tb_82_83_1), height(tb_119_120_1));

%% Save
save(['../results/' outputFileName], 'No')
disp('done')

end
