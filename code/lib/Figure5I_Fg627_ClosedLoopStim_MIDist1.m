% This script calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) 2019, 2020 Yuichi Takeuchi
clc; clear; close all
%% Organizing MetaInfo
Supplement = '';
FigureNo = 5;
FgNo = 627;
Panel = 'I';
bitLabel = [1 1]; % for [open or closed, estim or optogenetic]
gThreshold = -0.4515;
if bitLabel(1)
    control = 'Closed';
    graphSuffix = 'Dly';
else
    control = 'Open';
    graphSuffix = 'Hz';
end
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['C:\Users\Lenovo\Documents\project_git\mstle\paper\figure\code\figure' Supplement num2str(FigureNo)],...
    'inputFileName', ['Figure' Supplement num2str(FigureNo) '_Fg' num2str(FgNo) '_' control 'LoopStim.csv'],...
    'outputFileName', ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MIDist.mat'],...
    'mFileCopyName',  ['Figure' Supplement num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MIDist1.m'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'graphSuffix', graphSuffix,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo,...
    'gThreshold', gThreshold...
    );
clear FigureNo FgNo control graphSuffix bitLabel Panel Supplement gThreshold

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import
load('Figure3EG_Fg641_ClosedLoopStim_MIDist.mat', 'percThrshlded');
percTh_Estim = percThrshlded;
load('Figure4FH_Fg603_ClosedLoopStim_MIDist.mat', 'percThrshlded');
percTh_VGATChR2 = percThrshlded;
load('Figure5F_Fg627_ClosedLoopStim_MIDist.mat', 'percThrshlded');
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
outputFileNameBase = 'SupraClosedLoop_Figure5I';
print([outputFileNameBase '.pdf'], '-dpdf');
print([outputFileNameBase '.png'], '-dpng');

clear x xlm hax hfig hp outputFileNameBase
close all

%% Save
cd(MetaInfo.DataFolder)
save(MetaInfo.outputFileName, '-v7.3')
