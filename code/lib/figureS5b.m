function [No] = figureS5b()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 5;
panel = 'B';
outputFileName = ['Figure' supplement num2str(figureNo) panel '.mat'];

%% data import
% tb_80_0 = readtable('../data/LTR1_80_closed0_resultantVec.csv'); % open-loop
tb_80_1 = readtable('../data/LTR1_80_closed1_resultantVec.csv'); % closed-loop
% tb_82_83_0 = readtable('../data/LTR1_82_83_closed0_resultantVec.csv'); % open-loop
% tb_82_83_1 = readtable('../data/LTR1_82_83_closed1_resultantVec.csv'); % closed-loop
tb_99_100_0 = readtable('../data/LTR1_99_100_closed0_resultantVec.csv'); % open-loop
tb_99_100_1 = readtable('../data/LTR1_99_100_closed1_resultantVec.csv'); % closed-loop
% tb_119_120_0 = readtable('../data/LTR1_99_100_closed0_resultantVec.csv'); % open-loop
% tb_119_120_1 = readtable('../data/LTR1_99_100_closed1_resultantVec.csv'); % closed-loop

%% data extraction
% [r, theta, X, Y] = extractParamsFormTb_delay(Tb, LTR, delay, jitter)
% [~,~, X_80_0, Y_80_0] = extracParamsFormTb1(tb_80_0, 80, 0, 0, 0);
[~,~, X_80_1, Y_80_1] = extractParamsFormTb_delay(tb_80_1, 80, 0, 0);
[~,~, X_99_0, Y_99_0] = extractParamsFormTb_delay(tb_99_100_0, 99, 0, 0);
[~,~, X_99_1, Y_99_1] = extractParamsFormTb_delay(tb_99_100_1, 99, 0, 0);
[~,~, X_100_0, Y_100_0] = extractParamsFormTb_delay(tb_99_100_0, 100, 0, 0);
[~,~, X_100_1, Y_100_1] = extractParamsFormTb_delay(tb_99_100_1, 100, 0, 0);

%% calculate mean resultant vectors per animal
% meanXY_80_0 = mean([X_80_0 Y_80_0]);
meanXY_80_1 = mean([X_80_1 Y_80_1]);
meanXY_99_0 = mean([X_99_0 Y_99_0]);
meanXY_99_1 = mean([X_99_1 Y_99_1]);
meanXY_100_0 = mean([X_100_0 Y_100_0]);
meanXY_100_1 = mean([X_100_1 Y_100_1]);

%% Figure preparation
close all

hfig = figure(1);

% left part (open-loop)
hax1 = subplot(1, 2, 1);
max_lim = 1;
x_fake = [0 max_lim 0 -max_lim];
y_fake = [max_lim 0 -max_lim 0];
h_fake = compass(x_fake,y_fake);
hold on
% hcmpss_80_0 = compass(X_80_0, Y_80_0, ':y');
% hcmpss_80_0_m = compass(meanXY_80_0(1), meanXY_80_0(2), 'y');
hcmpss_99_0 = compass(X_99_0, Y_99_0);
hcmpss_99_0_m = compass(meanXY_99_0(1), meanXY_99_0(2));
hcmpss_100_0 = compass(X_100_0, Y_100_0);
hcmpss_100_0_m = compass(meanXY_100_0(1), meanXY_99_0(2));
hold off
set(h_fake,'Visible','off');
httl  = title('open-loop');

% set(hcmpss_80_0,...
%     'LineWidth', 1 ...
%     );
% set(hcmpss_80_0_m,...
%     'LineWidth', 2 ...
%     );
set(hcmpss_99_0,...
    'Color', [1 0 1],...
    'LineWidth', 1 ...
    );
set(hcmpss_99_0_m,...
    'Color', [0 0 0],...
    'LineWidth', 3 ...
    );
set(hcmpss_100_0,...
    'Color', [0 1 0],...
    'LineWidth', 1 ...
    );
set(hcmpss_100_0_m,...
    'Color', [0 0 0],...
    'LineWidth', 3 ...
    );

% right part (closed-loop)
hax2 = subplot(1, 2, 2);
max_lim = 1;
x_fake = [0 max_lim 0 -max_lim];
y_fake = [max_lim 0 -max_lim 0];
h_fake = compass(x_fake,y_fake);
hold on
hcmpss_80_1 = compass(X_80_1, Y_80_1);
hcmpss_80_1_m = compass(meanXY_80_1(1), meanXY_80_1(2));
hcmpss_99_1 = compass(X_99_1, Y_99_1);
hcmpss_99_1_m = compass(meanXY_99_1(1), meanXY_99_1(2));
hcmpss_100_1 = compass(X_100_1, Y_100_1);
hcmpss_100_1_m = compass(meanXY_100_1(1), meanXY_99_1(2));
hold off
set(h_fake,'Visible','off');
htt2  = title('closed-loop');
set(hcmpss_80_1,...
    'Color', [1 0 0],...
    'LineWidth', 1 ...
    );
set(hcmpss_80_1_m,...
    'Color', [0 0 0],...
    'LineWidth', 3 ...
    );
set(hcmpss_99_1,...
    'Color', [0 1 0], ...
    'LineWidth', 1 ...
    );
set(hcmpss_99_1_m,...
    'Color', [0 0 0], ...
    'LineWidth', 3 ...
    );
set(hcmpss_100_1,...
    'Color', [0 0 1],...
    'LineWidth', 1 ...
    );
set(hcmpss_100_1_m,...
    'Color', [0 0 0],...
    'LineWidth', 2 ...
    );

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

% set(hax1,...
%     'FontName', fontname,...
%     'FontSize', fontsize...
%     );
% 
% set(hax2,...
%     'FontName', fontname,...
%     'FontSize', fontsize...
%     );

% outputs
print('../results/figureS5b.pdf', '-dpdf');
print('../results/figureS5b.png', '-dpng');
close all

%% Number of rats and trials
No.trials_0 = sum(height(tb_99_100_0));
No.trials_1 = sum(height(tb_80_1), height(tb_99_100_1));

%% Save
save(['../results/' outputFileName], 'No')
disp('done')

end
