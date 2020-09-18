function [sBasicStats, sStatsTest, No] = figureS8(ratId, colorId)
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 8;
panel = num2str(ratId);
inputFileName = 'Figure2_Fg641_OpenLoopStim.csv';
outputFileName = ['figure' supplement num2str(figureNo) '_' panel '.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
Tb = orgTb(orgTb.LTR == ratId & orgTb.Supra == 0,:); % 
VarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );

%% Figure preparation
% id of animals

% global parameters
fontname = 'Arial';
fontsize = 4;

close all
hfig = figure(1);

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 17.5 2.5],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17.5 2.5]... % width, height
    );

% building plots
CXLabel = {'Duration (s)', 'Duration (s)', 'Racine''s score'};
CTitle = {'HPC seizure', 'Ctx seizure', 'Motor seizure'};
CEdgesHist = {0:20:120, 0:10:70, -0.5:1:5.5};
clgnd = {'Off', 'On'};
MatXLim = [-7.5 127.5; -5 75; -0.5 5.5];
CXTick = {0:20:120, 0:10:70, 0:5};
CEdgesCum = {0:120, 0:70, -0.5:1:5.5};

for i = 1:3
    Off = Tb.(VarNames{i})(Tb.MSEstm == false);
    On  = Tb.(VarNames{i})(Tb.MSEstm == true);

    % histgram by bar plot
    edges = CEdgesHist{i};
    h1 = histcounts(Off, edges, 'Normalization', 'probability');
    h2 = histcounts(On, edges, 'Normalization', 'probability');

    hax = subplot(1, 6, 2*i-1);
    [ hs ] = figf_BarPlot2(hax, (edges(1:end-1) + edges(2:end))/2, [h1;h2]');

    set(hs.bar, 'BarWidth', 1)
    hs.bar(1).FaceColor = [1 1 1];
    hs.bar(2).FaceColor = defaultColor(colorId);

    hs.xlbl.String = CXLabel{i};
    hs.ylbl.String = 'Probability';
    hs.ttl.String = CTitle{i};
    hs.lgnd = legend(clgnd);

    set(hs.ax,...
        'XLim', MatXLim(i,:),...
        'XTick', CXTick{i},...
        'FontName', fontname,...
        'FontSize', fontsize...
        );

    set(hs.lgnd,...
        'Location', 'northeast',...
        'FontName', fontname,...
        'FontSize', fontsize-1,...
        'Box', 'off');

    % cumurative curve
    hax = subplot(1, 6, 2*i);

    edges = CEdgesCum{i};
    N1 = histcounts( Off, edges, 'Normalization', 'probability');
    N2 = histcounts( On, edges, 'Normalization', 'probability');
    Cumsum = [cumsum(N1); cumsum(N2)]';

    edgesX = edges(1:end-1);
    [ hs ] = figf_PlotWLegend3(hax, (edges(1:end-1) + edges(2:end))/2, Cumsum, clgnd);

    % setting parametors of bars and plots
    set(hs.plt, 'LineWidth', 0.5);
    set(hs.plt(1), 'Color', [0 0 0]);
    set(hs.plt(2), 'Color', defaultColor(colorId));

    hs.ylbl.String = 'Cumulative probability';
    hs.xlbl.String = CXLabel{i};
    hs.ttl.String = CTitle{i};

    % axis parameter settings
    set(hs.ax,...
        'XLim', MatXLim(i,:),...
        'XTick', CXTick{i},...
        'YLim', [0 1],...
        'FontName', fontname,...
        'FontSize', fontsize...
        );

    set(hs.lgnd,...
        'Location', 'southeast',...
        'FontName', fontname,...
        'FontSize', fontsize,...
        'Box', 'off');
end

% outputs
print(['../results/figure' supplement num2str(figureNo) '_rat' panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) '_rat' panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Trials = height(Tb);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats', 'sStatsTest',...
    'No')
disp('done')

end 
