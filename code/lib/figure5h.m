function [sBasicStats, sStatsTest, sBasicStats_pa, sStatsTest_pa, No] = figure5h()
% Kindling threshold intensities for after-discharges and secondary
% generalization with optogenetic interventions
% Copyright (c) 2018, 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 5;
fgNo = 602;
panel = 'H';
inputFileName = ['Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_ThresIntensity.csv'];
outputFileName = ['Figure' num2str(figureNo) panel '_ThresIntensity.mat'];

%% Data import
srcTb = readtable(['../data/' inputFileName]); % original csv data
VarNames = srcTb.Properties.VariableNames(10:11); % {ADThrs, sGSThrs}
dataTb = srcTb(srcTb.illmDrtn == 60,:);

%% Basic statistics and Statistical tests
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( dataTb, VarNames, dataTb.Laser); % orgTb.(6) = Laser or MSEStm

%% animal basis stats (independent)
for i = 1:length(VarNames)
    [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(dataTb.(VarNames{i}), dataTb.LTR, dataTb.Laser);
    [sBasicStats_pa(i)] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
    [sStatsTest_pa(i)] = statsf_2sampleTestsStatsStruct_cndtn( dataTb.(VarNames{i}), dataTb.Laser);
end

%% Figure preparation
% params
cndtnVec = dataTb.Laser + 1;

close all
hfig = figure(1);

% parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 9 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [10 5] ... % width, height
    );

% global parameters
fontname = 'Arial';
fontsize = 5;

% left part (after discharge)
hax = subplot(1, 2, 1);
[ hs, hsplt ] = figf_BarMeanIndpndPlot1( dataTb.LTR, dataTb.ADThrs, cndtnVec, hax );

set(hs.bar,'EdgeColor',[0 0 0],'LineWidth', 0.5);
set(hs.bar, 'FaceColor',[1 1 1]);
% for i = 1:length(hsplt)
%     set(hsplt(i), 'LineWidth', 0.5, 'MarkerSize', 4);
% end   
set(hs.xlbl, 'String', 'Estim');
set(hs.ylbl, 'String', 'Intensity (uA)');
set(hs.ttl, 'String', 'Threshold for HPC');

set(hs.ax,...
    'XLim', [0.5 2.5],...
    'XTick', [1 2],...
    'XTickLabel', {'Off', 'On'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

hax = gca;
yl = get(hax, 'YLim');
hptch = patch([1.6 2.4 2.4 1.6],[yl(1) yl(1) yl(2) yl(2)],'b');
set(hptch,'FaceAlpha',0.2,'edgecolor','none');

% % right panel

hax = subplot(1, 2, 2);
[ hs, hsplt ] = figf_BarMeanIndpndPlot1( dataTb.LTR, dataTb.sGSThrs, cndtnVec, hax );

set(hs.bar,'EdgeColor',[0 0 0],'LineWidth', 0.5);
set(hs.bar, 'FaceColor',[1 1 1]);
% for i = 1:length(hsplt)
%     set(hsplt(i), 'LineWidth', 0.5, 'MarkerSize');
% end   
set(hs.xlbl, 'String', 'Estim');
set(hs.ylbl, 'String', 'Intensity (uA)');
set(hs.ttl, 'String', 'Threshold for Ctx');

set(hs.ax,...
    'XLim', [0.5 2.5],...
    'XTick', [1 2],...
    'XTickLabel', {'Off', 'On'},...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

hax = gca;
yl = get(hax, 'YLim');
hptch = patch([1.6 2.4 2.4 1.6],[yl(1) yl(1) yl(2) yl(2)],'b');
set(hptch,'FaceAlpha',0.2,'edgecolor','none');

% outputs
print('../results/figure5h.pdf', '-dpdf');
print('../results/figure5h.png', '-dpng');

% close all

%%

% % Labelings 
% CTitle = {'Threshold for HPC', 'Threshold for Ctx'};
% CVLabel = {'Intensity (uA)', 'Intensity (uA)'};
% outputGraph = [1 1]; % pdf, png
% 
% % 5 s conditioning
% outputFileNameBase = ['Figure' num2str(figureNo) panel '_ThrsInt05_'];
% [ flag ] = figsf_BarScatPairedOpt1( orgTb05, VarNames, Stats(1).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase);
% for i = 1:length(VarNames)
%     movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
%     movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
% end
% close all
% 
% % 60 s conditioning
% outputFileNameBase = ['Figure' num2str(figureNo) panel '_ThrsInt60_'];
% [ flag ] = figsf_BarScatPairedOpt1( orgTb60, VarNames, Stats(2).Basic, CTitle, CVLabel, outputGraph, outputFileNameBase);
% for i = 1:length(VarNames)
%     movefile([outputFileNameBase VarNames{i} '.pdf'], ['../results/' outputFileNameBase VarNames{i} '.pdf'])
%     movefile([outputFileNameBase VarNames{i} '.png'], ['../results/' outputFileNameBase VarNames{i} '.png'])
% end
% close all

%% Number of rats and trials
% No.subRats = length(unique(dataTb.LTR));
% No.subTrials = length(dataTb.LTR);
% 
% %% Save
% save(['../results/' outputFileName],...
%     'sBasicStats',...
%     'sStatsTest',...
%     'sBasicStats_pa',...
%     'sStatsTest_pa',...
%     'No',...
%     '-v7.3')
% disp('done')

end
