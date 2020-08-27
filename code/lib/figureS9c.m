function [No] = figureS9c()
% Copyright(c) 2018-2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 9;
panel = 'c';
inputFileName1 = 'Figure3_0_20.csv';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% r histogram all
% data
Tb20 = readtable(['../data/' inputFileName1]);
r_0_20 = Tb20.r;

% r get the threshold
xRange = [0 1];
[ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation2( r_0_20, xRange);
x = linspace(xRange(1), xRange(2), 1000);
rThreshold = x(indForSeparation);

% fitting
numGaussian = 2;
gmdist = fitgmdist(r_0_20, numGaussian);
gmsigma = gmdist.Sigma;
gmmu = gmdist.mu;
gmwt = gmdist.ComponentProportion;
binWidth = 0.05;
fit1 = pdf(gmdist, x')*binWidth; 
fit2 = pdf('Normal', x, gmmu(1), gmsigma(1)^0.5)*gmwt(1)*binWidth;
fit3 = pdf('Normal', x, gmmu(2), gmsigma(2)^0.5)*gmwt(2)*binWidth;

% id of animals
idVec = Tb20.LTR;
edges = 0:binWidth:1;
close all

hfig = figure(1);
hax = axes;

% building a plot
[ hs ] = figf_BarAsStackedHistWThreeFits1(hax, r_0_20, idVec, edges, x, fit1, fit2, fit3, 'probability' ); % data1, data2, fignum

% global parameters
fontname = 'Arial';
fontsize = 5;

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 5 5],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [5 5]... % width, height
    );

% axis parameter settings
set(hs.ax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

incrStep = 0.8/length(unique(Tb20.LTR));
for i = 1:length(unique(Tb20.LTR))
    set(hs.bar(i),...
        'FaceColor', [0.1+i*incrStep 0.1+i*incrStep 0.1+i*incrStep]...
        );
end

% fitting curve parameter settings
set(hs.plt{1},...
    'LineWidth', 1,...
    'Color', [0.2 0.2 0.2]...
    );

set(hs.plt{2},...
    'LineStyle', '--',...
    'LineWidth', 1,...
    'Color', [0 0 0]...
    );

set(hs.plt{3},...
    'LineStyle', '--',...
    'LineWidth', 1,...
    'Color', [0 1 0]...
    );

set(hs.ylbl, 'String', 'Probability');
set(hs.xlbl, 'String', 'r');
set(hs.ttl, 'String', 'Length of resultant vector');

% separation line
figure(hfig)
yLimits = get(gca,'YLim');
hl = line(gca, [x(indForSeparation) x(indForSeparation)], yLimits);
% hl = line(gca, [threshold threshold], yLimits);

set(hl,...
    'LineStyle', ':',...
    'LineWidth', 1,...
    'Color', [0 0 0]);

% outputs
print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');

close all

%% Separation of data by the threshold of r (output is ~rTbTh.csv file)
% CSV file output
Tb20_full = readtable(['../data/' inputFileName1]);

r_Tb20 = Tb20_full.r;
indThrshldHalf = r_Tb20(Tb20_full.MSEstm == 1) > rThreshold;
indThrshld = interleave(indThrshldHalf, indThrshldHalf);

tempTb = table(indThrshld, 'VariableNames',{'rThrshlded'});

rTbTh = [Tb20_full, tempTb];
writetable(rTbTh, ['tmp/Figure' supplement num2str(figureNo) '_rTbTh.csv'])

%% Number of rats and trials
No.Rats = length(unique(rTbTh.LTR));
No.Trials = length(rTbTh.LTR);

%% Save
save(['../results/' outputFileName],...
    'No')
disp('done')

end
