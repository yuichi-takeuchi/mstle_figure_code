function figureS6a()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 6;
panel = 'a';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% data import
load('../data/LTR1_82_83_closed0_instPhases.mat')
instPhases_open = instPhases;
load('../data/LTR1_82_83_closed1_instPhases.mat')
instPhases_closed = instPhases;
clear instPhases

%% select specific trials
instPhs_open = instPhases_open{16,1}; % LTR1_83_190204_exp1_1_rat2_trial2_closed0_offset0_duration20_delay0_jitter0
instPhs_closed = instPhases_closed{72,1}; % LTR1_83_190204_exp1_1_rat2_trial3_closed1_offset0_duration20_delay0_jitter0

%% Figure preparation
close all

hfig = figure(1);

% left part (open-loop)
hax(1) = subplot(1, 2, 1);
hph(1) = polarhistogram(instPhs_open, 12);
hpax(1) = gca;
htt(1) = title('open-loop');

% right part (closed-loop)
hax(2) = subplot(1, 2, 2);
hph(2) = polarhistogram(instPhs_closed, 12);
hpax(2) = gca;
htt(2) = title('closed-loop');

% global arameters
fontname = 'Arial';
fontsize = 7;

% parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 9 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [10 5] ... % width, height
    );

% axis parameter settings
set(hpax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(hph,...
    'FaceColor', [0 0 1]...
    );

set(hpax,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(hph,...
    'FaceColor', [0 0 1]...
    );

% outputs
print('../results/figureS6a.pdf', '-dpdf');
print('../results/figureS6a.png', '-dpng');
close all

%% Number of rats and trials
No.open = size(instPhs_open, 1);
No.closed = size(instPhs_closed, 1);

%% Save
save(['../results/' outputFileName], 'No')
disp('done')

end
