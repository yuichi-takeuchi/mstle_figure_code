function [sBasicStats, sStatsTest, sBasicStats_MI, sStatsTest_MI, No] = figureS7(ratId, colorId)
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 7;
panel = num2str(ratId);
inputFileName = 'Figure3_Fg641_ClosedLoopStim.csv';
outputFileName = ['figure' supplement num2str(figureNo) '_' panel '.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
Tb = orgTb(orgTb.LTR == ratId,:); % 
VarNames = orgTb.Properties.VariableNames([18, 19, 15]); % {HPCDrtn, CtxDrtn, RS}

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( Tb, VarNames, Tb.MSEstm );

%% Calculation of parameters (MI)
% getting parameters (supra)
HPCOff = Tb.HPCDrtn(Tb.MSEstm == false);
HPCOn  = Tb.HPCDrtn(Tb.MSEstm == true);
MI = (HPCOn-HPCOff)./(HPCOn+HPCOff);

%% Skewness test
MIpos = MI(MI >= 0);
MIneg = MI(MI <= 0);
[ sBasicStats_MI, sStatsTest_MI ] = statsf_getBasicStatsAndTestStructs2( MIpos, abs(MIneg) );

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

hst = histogram(hax, MI);
box('off')
set(hst,...
    'BinEdges', -1:0.1:1,...
    'Normalization', 'probability',...
    'FaceColor', defaultColor(colorId)...
    );

hylbl = ylabel('Probability');
hxlbl = xlabel('Modulation index');
httl = title('MI of HPC seizures');

set(hax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% bar graphs
CVLabel = {'Duration (s)', 'Duration (s)', 'Racine''s scale'};
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
    'sBasicStats', 'sStatsTest',...
    'sBasicStats_MI', 'sStatsTest_MI', 'No', '-v7.3')
disp('done')

end 
