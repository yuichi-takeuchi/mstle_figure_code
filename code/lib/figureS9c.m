function [sBasicStats, sStatsTest, sBasicStats_ind, sStatsTest_ind, No] = figureS9c()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 9;
panel = 'c';
inputFileName1 = 'Figure3_0_20.csv';
inputFileName2 = ['Figure' supplement num2str(figureNo) '_rTbTh.csv'];
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% Data imports
Tb20 = readtable(['../data/' inputFileName1]);
rTbTh = readtable(['tmp/' inputFileName2]);
VarNames = Tb20.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

% %% Basic statistics and Statistical tests
% [ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( Tb20, VarNames, Tb20.MSEstm );
% 
% %% animal basis stats (independent)
% for i = 1:length(VarNames)
%     [MeanPerAnimal, ~, intrvntnVec] = statsf_meanPer1With2(Tb20.(VarNames{i}), Tb20.LTR, Tb20.MSEstm);
%     [sBasicStats_pa(i)] = stats_sBasicStats_anova1( MeanPerAnimal, intrvntnVec );
%     [sStatsTest_pa(i)] = statsf_2sampleTestsStatsStruct_cndtn( Tb20.(VarNames{i}), Tb20.MSEstm);
% end

%% get basic stats and tests on vector length per trial
cndthnVec = rTbTh.MSEstm + 1;
cndthnVec(rTbTh.MSEstm == 1 & rTbTh.rThrshlded == 1) = 3;
for i = 1:length(VarNames)
    data = rTbTh.(VarNames{i});
    data1 = data(rTbTh.MSEstm == 1 & rTbTh.rThrshlded == 0);
    data2 = data(rTbTh.MSEstm == 1 & rTbTh.rThrshlded == 1);
    [sBasicStats(i)] = stats_sBasicStats_anova1( data, cndthnVec );
    [sStatsTest(i)] = stats_ANOVA1StatsStructs1( data, cndthnVec , 'bonferroni');
    [ sBasicStats_ind(i), sStatsTest_ind(i) ] = statsf_getBasicStatsAndTestStructs2( data1, data2 );
end

%% Figure preparation (clustered)
% Common labelings
CTitle = {'HPC electrographic seizure', 'Ctx electrographic seizure', 'Motor seizure'};
CVLabel = {'Seizure duration (s)', 'Seizure duration (s)', 'Racine''s scale'};

delay = nan;
% delay = [nan 0 20 40 60];

for k = 1:length(delay)
    rTbTh = readtable(['tmp/' inputFileName2]);
    if ~isnan(delay(k))
        rTbTh = rTbTh(rTbTh.stmDly == delay(k), :);
    end
    cndthnVec1 = rTbTh.MSEstm + 1;
    cndthnVec1(rTbTh.MSEstm == 1 & rTbTh.rThrshlded == 1) = 3;

    close all
    hfig = figure(1);
    for i = 1:length(VarNames)

        % figure parameter settings
        set(hfig,...
            'PaperUnits', 'centimeters',...
            'PaperPosition', [0 0 17.5 5],... % [h distance, v distance, width, height], origin: left lower corner
            'PaperSize', [17.5 5]... % width, height
            );

        % global parameters
        fontname = 'Arial';
        fontsize = 5;

        % axis
        hax = subplot(1, 3, i);

        % building a plot
        [ hs ] = figf_BarMeanIndpndPlot3( rTbTh.LTR, rTbTh.(VarNames{i}), cndthnVec1, rTbTh.rThrshlded + 1, 0.4, hax );

        % setting parametors of bars and plots
        set(hs.bar, 'BarWidth', 0.6);
        set(hs.bar(1), 'FaceColor',[1 1 1]);
        set(hs.bar(2), 'FaceColor',[0.5 0.5 0.5]);
        set(hs.bar(3), 'FaceColor',[0 0 0]);

        for j = 1:size(hs.cplt, 2)
            set(hs.cplt{1,j}, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', [0.2 0.2 0.2]);
            set(hs.cplt{2,j}, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', [0 1 0]);
        end

        set(hs.xlbl, 'String', 'Estim and Phase-locking strength');
        set(hs.ylbl, 'String', CVLabel{i});
        set(hs.ttl, 'String', CTitle{i});

        % patch
        hax = gca;
        yl = get(hax, 'YLim');

        % axis parameter settings
        set(hs.ax,...
            'YLim', yl,...
            'XLim', [0.5 3.5],...
            'XTick', [1 2 3],...
            'XTickLabel', {'Off', 'On-Low r', 'On-High r'},...
            'FontName', fontname,...
            'FontSize', fontsize...
            );
        if i == 3
            set(hs.ax, 'YTick', 0:5)
        end
    end
    
    % outputs
    if isnan(delay(k))
        print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
        print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');    
    else
        print(['../results/figure' supplement num2str(figureNo) panel '_' num2str(delay(k)) 'msDelay_.pdf'], '-dpdf');
        print(['../results/figure' supplement num2str(figureNo) panel '_' num2str(delay(k)) 'msDelay_.png'], '-dpng');    
    end
    
    close all

end

rTbTh = readtable(['tmp/' inputFileName2]);

%% Number of rats and trials
No.Rats = length(unique(rTbTh.LTR));
No.Trials = length(rTbTh.LTR);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats',...
    'sStatsTest',...
    'sBasicStats_ind',...
    'sStatsTest_ind',...
    'No')

disp('done')

end
