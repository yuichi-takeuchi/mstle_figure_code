function [sBasicStats, sStatsTest, sBasicStats_pa, sStatsTest_pa, No] = figure2g()
% Copyright(c) 2018–2020 Yuichi Takeuchi

%% params
figureNo = 2;
panel = 'g';
inputFileName = ['Figure' num2str(figureNo) '_Fg641_OpenLoopStim.csv'];
outputFileName = ['figure' num2str(figureNo) panel '.mat'];

%% Data import 1
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Data import 2
subTbTh = readtable(['tmp/Figure' num2str(figureNo) '_subTbTh.csv']);

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.MSEstm );

%% animal basis stats (independent)
for i = 1:length(VarNames)
    [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(subTb.(VarNames{i}), subTb.LTR, subTb.MSEstm);
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
        'PaperPosition', [0.5 0.5 14 4],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [15 5]... % width, height
        );
    
    % global parameters
    fontname = 'Arial';
    fontsize = 5;
    
    % axis
    hax = subplot(1, 3, i);
    
    % building a plot
    [ hs ] = figf_BarMeanIndpndPlot2( subTb.LTR, subTb.(VarNames{i}), subTb.MSEstm + 1, subTbTh.Thresholded + 1, 0.4, hax );
 
    % setting parametors of bars and plots
    set(hs.bar,'EdgeColor',[0 0 0],'LineWidth', 0.5, 'BarWidth', 0.6);
    set(hs.bar(1), 'FaceColor',[1 1 1]);
    set(hs.bar(2), 'FaceColor',[0.5 0.5 0.5]);
    
    for j = 1:size(hs.cplt, 2)
        set(hs.cplt{1,j}, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', [0.2 0.2 0.2]);
        set(hs.cplt{2,j}, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', [1 0 0]);
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
No.Rats = length(unique(subTb.LTR));
No.Trials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats',...
    'sStatsTest',...
    'sBasicStats_pa',...
    'sStatsTest_pa',...
    'No')

disp('done')

end
