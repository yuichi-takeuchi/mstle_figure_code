function [sBasicStats, sStatsTest, No] = figureS20(ratId, colorId)
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 20;
panel = num2str(ratId);
inputFileName = 'Figure3_0_20.csv';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% Data import
Tb20 = readtable(['../data/' inputFileName]);
Tb = Tb20(Tb20.LTR == ratId,:); % 
VarNames = Tb20.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}
% VarNames = [{'r'} Varnames];
r_0_20 = Tb.r;

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );

%% Figure preparation
% id of animals

close all
hfig = figure(1);

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 17.5 3],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [18.5 4]... % width, height
    );

% global parameters
fontname = 'Arial';
fontsize = 5;

% building a plot

hax = subplot(1,4,1); % subplot

hst = histogram(hax, r_0_20);
box('off')
set(hst,...
    'BinEdges', 0:0.05:1,...
    'Normalization', 'probability',...
    'FaceColor', defaultColor(colorId)...
    );

hylbl = ylabel('Probability');
hxlbl = xlabel('Length of resultant vector');
httl = title('Strength of phase-locking');

set(hax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% bar graphs
CVLabel = {'Duration (s)', 'Duration (s)', 'Racine''s score'};
CTitle = {'HPC electrographic seizure', 'Ctx electrographic seizure', 'Motor seizure'};
for i = 1:3
    hax = subplot(1, 4, i + 1);

    X = [1 2];
    barY = [sBasicStats(i).Mean(1),0;0 sBasicStats(i).Mean(2)];
    hold(hax,'on');
    
    hbar = bar(hax, X, barY, 0.5, 'stacked');
    set(hbar(1), 'FaceColor',[1 1 1]);
    set(hbar(2), 'FaceColor',[0.5 0.5 0.5]);
    
    xpi = Tb.MSEstm + 1 + 0.25*(rand(size(Tb.MSEstm))-0.5);
    xmat = reshape(xpi, 2, []);
    ymat = reshape(Tb.(VarNames{i}), 2, []);
    hplt = plot(hax, xmat, ymat, '--o');
    set(hplt, 'LineWidth', 0.5, 'MarkerSize', 4, 'Color', defaultColor(colorId));
    
    hxlbl = xlabel('Estim');
    hylbl = ylabel(CVLabel{i});
    httl = title(CTitle{i});
    
    hax = gca;
    yl = get(hax, 'YLim');
    
    % axis parameter settings
    set(hax,...
        'YLim', yl,...
        'XLim', [0.5 2.5],...
        'XTick', [1 2],...
        'XTickLabel', {'Off', 'On'},...
        'FontName', fontname,...
        'FontSize', fontsize...
        );
end

% outputs
print(['../results/figure' supplement num2str(figureNo) '_rat' panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) '_rat' panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Trials = height(Tb);

%% Save
save(['../results/' outputFileName],...
    'sBasicStats', 'sStatsTest', 'No')

disp('done')

end 
