function [sBasicStats, sStatsTest, sBasicStats_pa, sStatsTest_pa, No] = figure3g()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
figureNo = 3;
panel = 'g';
inputFileName = ['Figure' num2str(figureNo) '_Fg641_ClosedLoopStim.csv'];
outputFileName = ['figure' num2str(figureNo) panel '.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Data import 2
supraTbTh = readtable(['tmp/Figure' num2str(figureNo) '_supraTbTh.csv']);

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.MSEstm );

%% animal basis stats (independent)
for i = 1:length(VarNames)
    [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(supraTb.(VarNames{i}), supraTb.LTR, supraTb.MSEstm);
    [sBasicStats_pa(i)] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
    [sStatsTest_pa(i)] = statsf_paired2sampleTestsStatsStruct_cndtn( MeanPerAnimal, intrvntnVec );
end

%% Figure preparation (clustered)
% Common labelings
CTitle = {'HPC electrographic seizure', 'Ctx electrographic seizure', 'Motor seizure'};
CVLabel = {'Duration (s)', 'Duration (s)', 'Racine''s score'};

close all
hfig = figure(1);
for i = 1:length(VarNames)
        
    % figure parameter settings
    set(hfig,...
        'PaperUnits', 'centimeters',...
        'PaperPosition', [0 0 10.5 4],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [10.5 4]... % width, height
        );
    
    % global parameters
    fontname = 'Arial';
    fontsize = 5;
    
    % axis
    hax = subplot(1, 3, i);
    
    % building a plot
    [ hs ] = figf_BarMeanIndpndPlot2( supraTb.LTR, supraTb.(VarNames{i}), supraTb.MSEstm + 1, supraTbTh.Thresholded + 1, 0.4, hax );
 
    % setting parametors of bars and plots
    set(hs.bar, 'BarWidth', 0.6);
    set(hs.bar(1), 'FaceColor',[1 1 1]);
    set(hs.bar(2), 'FaceColor',[0.5 0.5 0.5]);
    
    for j = 1:size(hs.cplt, 2)
        set(hs.cplt{1,j}, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', [0.2 0.2 0.2]);
        set(hs.cplt{2,j}, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', [0 0 1]);
    end
    
    set(hs.xlbl, 'String', 'Estim');
    set(hs.ylbl, 'String', CVLabel{i});
    set(hs.ttl, 'String', CTitle{i});
    
    % patch
    hax = gca;
    yl = get(hax, 'YLim');
    
    % axis parameter settings
    set(hs.ax,...
        'YLim', yl,...
        'XLim', [0.5 2.5],...
        'XTick', [1 2],...
        'XTickLabel', {'Off', 'On'},...
        'FontName', fontname,...
        'FontSize', fontsize...
        );
end

% outputs
print(['../results/figure' num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(supraTb.LTR));
No.Trials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats',...
    'sStatsTest',...
    'sBasicStats_pa',...
    'sStatsTest_pa',...
    'No',...
    '-v7.3')
disp('done')

end
