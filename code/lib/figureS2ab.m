function [No] = figureS2ab()
% Development of hippocampal kindling, evaluated with Racine's scale and
% wet-dog shakes
% Copyright (c) 2018–2020 Yuichi Takeuchi

%% params
supplement = 'S';
figureNo = 2;
fgNo = 632;
panel = 'ab';
inputFileName = ['Figure' supplement num2str(figureNo) '_Fg' num2str(fgNo) '_RSDevelop.csv'];
outputFileNameBase = ['figure' supplement num2str(figureNo) panel];

%% Data import
srcTb = readtable(['../data/' inputFileName]);

%% Takeing variables
LTR = srcTb.LTR;
Num = srcTb.Num;
RS = srcTb.RS;
WDS = srcTb.WDS;

%% Descriptive parameters for plotting
uniqueNum = unique(Num);
MeanRS = zeros(1,length(uniqueNum));
StdRS = zeros(1,length(uniqueNum));
MeanWDS = zeros(1,length(uniqueNum));
StdWDS = zeros(1,length(uniqueNum));

for i = 1:length(uniqueNum)
    tempRS = RS(Num == i);
    tempWDS = WDS(Num == i);
    MeanRS(i) = mean(tempRS);
    StdRS(i) = std(tempRS);
    MeanWDS(i) = mean(tempWDS);
    StdWDS(i) = std(tempWDS);
end
clear i tempRS tempWDS

%% get animal-resolved data
animalID = unique(LTR);

for i = 1:length(animalID)
    idx = LTR == animalID(i);
    animalRS(i,1:nnz(idx)) = RS(idx)';
    animalWDS(i,1:nnz(idx)) = WDS(idx);
end
clear i animal ID

%% Organizing figure
close all
hfig = figure(1);
haxes1 = subplot(1,2,1);
hold on
plot(uniqueNum, animalRS, '-o', 'LineWidth', 0.4, 'MarkerSize', 3)
plot(uniqueNum, MeanRS, '-ok', 'MarkerFaceColor', 'k', 'LineWidth', 0.5, 'MarkerSize', 4)
hold off
title('Motor seizure');
xlabel('Cumulative number of stimulation')
ylabel('Racine''s scale')
set(gca,...
    'YLim', [0 5],...
    'YTick',[1:5]...
    )     
haxes2 = subplot(1,2,2);
hold on
plot(uniqueNum, animalWDS, '-o', 'LineWidth', 0.4, 'MarkerSize', 3)
plot(uniqueNum, MeanWDS, '-ok', 'MarkerFaceColor', 'k', 'LineWidth', 0.5, 'MarkerSize', 3)
hold off
title('Wet-dog shaking')
xlabel('Cumulative number of stimulation')
ylabel('# Wet-dog shaking')

% global parameters
fontname = 'Arial';
fontsize = 8;

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 16 8],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17 9],... % width, height
    'NumberTitle','on',...
    'Name','test'...
    );

% axis parameter settings
set(haxes1,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(haxes2,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

% outputs
print(['../results/' outputFileNameBase '.pdf'], '-dpdf');
print(['../results/' outputFileNameBase '.png'], '-dpng');

close all

%% Number of rats
No = length(unique(srcTb.LTR));

%% Save
save(['../results/' outputFileNameBase '.mat'])
disp('done')

end
