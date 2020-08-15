function [sBasicStats, sStatsTest, sBasicStats_MI, sStatsTest_MI, chi2] = figure2fh()
% Calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 2;
panel1 = 'f';
panel2 = 'h';
gThreshold = 0.5;
inputFileName = ['Figure' num2str(figureNo) '_Fg641_OpenLoopStim.csv'];
outputFileName = ['Figure' num2str(figureNo) panel1 panel2 '.mat'];

%% Data import
orgTb = readtable(['../data/' inputFileName]); % original csv data
subTb = orgTb(~logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}

%% Basic statistics and Statistical tests
% sub
[ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.MSEstm);

%% Calculation of parameters (MI)
% getting parameters
subHPCOff = subTb.HPCDrtn(subTb.MSEstm == false);
subHPCOn  = subTb.HPCDrtn(subTb.MSEstm == true);
subMI = (subHPCOn-subHPCOff)./(subHPCOn+subHPCOff);

index = isnan(subMI);
subMI(index) = 0;
clear index

%% Skewness test
subMIpos = subMI(subMI >= 0);
subMIneg = subMI(subMI <= 0);
[ sBasicStats_MI, sStatsTest_MI ] = statsf_getBasicStatsAndTestStructs2( subMIpos, abs(subMIneg) );

%% Separation of data by the global threshold of MI (output is ~supraTbTh or ~subTbTh.csv file)
% Figure preparation of histgram with separation line as well
threshold = gThreshold;

binWidth = 0.1;

% id of animals
idVec = subTb.LTR(subTb.MSEstm == true);
edges = [-1:binWidth:1];
close all

hfig = figure(1);
hax = axes;

% building a plot
[ hs ] = figf_BarAsStackedHist1( hax, subMI, idVec, edges, 'probability');

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

incrStep = 0.8/length(unique(subTb.LTR));
for i = 1:length(unique(subTb.LTR))
    set(hs.bar(i),...
        'FaceColor', [0.1+i*incrStep 0.1+i*incrStep 0.1+i*incrStep]...
        );
end

set(hs.ylbl, 'String', 'Probability');
set(hs.xlbl, 'String', 'Modulation index');
set(hs.ttl, 'String', 'MI of HPC seizures');

% separation line
figure(hfig)
yLimits = get(gca,'YLim');
% hl = line(gca, [x(indForSeparation) x(indForSeparation)], yLimits);
hl = line(gca, [threshold threshold], yLimits);

set(hl,...
    'LineStyle', ':',...
    'LineWidth', 1,...
    'Color', [0 0 0]);

% outputs
print(['../results/figure' num2str(figureNo) panel1 '.pdf'], '-dpdf');
print(['../results/figure' num2str(figureNo) panel1 '.png'], '-dpng');

close all

%%
% CSV file output
tempMI = subMI;

indMI = interleave(tempMI, tempMI);
indThrshld = tempMI > threshold;

indThrshld = interleave(indThrshld, indThrshld);
tempTb = table(indMI, indThrshld, 'VariableNames',{'MI','Thresholded'});

subTbTh = [subTb, tempTb];
writetable(subTbTh, ['tmp/Figure' num2str(figureNo) '_subTbTh.csv'])

%% Proportion of thresholded (labeled) conditions
tempTbTh = subTbTh;
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

%% Figure prepration for fraction of conditioned trials (Sub)
% parameters
unqcond = unique(subTbTh.(12));
CTitle = 'Fraction of seizure-inducted trial';
CVLabel = 'Fraction';
outputGraph = [1 1]; % pdf, png

colorMat = [0 0 0];
CHLabel = 'MS stimulation frequency (Hz)';

outputFileNameBase = ['figure' num2str(figureNo) panel2];
[ flag ] = figset_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
clear flag; close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);

%% Save
save(['../results/' outputFileName], 'sBasicStats', 'sStatsTest', 'sBasicStats_MI', 'sStatsTest_MI', 'chi2', 'No', '-v7.3')
save(['tmp/' outputFileName], 'percThrshlded', '-v7.3')
disp('done')

end
