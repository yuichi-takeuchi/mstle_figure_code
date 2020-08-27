function [sBasicStats, sStatsTest, No] = figureS9a()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 9;
panel = 'a';
inputFileName1 = 'Figure3_0_20.csv';
inputFileName2 = 'Figure3_20_60.csv';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% Data import
Tb20 = readtable(['../data/' inputFileName1]);
Tb20 = Tb20(Tb20.MSEstm == 1, :);
Tb60 = readtable(['../data/' inputFileName2]);
Tb60 = Tb60(Tb60.MSEstm == 1, :);

%% Basic statistics and Statistical tests (delay 0 ms)
Tbs = {Tb20, Tb60};
for i = 1:length(Tbs)
    Tb = Tbs{i};
    r_nsccss = Tb.r(~Tb.Thresholded);
    r_sccss = Tb.r(logical(Tb.Thresholded));

    % outlier removals
    q_nsccss = prctile(r_nsccss, [25 50 75]);
    q_sccss = prctile(r_sccss, [25 50 75]);

    ll = @(q) q(1) - 1.5 * (q(3) - q(1));
    ul = @(q) q(3) + 1.5 * (q(3) - q(1));

    ll_nsccss = ll(q_nsccss);
    ul_nsccss = ul(q_nsccss);

    ll_sccss = ll(q_sccss);
    ul_sccss = ul(q_sccss);

    r_nsccss_stat = r_nsccss(r_nsccss > ll_nsccss & r_nsccss < ul_nsccss);
    r_sccss_stat = r_sccss(r_sccss > ll_sccss & r_sccss < ul_sccss);

    [ sBasicStats(i), sStatsTest(i) ] = statsf_getBasicStatsAndTestStructs2( r_nsccss_stat, r_sccss_stat );
end

%% Figure preparation (boxplot)
close all
hfig = figure(1);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 8 5],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [8 5]... % width, height
);

hax = axes(hfig);

r_nsccss_20 = Tb20.r(~Tb20.Thresholded);
r_sccss_20 = Tb20.r(logical(Tb20.Thresholded));
r_nsccss_60 = Tb60.r(~Tb60.Thresholded);
r_sccss_60 = Tb60.r(logical(Tb60.Thresholded));

x = [r_nsccss_20; r_sccss_20; r_nsccss_60; r_sccss_60];

gnsccss_20 = repmat({'non_success_20'}, size(r_nsccss_20));
gsccss_20 = repmat({'success_20'}, size(r_sccss_20));
gnsccss_60 = repmat({'non_success_60'}, size(r_nsccss_60));
gsccss_60 = repmat({'success_60'}, size(r_sccss_60));

g = [gnsccss_20; gsccss_20; gnsccss_60; gsccss_60];

hbox = boxplot(hax,x,g, 'Color', 'kb');
box('off')
hylbl1 = ylabel('r length');
hxlbl = xlabel('Time after seizure onset (s)');

httl = title('Length of resultant vector');

set(hax,...
    'YLim', [0 1],...
    'XTickLabel', {'0–20', '0–20', '0–60', '0–60'},...
    'FontName', 'Arial',...
    'FontSize', 5 ...
    );

hlgnd = legend(findall(hax, 'Tag', 'Box'), {'non-success', 'success'}, 'location', 'northeastoutside', 'box', 'off');

print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats(1) = length(unique(Tb20.LTR));
No.Trials(1) = length(Tb20.LTR);
No.Rats(2) = length(unique(Tb60.LTR));
No.Trials(2) = length(Tb60.LTR);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats',...
    'sStatsTest',...
    'No')

disp('done')

end
