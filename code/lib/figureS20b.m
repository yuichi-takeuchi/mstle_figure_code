function [sBasicStats, sStatsTest, No] = figureS20b()
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 20;
panel = 'b';
inputFileNameOpen = 'Figure2_Fg641_OpenLoopStim.csv';
inputFileNameClosed = 'Figure3_Fg641_ClosedLoopStim.csv';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% Data import
srcTbOpen = readtable(['../data/' inputFileNameOpen]);
srcTbClosed = readtable(['../data/' inputFileNameClosed]);
sTb(1).type = 'sub';
sTb(1).tb = srcTbOpen(~logical(srcTbOpen.Supra),:);
sTb(2).type = 'supra';
sTb(2).tb = srcTbOpen(logical(srcTbOpen.Supra),:);
sTb(3).type = 'closed';
sTb(3).tb = srcTbClosed(logical(srcTbClosed.Supra),:);
VarNames = srcTbOpen.Properties.VariableNames(15); % {RS}

%% Basic statistics and Statistical tests
for i = 1:3
    Tb = sTb(i).tb;
    [ sBasicStats{i}, sStatsTest{i} ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );
end

%% Histogram figure preparation
% paramas
fontname = 'Arial';
fontsize = 5;
colorMap = [[1 0 0]; [0 0 0]; [0 0 1]];
clgnd = {'Off', 'On'};

hfig = figure(1);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 17.5 10],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [18.5 11]... % width, height
    );

for i = 1:3
    Tb = sTb(i).tb;
    Off = Tb.RS(Tb.MSEstm == false);
    On  = Tb.RS(Tb.MSEstm == true);
    
    % histgram by bar plot
    edges = -0.5:1:5.5;
    h1 = histcounts(Off, edges, 'Normalization', 'probability');
    h2 = histcounts(On, edges, 'Normalization', 'probability');

    hax = subplot(2, 3, i);
    [ hs ] = figf_BarPlot2(hax, (edges(1:end-1) + edges(2:end))/2, [h1;h2]');
    
    set(hs.bar, 'BarWidth', 1)
    hs.bar(1).FaceColor = [1 1 1];
    hs.bar(2).FaceColor = colorMap(i,:);
        
    hs.xlbl.String = 'Racine''s scale';
    hs.ylbl.String = 'Probability';
    hs.ttl.String = 'Motor seizure';
    hs.lgnd = legend(clgnd);
    
    set(hs.ax,...
        'XLim', [-0.5 5.5],...
        'XTick', 0:5,...
        'FontName', fontname,...
        'FontSize', fontsize...
        );
    
    set(hs.lgnd,...
        'Location', 'north',...
        'FontName', fontname,...
        'FontSize', fontsize,...
        'Box', 'off');
    
    % cumurative curve
    hax = subplot(2, 3, 3+i);

    edges = -0.5:1:5.5;
    N1 = histcounts( Off, edges, 'Normalization', 'probability');
    N2 = histcounts( On, edges, 'Normalization', 'probability');
    Cumsum = [cumsum(N1); cumsum(N2)]';

    [ hs ] = figf_PlotWLegend3(hax, (edges(1:end-1) + edges(2:end))/2, Cumsum, clgnd);

    % setting parametors of bars and plots
    set(hs.plt, 'LineWidth', 0.5);
    set(hs.plt(1), 'Color', [0 0 0]);
    set(hs.plt(2), 'Color', colorMap(i,:));

    hs.ylbl.String = 'Cumulative probability';
    hs.xlbl.String = 'Racine''s scale';
    hs.ttl.String = 'Motor seizure';

    % axis parameter settings
    set(hs.ax,...
        'XLim', [-0.5 5.5],...
        'XTick', 0:5,...
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
print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
for i = 1:3
    Tb = sTb(i).tb;
    No(i).Rats = numel(unique(Tb.LTR));
    No(i).Trials = height(Tb);
end

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'No')
disp('done')

end
