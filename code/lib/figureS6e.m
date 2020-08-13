function figureS6e()
% Copyright (c) 2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 6;
panel = 'E';
outputFileName = ['Figure' supplement num2str(figureNo) panel '.mat'];

%% data import
load('../data/LTR1_82_83_closed1_instPhases.mat')
instPhases_clsd = instPhases;
clear instPhases

%% select specific trials
instPhs_0 = instPhases_clsd{73,1}; % LTR1_83_190204_exp1_1_rat2_trial4_closed1_offset0_duration20_delay0_jitter0
instPhs_20 = instPhases_clsd{80,1}; % LTR1_83_190204_exp1_1_rat2_trial4_closed1_offset0_duration20_delay20_jitter0
instPhs_40 = instPhases_clsd{87,1}; % LTR1_83_190204_exp1_1_rat2_trial4_closed1_offset0_duration20_delay40_jitter0
instPhs_60 = instPhases_clsd{94,1}; % LTR1_83_190204_exp1_1_rat2_trial4_closed1_offset0_duration20_delay60_jitter0

%% Figure preparation
close all

hfig = figure(1);

% 0 ms
hax(1) = subplot(1, 4, 1);
hph(1) = polarhistogram(instPhs_0, 12);
hpax(1) = gca;
htt(1) = title('0 ms');

% 20 ms
hax(2) = subplot(1, 4, 2);
hph(2) = polarhistogram(instPhs_20, 12);
hpax(2) = gca;
htt(2) = title('20 ms');

% 40 ms
hax(3) = subplot(1, 4, 3);
hph(3) = polarhistogram(instPhs_40, 12);
hpax(3) = gca;
htt(3) = title('40 ms');

% 60 ms
hax(4) = subplot(1, 4, 4);
hph(4) = polarhistogram(instPhs_60, 12);
hpax(4) = gca;
htt(4) = title('60 ms');

% global arameters
fontname = 'Arial';
fontsize = 7;

% parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 17 4],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [18 5] ... % width, height
    );

% axis parameter settings
set(hpax,...
    'RLim', [0 85],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );


set(hph,...
    'FaceColor', [0 0 1]...
    );

% outputs
print('../results/figureS6e.pdf', '-dpdf');
print('../results/figureS6e.png', '-dpng');
close all

%% Number of rats and trials
No.detection = size(instPhs_0, 1);

%% Save
save(['../results/' outputFileName], 'No')
disp('done')

end
