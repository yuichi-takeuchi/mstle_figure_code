function [sBasicStats, sStatsTest, CorStatTest, No] = figure6a()
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 6;
panel = 'a';
inputFileName = 'Figure2_Fg641_OpenLoopStim.csv';
outputFileName = ['figure' num2str(figureNo) panel '.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
Tb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );

%% Calculation of parameters (MI, dCtx, dRS)
% sub    
% getting parameters
HPCOff = Tb.HPCDrtn(Tb.MSEstm == false);
HPCOn  = Tb.HPCDrtn(Tb.MSEstm == true);
MI = (HPCOn-HPCOff)./(HPCOn+HPCOff);

CtxOff = Tb.CtxDrtn(Tb.MSEstm == false);
CtxOn  = Tb.CtxDrtn(Tb.MSEstm == true);
dCtx = CtxOn-CtxOff;

RSOff = Tb.RS(Tb.MSEstm == false);
RSOn  = Tb.RS(Tb.MSEstm == true);
dRS = RSOn-RSOff;

LTR = Tb.LTR(1:2:end);

% nan rejection
idx = ~isnan(MI);
MI = MI(idx);
dCtx = dCtx(idx);
dRS = dRS(idx);
LTR = LTR(idx);

% getting a regression line
coeffMIdCtx = polyfit(MI, dCtx, 1);
coeffMIdRS = polyfit(MI, dRS, 1);
coeffdCtxdRS = polyfit(dCtx, dRS, 1);


% Correlation test
% HPC vs dCtx
CorStatTest(1).Label = 'HPC vs dCtx';
R = corrcoef(MI, dCtx);
CorStatTest(1).coefR = R;
[rho, pval] = corr(MI, dCtx, 'Type', 'Pearson');
CorStatTest(1).PearsonRho = rho;
CorStatTest(1).PearsonP = pval;
[rho, pval] = corr(MI, dCtx, 'Type', 'Spearman');
CorStatTest(1).SpearmanRho = rho;
CorStatTest(1).SpearmanP = pval;
% HPC vs dRS
CorStatTest(2).Label = 'HPC vs dRS';
R = corrcoef(MI, dRS);
CorStatTest(2).coefR = R;
[rho, pval] = corr(MI, dRS, 'Type', 'Pearson');
CorStatTest(2).PearsonRho = rho;
CorStatTest(2).PearsonP = pval;
[rho, pval] = corr(MI, dRS, 'Type', 'Spearman');
CorStatTest(2).SpearmanRho = rho;
CorStatTest(2).SpearmanP = pval;
% dCtx vs dRS
CorStatTest(3).Label = 'dCtx vs dRS';
R = corrcoef(dCtx, dRS);
CorStatTest(3).coefR = R;
[rho, pval] = corr(dCtx, dRS, 'Type', 'Pearson');
CorStatTest(3).PearsonRho = rho;
CorStatTest(3).PearsonP = pval;
[rho, pval] = corr(dCtx, dRS, 'Type', 'Spearman');
CorStatTest(3).SpearmanRho = rho;
CorStatTest(3).SpearmanP = pval;

%% Figure prepration
% parameters
xyData(:,:,1) = [MI dCtx];
xyData(:,:,2) = [MI dRS];
xyData(:,:,3) = [dCtx dRS];

coef = [coeffMIdCtx;coeffMIdRS;coeffdCtxdRS];
CHLabel = {'Modulation index of HPC seizures', 'Modulation index of HPC seizures', '\DeltaCtx seizure duration (s)'};
CVLabel = {'\DeltaCtx seizure duration (s)', '\DeltaRacine''s scale', '\DeltaRacine''s scale'};
CTitle = {'HPC seizure vs Ctx seizure', 'HPC seizure vs Motor seizure', 'Ctx seizure vs Motor seizure'};

close all
hfig = figure(1);

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 17.5 5],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [18.5 6]... % width, height
    );

% global parameters
fontname = 'Arial';
fontsize = 5;

for i = 1:3
       
    hax = subplot(1,3,i);
    
    % building a plot
    [ hs ] = figf_ScatGroupedRefline1( hax, xyData(:,1,i), xyData(:,2,i), LTR, coef(i,:), CorStatTest(i).coefR);
    
    set(hs.scttr,...
        'MarkerEdgeColor', [0 0 0],...
        'Sizedata', 10);
    
    set(hs.rl,...
        'Color', [1 0 0],...
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
end

% outputs
outputFileNameBase = ['figure' num2str(figureNo) panel ];
print(['../results/' outputFileNameBase '.pdf'], '-dpdf');
print(['../results/' outputFileNameBase '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(Tb.LTR));
No.Trials = length(Tb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'CorStatTest', 'No', '-v7.3')
disp('done')

end
