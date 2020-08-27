function [CorStatTest, No] = figureS9d()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 9;
panel = 'd';
inputFileName1 = 'Figure3_0_20.csv';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% r scattered plot with MI all
Tb20 = readtable(['../data/' inputFileName1]);
Tb20 = Tb20(Tb20.MSEstm == 1,:);

% parameters
LTR = Tb20.LTR;
r_0_20 = Tb20.r;
HPC = Tb20.HPCDrtn;
Ctx = Tb20.CtxDrtn;
RS = Tb20.RS;

% nan rejection and conditioning
idx = ~isnan(r_0_20);
r = r_0_20(idx);
HPC = HPC(idx);
Ctx = Ctx(idx);
RS = RS(idx);

LTR = LTR(idx);

% getting a regression line
coeffrHPC = polyfit(r, HPC, 1);
coeffrCtx = polyfit(r, Ctx, 1);
coeffrRS = polyfit(r, RS, 1);

% correlation test
% r vs MI
CorStatTest(1).Label = 'r vs HPC';
R = corrcoef(r,HPC);
CorStatTest(1).coefR = R;
[rho, pval] = corr(r,HPC, 'Type', 'Pearson');
CorStatTest(1).PearsonRho = rho;
CorStatTest(1).PearsonP = pval;
[rho, pval] = corr(r, HPC, 'Type', 'Spearman');
CorStatTest(1).SpearmanRho = rho;
CorStatTest(1).SpearmanP = pval;

CorStatTest(2).Label = 'r vs Ctx';
R = corrcoef(r,Ctx);
CorStatTest(2).coefR = R;
[rho, pval] = corr(r,Ctx, 'Type', 'Pearson');
CorStatTest(2).PearsonRho = rho;
CorStatTest(2).PearsonP = pval;
[rho, pval] = corr(r, Ctx, 'Type', 'Spearman');
CorStatTest(2).SpearmanRho = rho;
CorStatTest(2).SpearmanP = pval;

CorStatTest(3).Label = 'r vs RS';
R = corrcoef(r,RS);
CorStatTest(3).coefR = R;
[rho, pval] = corr(r,RS, 'Type', 'Pearson');
CorStatTest(3).PearsonRho = rho;
CorStatTest(3).PearsonP = pval;
[rho, pval] = corr(r, RS, 'Type', 'Spearman');
CorStatTest(3).SpearmanRho = rho;
CorStatTest(3).SpearmanP = pval;

%% figure preparation

xyData(:,:,1) = [r HPC];
xyData(:,:,2) = [r Ctx];
xyData(:,:,3) = [r RS];

coef = [coeffrHPC;coeffrCtx;coeffrRS];
CTitle = {'Phase-locking vs HPC seizure', 'Phase-locking vs Ctx seizure', 'Phase-locking vs Motor seizure'};
CVLabel = {'Seizure duration (s)', 'Seizure duration (s)', 'Racine''s scale'};
CHLabel = {'Phase-locking strength (r)', 'Phase-locking strength (r)', 'Phase-locking strength (r)'};

close all
hfig = figure(1);

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 17.5 5],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17.5 5]... % width, height
    );

% global parameters
fontname = 'Arial';
fontsize = 5;

for i = 1:3
    hax = subplot(1,3,i);
    [ hs ] = figf_ScatGroupedRefline1( hax, xyData(:,1,i), xyData(:,2,i), LTR,coef(i,:), CorStatTest(i).coefR);

    set(hs.scttr,...
        'MarkerEdgeColor', [0 0 0],...
        'Sizedata', 10);

    set(hs.rl,...
        'Color', [0 1 0],...
        'LineWidth', 1);

    set(hs.txt,...
        'fontsize', fontsize,...
        'verticalalignment', 'top',...
        'horizontalalignment', 'left');

    set(hs.xlbl, 'String', CHLabel{i});
    set(hs.ylbl, 'String', CVLabel{i});
    set(hs.ttl, 'String', CTitle{i});

    set(hs.ax,...
        'FontName', fontname,...
        'FontSize', fontsize);

    if i == 3
        set(hs.ax, 'YTick', 0:5)
    end
end


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
