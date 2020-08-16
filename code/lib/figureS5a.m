function figureS5a()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 5;
panel = 'A';
outputFileName = ['figure' supplement num2str(figureNo) panel '.mat'];

%% data import
load('../data/LTR1_99_100_closed0_instPhases.mat')
instPhases_open = instPhases;
load('../data/LTR1_99_100_closed1_instPhases.mat')
instPhases_closed = instPhases;
clear instPhases

%% select specific trials
instPhs_open = instPhases_open{16,1}; % LTR1_100_181124_exp1_1_rat2_trial1_closed0_offset0_duration20_delay0_jitter0
instPhs_closed = instPhases_closed{94,1}; % LTR1_100_181111_exp1_1_rat2_trial1_closed1_offset40_duration20_delay0_jitter0

%% Figure preparation
close all

hfig = figure(1);

% left part (open-loop)
hax1 = subplot(1, 2, 1);
hph1 = polarhistogram(instPhs_open, 12);
hpax1 = gca;
httl1 = title('open-loop');

% right part (closed-loop)
hax2 = subplot(1, 2, 2);
hph2 = polarhistogram(instPhs_closed, 12);
hpax2 = gca;
httl2 = title('closed-loop');

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
set(hpax1,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(hph1,...
    'FaceColor', [0 0 0]...
    );

set(hpax2,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(hph2,...
    'FaceColor', [0 0 0]...
    );

% outputs
print('../results/figureS5a.pdf', '-dpdf');
print('../results/figureS5a.png', '-dpng');
close all

%% Number of rats and trials
No.open = size(instPhs_open, 1);
No.closed = size(instPhs_closed, 1);

%% Save
save(['../results/' outputFileName], 'No')
disp('done')

end
