function [percTh_Estim, percTh_VGATChR2, percTh_CamkiiaChR2, percTh_Sum] = figure5i()
% This script calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi

%% params
figureNo = 5;
fgNo = 627;
panel = 'I';
control = 'Closed';
inputFileName = ['../data/Figure' num2str(figureNo) '_Fg' num2str(fgNo) '_' control 'LoopStim.csv'];
outputFileName = ['../results/Figure' num2str(figureNo) panel '_' control 'LoopStim_MIDist.mat'];

%% Data import
load('tmp/Figure3EG_ClosedLoopStim_MIDist.mat', 'percThrshlded');
percTh_Estim = percThrshlded;
load('tmp/Figure4FH_ClosedLoopStim_MIDist.mat', 'percThrshlded');
percTh_VGATChR2 = percThrshlded;
load('tmp/Figure5F_ClosedLoopStim_MIDist.mat', 'percThrshlded');
percTh_CamkiiaChR2 = percThrshlded;
clear percThrshlded

%% Summation
percTh_Sum = percTh_VGATChR2 + percTh_CamkiiaChR2;

%% Figure prepration for fraction of conditioned trials (Figure H)
% parameters
x = [0 20 40 60];

hfig = figure(4);
hax = axes; % subplot
hold(hax,'on');
hp(1) = plot(hax, x, percTh_CamkiiaChR2, ':ob');
hp(2) = plot(hax, x, percTh_VGATChR2, '--ob');
hp(3) = plot(hax, x, percTh_Estim, '-ok');
hp(4) = plot(hax, x, percTh_Sum, '-ob');

hold(hax,'off');
box('off')

% setting parametors of bars and plots
set(hp, 'LineWidth', 0.5, 'MarkerSize', 4);
set(hp(3), 'Marker', 'o', 'MarkerFaceColor', [0 0 0]);
set(hp(4), 'Marker', 'o', 'MarkerFaceColor', [0 0 1]);
ylabel('Fraction');
xlabel('MS stimulation delay (ms)');
title('Fraction of success trial pairs');
legend({'CaMKIIa-ChR2', 'VGAT-ChR2', 'E-stim', 'CaMKIIa + VGAT'}, 'Box', 'Off');

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 4 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [5 5]... % width, height
    );

xlm = get(hax,'XLim');

% axis parameter settings
set(hax,...
    'FontName', 'Arial',...
    'FontSize', 5,...
    'YLim', [0 1],...
    'XLim', [xlm(1)-5 xlm(2)+5]...
    );

% outputs
outputFileNameBase = ['Figure' num2str(figureNo) panel '_SupraClosedLoop'];
print([outputFileNameBase '.pdf'], '-dpdf');
print([outputFileNameBase '.png'], '-dpng');
movefile([outputFileNameBase '.pdf'], ['../results/' outputFileNameBase '.pdf'])
movefile([outputFileNameBase '.png'], ['../results/' outputFileNameBase '.png'])
close all

%% Save
save(outputFileName, 'percTh_Estim', 'percTh_VGATChR2', 'percTh_CamkiiaChR2', 'percTh_Sum', '-v7.3')
end

