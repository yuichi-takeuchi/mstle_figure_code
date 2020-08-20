function [sBasicStats, sStatsTest, No] = figure2i()
% Copyright(c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 2;
panel = 'i';
inputFileName = ['Figure' num2str(figureNo) '_Fg641_OpenLoopStim.csv'];
outputFileName = ['figure' num2str(figureNo) panel '.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
dataVarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}
OnOffVarName = orgTb.Properties.VariableNames{10};
linearVarName = orgTb.Properties.VariableNames{12};
condVec = unique(orgTb.MSEStmHz);

%% Data import 2
subTbTh = readtable(['tmp/Figure' num2str(figureNo) '_subTbTh.csv']);
ThrshldVarName = subTbTh.Properties.VariableNames{23};

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_get3ANOVAStatsStructs1( subTbTh, dataVarNames, OnOffVarName, linearVarName, ThrshldVarName);
close all

%% Figure preparation
close all
hfig = figure(1);

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 11 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [12 5]... % width, height
    );

% global parameters
fontname = 'Arial';
fontsize = 5;

% left axis (ctx seizures)
meanCtx = sBasicStats(2).Mean;
stdCtx = sBasicStats(2).Std;
yyaxis left
hax1 = gca;
hold(hax1, 'on')
for i = 1:size(meanCtx,1)
    herrbr1(i) = errorbar(condVec, meanCtx(i,:), stdCtx(i,:), 'o');
end
hold(hax1, 'off')

% setting parametors of bars and plots
set(herrbr1, 'LineWidth', 0.75, 'MarkerSize', 4, 'YNegativeDelta',[]);
set(herrbr1(1), 'LineStyle', '-', 'Color', [0 0 0],'DisplayName', 'Ctx, Off');
set(herrbr1(2), 'LineStyle', '--', 'Color', [0 0 0], 'DisplayName', 'Ctx, On, non-induction');
set(herrbr1(3), 'LineStyle', '--', 'Color', [1 0 0], 'DisplayName', 'Ctx, On, induction');

hlgnd1 = legend([herrbr1(1), herrbr1(2), herrbr1(3)],...
    'Box', 'Off', 'Location', 'northeastoutside');

hylbl1 = ylabel('Ctx seizure duration (s)');
hxlbl = xlabel('MS stimulation frequency (Hz)');

% axis parameter settings
yl = get(hax1, 'YLim');   
set(hax1,...
    'XLim', [min(condVec)-3, max(condVec)+3],...
    'XTick', condVec',...
    'YLim', [-5, yl(2)],...
    'YColor', [0 0 0],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% right axis (Racine's sca;e)
meanRS = sBasicStats(3).Mean;
stdRS = sBasicStats(3).Std;
yyaxis right
hax2 = gca();
hold(hax2, 'on')
for i = 1:size(meanRS,1)
    herrbr2(i) = errorbar(condVec, meanRS(i,:), stdRS(i,:), 'd');
end
hold(hax2, 'off')

% setting parametors of bars and plots
set(herrbr2, 'LineWidth', 0.75, 'MarkerSize', 4, 'YNegativeDelta',[]);
set(herrbr2(1), 'LineStyle', '-', 'Color', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'RS, Off'); 
set(herrbr2(2), 'LineStyle', '--', 'Color', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'RS, On, non-induction');
set(herrbr2(3), 'LineStyle', '--', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'DisplayName', 'RS, On, induction');

hylbl2 = ylabel('Racine''s scale');

yl = get(hax2, 'YLim');
set(hax2,...
    'YLim', [0, yl(2)],...
    'YColor', [0 0 0],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% outputs
print(['../results/figure' num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(subTb.LTR));
No.Trials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'No', '-v7.3')
disp('done')

end
