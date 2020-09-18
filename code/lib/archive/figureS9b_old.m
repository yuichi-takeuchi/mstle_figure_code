function [CorStatTest, No] = figureS9b()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 9;
panel = 'b';
inputFileName1 = 'Figure3_0_20.csv';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% r scattered plot with MI all
Tb20 = readtable(['../data/' inputFileName1]);

% parameters
LTR = Tb20.LTR;
r_0_20 = Tb20.r;
MI = Tb20.MI;

% nan rejection and conditioning
idx = ~isnan(r_0_20) & ~isnan(MI);
r = r_0_20(idx);
MI = MI(idx);
LTR = LTR(idx);

% getting a regression line
coeffrMI = polyfit(r, MI, 1);

% r vs MI
CorStatTest.Label = 'r_0_20 vs MI';
R = corrcoef(r, MI);
CorStatTest.coefR = R;
[rho, pval] = corr(r, MI, 'Type', 'Pearson');
CorStatTest.PearsonRho = rho;
CorStatTest.PearsonP = pval;
[rho, pval] = corr(r, MI, 'Type', 'Spearman');
CorStatTest.SpearmanRho = rho;
CorStatTest.SpearmanP = pval;

hfig = figure(1);

% figure parameter settings
fontname = 'Arial';
fontsize = 5;

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 5 5],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [5 5]... % width, height
    );

hax = axes(hfig);

[ hs ] = figf_ScatGroupedRefline1( hax, r, MI, LTR, coeffrMI, CorStatTest.coefR);

set(hs.scttr,...
    'MarkerEdgeColor', [0 0 0],...
    'Sizedata', 10);

set(hs.rl,...
    'Color', [0 0 1],...
    'LineWidth', 1);

set(hs.txt,...
    'fontsize', fontsize,...
    'verticalalignment', 'top',...
    'horizontalalignment', 'left');

set(hs.xlbl, 'String', 'Length of resultant vector (r)');
set(hs.ylbl, 'String', 'Modulation index (MI)');
set(hs.ttl, 'String', ' r vs MI');



set(hs.ax,...
    'FontName', fontname,...
    'FontSize', fontsize);

% outputs
print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(Tb20.LTR));
No.Trials = length(Tb20.LTR);

%% Save
save(['../results/' outputFileName],...
    'CorStatTest',...
    'No')

disp('done')

end
