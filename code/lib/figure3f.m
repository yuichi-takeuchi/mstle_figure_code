function [sBasicStats, sStatsTest, No] = figure3f()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
figureNo = 3;
panel = 'f';
inputFileName = ['Figure' num2str(figureNo) '_0_20.csv'];
outputFileName = ['figure' num2str(figureNo) panel '.mat'];

%% Data import
Tb20 = readtable(['../data/' inputFileName]);
Tb20 = Tb20(Tb20.MSEstm == 1, :);

%% Basic statistics and Statistical tests (delay 0 ms)
Tb20_0msdly = Tb20(Tb20.stmDly == 0, :);
r_0msdly_nsccss = Tb20_0msdly.r(~Tb20_0msdly.Thresholded);
r_0msdly_sccss = Tb20_0msdly.r(logical(Tb20_0msdly.Thresholded));

% outlier removals
q_nsccss = prctile(r_0msdly_nsccss, [25 50 75]);
q_sccss = prctile(r_0msdly_sccss, [25 50 75]);

ll = @(q) q(1) - 1.5 * (q(3) - q(1));
ul = @(q) q(3) + 1.5 * (q(3) - q(1));

ll_nsccss = ll(q_nsccss);
ul_nsccss = ul(q_nsccss);

ll_sccss = ll(q_sccss);
ul_sccss = ul(q_sccss);

r_nsccss_stat = r_0msdly_nsccss(r_0msdly_nsccss > ll_nsccss & r_0msdly_nsccss < ul_nsccss);
r_sccss_stat = r_0msdly_sccss(r_0msdly_sccss > ll_sccss & r_0msdly_sccss < ul_sccss);

[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs2( r_nsccss_stat, r_sccss_stat );

%% Figure preparation (boxplot)

close all
hfig = figure(1);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 3 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [3 4]... % width, height
);

hax = axes(hfig);

x = [r_0msdly_nsccss; r_0msdly_sccss];

gnsccss = repmat({'non_success'}, size(r_0msdly_nsccss));
gsccss = repmat({'success'}, size(r_0msdly_sccss));
g = [gnsccss; gsccss];

hbox = boxplot(hax,x,g, 'Color', 'kb');
box('off')
hylbl1 = ylabel('r length');
% hxlbl = xlabel('');

httl = title('Length of resultant vector');

set(hax,...
    'YLim', [0 1],...
    'XTickLabel', {'non-success', 'success'},...
    'FontName', 'Arial',...
    'FontSize', 5 ...
    );

print(['../results/figure' num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(Tb20_0msdly.LTR));
No.Trials = length(Tb20_0msdly.LTR);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats',...
    'sStatsTest',...
    'No')

disp('done')

end
