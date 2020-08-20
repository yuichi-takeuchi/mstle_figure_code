function [sBasicStats, sStatsTest, sBasicStats_pa, sStatsTest_pa, No] = figureS10g()
% Copyright(c) 2018–2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 10;
panel = 'g';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg624_OpenLoopStim.csv'];
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% Data import 
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.Laser );

%% animal basis stats (independent)
for i = 1:length(VarNames)
    [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(supraTb.(VarNames{i}), supraTb.LTR, supraTb.Laser);
    [sBasicStats_pa(i)] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
    [sStatsTest_pa(i)] = statsf_2sampleTestsStatsStruct_cndtn( supraTb.(VarNames{i}), supraTb.Laser);
end

%% Figure preparation (clustered)
% Common labelings
CTitle = {'HPC electrographic seizure', 'Ctx electrographic seizure', 'Motor seizure'};
CVLabel = {'Duration (s)', 'Duration (s)', 'Racine''s scale'};

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
    [ hs ] = figf_BarMeanIndpndPlot1( supraTb.LTR, supraTb.(VarNames{i}), supraTb.Laser + 1, 0.4, hax );
 
    % setting parametors of bars and plots
    set(hs.bar,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth', 0.5, 'BarWidth', 0.5);
    
    for j = 1:size(hs.cplt, 2)
        set(hs.cplt{j}, 'LineWidth', 0.5, 'MarkerSize', 4); % 'Color', [0 0 0]
    end
    
    set(hs.xlbl, 'String', 'Laser');
    set(hs.ylbl, 'String', CVLabel{i});
    set(hs.ttl, 'String', CTitle{i});
    
    % patch
    hax = gca;
    yl = get(hax, 'YLim');
    hptch = patch([1.6 2.4 2.4 1.6],[yl(1) yl(1) yl(2) yl(2)],'b');
    set(hptch,'FaceAlpha',0.2,'edgecolor','none');
    
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
print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');

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
