function figure7()
% Copyright © 2020 Yuichi Takeuchi

%% params
figureNo = 7;
inputFileName1 = 'AP_190718_exp1_3_LFP500_1_trial1.dat';
inputFileName2 = 'AP_190718_exp1_3_adc_1_trial1.dat';

%% data import for closed-loop
md = memmapfile(['../data/' inputFileName1], 'format', 'int16');
multiplexed= md.data;
lfp = reshape(multiplexed, 30,[]);
madc = memmapfile(['../data/' inputFileName2], 'format', 'int16');
adc(1,:) = madc.data(:);

%% data cut for closed-loop
lfp_seg = lfp(24,2251:2750);
adc_seg = adc(2251:2750);
detection = adc_seg;
idx_high = adc_seg > 1000;
idx_low = adc_seg < 1000 | adc_seg == 1000;
detection(idx_high) = 1;
detection(idx_low) = 0;

%% create constant frequency pulses for open-loop
[openloop_stim,~] = stimf_CreateSquarePulses(11, 0.022, 1, 500);
openloop_stim_shift = openloop_stim;
openloop_stim_shift(1:end-22) = openloop_stim(23:end);
openloop_stim_shift(end-21:end) = openloop_stim(1:22);

%% closed-loop plot
hfig = figure (1);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0 0 6 7],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [6 7]... % width, height
    );

fontname = 'Arial';
fontsize = 7;

hax(1) = subplot(3,1,1);
plot(gca, lfp_seg, 'k');
axis('off')
title(gca,'HPC electrographic seizures')
hax(1).Title.Visible = 'on';

hax(2) = subplot(3,1,2);
plot(detection, 'b')
axis('off')
title(gca,'Closed-loop stimulation', 'Color', [0 0 1])
hax(2).Title.Visible = 'on';

hax(3) = subplot(3,1,3);
plot(openloop_stim_shift, 'r')
axis('off')
title(gca,'Responsive open-loop stimulation', 'Color', [1 0 0])
hax(3).Title.Visible = 'on';

set(hax,...
    'XLim', [1 500],...
    'FontName', fontname,...
    'FontSize', fontsize)

print(['../results/figure' num2str(figureNo) '.pdf'], '-dpdf')
print(['../results/figure' num2str(figureNo) '.png'], '-dpng')
close all

%%
disp('done')

end
