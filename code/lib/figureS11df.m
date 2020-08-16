function [sBasicStats, sStatsTest, sBasicStats_MI, sStatsTest_MI, chi2] = figureS11df()
% This script calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 11;
panel1 = 'd';
panel2 = 'f';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg624_ClosedLoopStim.csv'];
outputFileName = ['figure' supplement num2str(figureNo) panel1 panel2 '.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% supra
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.Laser );

%% Calculation of parameters (MI)
% getting parameters (supra)
HPCOff = supraTb.HPCDrtn(supraTb.Laser == false);
HPCOn  = supraTb.HPCDrtn(supraTb.Laser == true);
supraMI = (HPCOn-HPCOff)./(HPCOn+HPCOff);

%% Skewness test
supraMIpos = supraMI(supraMI >= 0);
supraMIneg = supraMI(supraMI <= 0);
[ sBasicStats_MI, sStatsTest_MI ] = statsf_getBasicStatsAndTestStructs2( supraMIpos, abs(supraMIneg) );

%% Get the threshold
[ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( supraMI );
x = linspace(-1, 1, 1000);
gThreshold = x(indForSeparation);

%% Figure preparation of MI with curve fitting of two Gaussian components
threshold = gThreshold;

% fitting
numGaussian = 2;
gmdist = fitgmdist(supraMI, numGaussian);
gmsigma = gmdist.Sigma;
gmmu = gmdist.mu;
gmwt = gmdist.ComponentProportion;
x = linspace(-1, 1, 1000);
binWidth = 0.1;
fit1 = pdf(gmdist, x')*binWidth; 
fit2 = pdf('Normal', x, gmmu(1), gmsigma(1)^0.5)*gmwt(1)*binWidth;
fit3 = pdf('Normal', x, gmmu(2), gmsigma(2)^0.5)*gmwt(2)*binWidth;

% id of animals
idVec = supraTb.LTR(supraTb.Laser == true);
edges = [-1:binWidth:1];
close all

hfig = figure(1);
hax = axes;

% building a plot
[ hs ] = figf_BarAsStackedHistWThreeFits1(hax, supraMI, idVec, edges, x, fit1, fit2, fit3, 'probability' ); % data1, data2, fignum

% global parameters
fontname = 'Arial';
fontsize = 5;

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 4 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [5 5]... % width, height
    );

% axis parameter settings
set(hs.ax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

incrStep = 0.8/length(unique(supraTb.LTR));
for i = 1:length(unique(supraTb.LTR))
    set(hs.bar(i),...
        'FaceColor', [0.1+i*incrStep 0.1+i*incrStep 0.1+i*incrStep]...
        );
end

% fitting curve parameter settings
set(hs.plt{1},...
    'Color', [0 0 0]...
    );

set(hs.plt{2},...
    'LineStyle', '--',...
    'LineWidth', 1,...
    'Color', [0 0 0]...
    );

set(hs.plt{3},...
    'LineStyle', '--',...
    'LineWidth', 1,...
    'Color', [0 0 1]...
    );

set(hs.ylbl, 'String', 'Probability');
set(hs.xlbl, 'String', 'Modulation index');
set(hs.ttl, 'String', 'MI of HPC seizures');

% separation line
% [ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( data );
figure(hfig)
yLimits = get(gca,'YLim');
% hl = line(gca, [x(indForSeparation) x(indForSeparation)], yLimits);
hl = line(gca, [threshold threshold], yLimits);

set(hl,...
    'LineStyle', ':',...
    'LineWidth', 1,...
    'Color', [0 0 0]);

% outputs
print(['../results/figure' supplement num2str(figureNo) panel1 '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel1 '.png'], '-dpng');

close all

%% Separation of data by the global threshold of MI (output is ~supraTbTh or ~subTbTh.csv file)
% parameters
threshold = gThreshold;
direction = [0]; % 0 for lower, 1 for upper

% CSV file output
tempMI = supraMI;

indMI = interleave(tempMI, tempMI);
indThrshld = tempMI < threshold;

indThrshld = interleave(indThrshld, indThrshld);
tempTb = table(indMI, indThrshld, 'VariableNames',{'MI','Thresholded'});

supraTbTh = [supraTb, tempTb];
writetable(supraTbTh, ['tmp/Figure' supplement num2str(figureNo) '_supraTbTh.csv'])

%% Proportion of thresholded (labeled) conditions
tempTbTh = supraTbTh;
condVec = tempTbTh.(12);
unqcond = unique(condVec);
stimVec = tempTbTh.(10);
thrshldVec = tempTbTh.(23);

for i = 1:length(unqcond)
    n(i) = nnz(stimVec(condVec == unqcond(i) & thrshldVec == 1)); % Number of thresholded trials
    N(i) = nnz(stimVec(condVec == unqcond(i))); % No trial
end
[ chi2h, chi2p, chi2stats ] = statsf_chi2test( n, N ); % chi-square test
chi2 = struct(...
    'h', chi2h,...
    'p', chi2p,...
    'stats', chi2stats...
    );

percThrshlded = n./N;

%% Figure prepration for fraction of conditioned trials (Supra)
% parameters
unqcond = unique(supraTbTh.(12));
CTitle = {'Fraction of success trial pairs'};
CVLabel = {'Fraction'};
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 1]; % RGB
CHLabel = 'MS illumination delay (ms)';
    
outputFileNameBase = ['figure' supplement num2str(figureNo) panel2];
[ flag ] = figset_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag; close all

%% Number of rats and trials
No.Rats = length(unique(supraTb.LTR));
No.Trials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'sBasicStats_MI', 'sStatsTest_MI', 'chi2', 'No', '-v7.3')
save(['tmp/' outputFileName], 'percThrshlded', '-v7.3')
disp('done')

end 
