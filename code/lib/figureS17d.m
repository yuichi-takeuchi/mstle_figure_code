function [sBasicStats, sStatsTest, sBasicStats_MI, sStatsTest_MI, No] = figureS17d()
% Calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 17;
panel = 'd';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg603_OpenLoopStim.csv'];
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

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

%% Figure preparation of MI with curve fitting with one Gaussian component
% fitting
binWidth = 0.1;

numGaussian = 1;
gmdist = fitgmdist(supraMI, numGaussian);
gmsigma = gmdist.Sigma;
gmmu = gmdist.mu;
gmwt = gmdist.ComponentProportion;
x = linspace(-1, 1, 1000);
fitdata = pdf(gmdist, x')*gmwt(1)*binWidth;

% id of animals
idVec = supraTb.LTR(supraTb.Laser == true);
edges = [-1:binWidth:1];
close all

hfig = figure(1);
hax = axes;

% building a plot
[ hs ] = figf_BarAsStackedHistWOneFit1(hax, supraMI, idVec, edges, x, fitdata, 'probability' );

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
set(hs.plt,...
    'Color', [0 0 0]...
    );

set(hs.ylbl, 'String', 'Probability');
set(hs.xlbl, 'String', 'Modulation index');
set(hs.ttl, 'String', 'MI of HPC seizures');

% outputs
print(['../results/figure' supplement num2str(figureNo) panel '.pdf'], '-dpdf');
print(['../results/figure' supplement num2str(figureNo) panel '.png'], '-dpng');

close all

%% Number of rats and trials
No.Rats = length(unique(supraTb.LTR));
No.Trials = length(supraTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'sBasicStats_MI', 'sStatsTest_MI', 'No', '-v7.3')
disp('done')

end
