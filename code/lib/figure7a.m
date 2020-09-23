function [sBasicStats, sStatsTest, No] = figure7a()
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 7;
panel = 'a';
inputFileNameOpen = 'Figure2_Fg641_OpenLoopStim.csv';
inputFileNameClosed = 'Figure3_Fg641_ClosedLoopStim.csv';
outputFileName = ['figure' num2str(figureNo) '.mat'];

%% Data import
srcTbOpen = readtable(['../data/' inputFileNameOpen]);
srcTbClosed = readtable(['../data/' inputFileNameClosed]);
sTb(1).type = 'sub';
sTb(1).tb = srcTbOpen(~logical(srcTbOpen.Supra),:);
sTb(2).type = 'supra';
sTb(2).tb = srcTbOpen(logical(srcTbOpen.Supra),:);
sTb(3).type = 'closed';
sTb(3).tb = srcTbClosed(logical(srcTbClosed.Supra),:);
VarNames = srcTbOpen.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Basic statistics and Statistical tests
for i = 1:3
    Tb = sTb(i).tb;
    [ sBasicStats{i}, sStatsTest{i} ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );
end

%% Histogram figure preparation
% paramas
fontname = 'Arial';
fontsize = 5;
colorMapCumsum = [[1 0 0]; [0.5 0.5 0.5]; [0 0 1]];
clgnd = {'Off', 'On'};
CXLabel = {'Duration (s)', 'Duration (s)', 'Racine''s score'};
CTitle = {'HPC seizure', 'Ctx seizure', 'Motor seizure'};
MatXLim = [-7.5 127.5; -5 75; -0.5 5.5];
CXTick = {0:20:120, 0:10:70, 0:5};
CEdgesCum = {0:120, 0:70, -0.5:1:5.5};

hfig = figure(1);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 17.5 15],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17.5 15]... % width, height
    );

for i = 1:3
    Tb = sTb(i).tb;
    for j = 1:3
        Off = Tb.(VarNames{j})(Tb.MSEstm == false);
        On  = Tb.(VarNames{j})(Tb.MSEstm == true);

        % cumurative curve
        hax = subplot(3, 3, 3*(j-1)+i);

        edges = CEdgesCum{j};
        N1 = histcounts( Off, edges, 'Normalization', 'probability');
        N2 = histcounts( On, edges, 'Normalization', 'probability');
        Cumsum = [cumsum(N1); cumsum(N2)]';

        [ hs ] = figf_PlotWLegend3(hax, (edges(1:end-1) + edges(2:end))/2, Cumsum, clgnd);

        % setting parametors of bars and plots
        set(hs.plt, 'LineWidth', 0.5);
        set(hs.plt(1), 'Color', [0 0 0]);
        set(hs.plt(2), 'Color', colorMapCumsum(i,:));

        hs.ylbl.String = 'Cumulative probability';
        hs.xlbl.String = CXLabel{j};
        hs.ttl.String = CTitle{j};

        % axis parameter settings
        set(hs.ax,...
            'XLim', MatXLim(j,:),...
            'XTick', CXTick{j},...
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
end

% outputs
print(['../results/figure' num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel '.png'], '-dpng');

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
