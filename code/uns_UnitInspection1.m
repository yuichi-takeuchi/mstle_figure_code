% Basic Inspection of KlustaInfo and UnitInfo of each session data
% Copyright (C) Yuichi Takeuchi 2017
%% Organize StructInfo
date = 170626;
expnum = 1;
shankID = 0;
datfilenamebase = ['AP_' num2str(date) '_exp' num2str(expnum)];
StructInfo = struct(...
    'date', date,...
    'expnum', expnum,...
    'shankID', shankID,...
    'datfileID', str2num(['uint64(' num2str(date) num2str(expnum,'%02i') num2str(shankID, '%02i') ')']),...
    'datfilenamebase', datfilenamebase,...
    'concadatfilenamebase', [datfilenamebase '_shk' num2str(shankID)],...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_40\170626\concatenated' num2str(expnum)]);

clear date expnum shankID datfilenamebase

%% Move to Matlab folder
cd(StructInfo.MatlabFolder)

%% Move to data folder
cd(StructInfo.DataFolder)

%% loading Structured data
disp('loading variables...'); tic
load([StructInfo.concadatfilenamebase '_RecInfo.mat'], 'RecInfo')
load([StructInfo.concadatfilenamebase '_DatInfo.mat'], 'DatInfo')
load([StructInfo.concadatfilenamebase '_KlustaInfo.mat'], 'KlustaInfo')
load([StructInfo.concadatfilenamebase '_KlustaFeature.mat'], 'KlustaFeature')
load([StructInfo.concadatfilenamebase '_UnitInfo.mat'], 'UnitInfo')
disp('done'); toc

%% Total number of clusters
disp(length(UnitInfo))

%% List of clusters
disp([[UnitInfo.datfileID]', [UnitInfo.CluID]'])

%% Showing AutoCorrelogram base all from UnitInfo
fignum = 1; % figure number
figure(fignum)
% arrayfun(@cla,findall(0,'type','axes'))
arrayfun(@cla,gca)
RecordList = 1:length(UnitInfo);
np2 = nextpow2(length(RecordList));
for i = RecordList
    subplot(np2,np2,i);
    bar(UnitInfo(i).ACG.Time, UnitInfo(i).ACG.Baseline, 'facecolor','k','edgecolor','k');
    xlim([min(UnitInfo(i).ACG.Time) max(UnitInfo(i).ACG.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes;
title('ACG for all unit during non-stimulated sessions');
axis off;
% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );
% delete('tempfigure*.wmf')


%% Showing AutoCorrelogram stimulated all from UnitInfo
fignum = 1; % figure number
figure(fignum)
arrayfun(@cla,gca)
RecordList = 1:length(UnitInfo);
np2 = nextpow2(length(RecordList));
for i = RecordList
    subplot(np2,np2,i);
    bar(UnitInfo(i).ACG.Time, UnitInfo(i).ACG.Stimulated,'facecolor','k','edgecolor','k');
    xlim([min(UnitInfo(i).ACG.Time) max(UnitInfo(i).ACG.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes;
title('ACG for all unit during stimulated sessions');
axis off;
% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );
% delete('tempfigure*.wmf')

%% PSTH view of all unit and all stimulus intensity and stimulus Hz
fignum = 1; % figure number
figure(fignum)
arrayfun(@cla,gca)
RecordList = 1:length(UnitInfo);
np2 = nextpow2(length(RecordList));
for i = RecordList
    subplot(np2,np2,i);
    bar(UnitInfo(i).PSTH.Time, UnitInfo(i).PSTH.CCGR, 'facecolor','k','edgecolor','k');
    xlim([min(UnitInfo(i).PSTH.Time) max(UnitInfo(i).PSTH.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes;
title('PSTH for all unit and all stimulus intensity and stimulus Hz');
axis off;
% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );
% delete('tempfigure*.wmf')

%% PSTH view of all unit and all stimulus intensity at <= 10 Hz
fignum = 1; % figure number
figure(fignum)
arrayfun(@cla,gca)
RecordList = 1:length(UnitInfo);
np2 = nextpow2(length(RecordList));
for i = RecordList
    ax = subplot(np2,np2,i);
    t = UnitInfo(i).PSTH.Time;
    bar(t,UnitInfo(i).PSTH.CCGR,'facecolor','k','edgecolor','k');
    line(t,UnitInfo(i).PSTH.CCGMean,'linestyle','--','color','b');
    line(t,UnitInfo(i).PSTH.Global(1)*ones(size(t)),'linestyle','--','color','m');
    line(t,UnitInfo(i).PSTH.Global(2)*ones(size(t)),'linestyle','--','color','m');
    line(t,UnitInfo(i).PSTH.Local(:,1),'linestyle','--','color','r')
    line(t,UnitInfo(i).PSTH.Local(:,2),'linestyle','--','color','r')
    yl = get(ax, 'YLim');
    p = patch([0 10 10 0],[yl(1) yl(1) yl(2) yl(2)],'b');
    set(p,'FaceAlpha',0.25,'edgecolor','none');
    xlim([min(UnitInfo(i).PSTH.Time) max(UnitInfo(i).PSTH.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes;
title('PSTH for all unit and all stimulus intensity and 1 to 10 Hz stimluation');
axis off;

% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );
% delete('tempfigure*.wmf')

clear fignum RecordList np2 t i yl p flag fullpath
clear s SrcFileNameList

%% PSTH view of one unit
fignum = 2; % figure number
i = 33;
figure(fignum)
arrayfun(@cla,gca)
t = UnitInfo(i).PSTH.Time;
bar(t,UnitInfo(i).PSTH.CCGR,'facecolor','k','edgecolor','k');
line(t,UnitInfo(i).PSTH.CCGMean,'linestyle','--','color','b');
line(t,UnitInfo(i).PSTH.Global(1)*ones(size(t)),'linestyle','--','color','m');
line(t,UnitInfo(i).PSTH.Global(2)*ones(size(t)),'linestyle','--','color','m');
line(t,UnitInfo(i).PSTH.Local(:,1),'linestyle','--','color','r')
line(t,UnitInfo(i).PSTH.Local(:,2),'linestyle','--','color','r')
xlim([min(UnitInfo(i).PSTH.Time) max(UnitInfo(i).PSTH.Time)]);
title(['clu ' num2str(UnitInfo(i).CluID)])

% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );
% delete('tempfigure*.wmf')

clear i fignum t s fullpath flag ax SrcFileNameList

%% Averaged Waveform plot with Std (all channels of one cluster)
i = 17; % record number
fignum = 1; % figure number
arrayfun(@cla,gca)
[hstruct] = unf_PlotWaveformAvgStd(UnitInfo(i).Waveform.Average, UnitInfo(i).Waveform.Std, fignum);
hstruct.hfig.Name = ['Cluster_' num2str(UnitInfo(i).CluID)];

% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );
% delete('tempfigure*.wmf')

clear CluID fignum hstruct i flag fullpath s SrcFileNameList

%% Averaged Waveform plot with Std (all clusters, all channels)
arrayfun(@cla,findall(0,'type','axes'))
fignum = 1:length(UnitInfo); % figure number

for i = fignum
    [hstruct] = unf_PlotWaveformAvgStd(UnitInfo(i).Waveform.Average, UnitInfo(i).Waveform.Std, i);
    hstruct.hfig.Name = ['Cluster_' num2str(UnitInfo(i).CluID)];
    axes;
    title(['cluster ' num2str(i)]);
    axis off;
    
%     print('-dmeta', ['tempfigure' num2str(i) '.wmf']);
end

% s = dir('tempfigure*.wmf'); % s is structure array with fields name, date, bytes, isdir
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, fullpath, 'temp.ppt' );
% delete('tempfigure*.wmf')

clear CluID fignum hstruct i s SrcFileNameList fullpath flag

%% Averaged Waveform plot with std (one cluster, selected channels)
numRec = 17; % record number
fignum = 1; % figure number
arrayfun(@cla,gca)
ColorCell = {'y';'r';'k';'m';'b';'k';'c';'g'};
ScaleBarXX = [45 65]; % 1 ms
ScaleBarXY = [0 0];
ScaleBarYX = [65 65];
ScaleBarYY = [-2000 -1738]; % 200 uV
Channels = UnitInfo(numRec).Channel.Range;
SrcWaveAvg = UnitInfo(numRec).Waveform.Average;
SrcWaveStd = UnitInfo(numRec).Waveform.Std;
figure(fignum);
hold on;
for i = 1:8;
    WaveAvg = SrcWaveAvg(:,Channels(i));
    WaveStdP = WaveAvg + SrcWaveStd(:, Channels(i));
    WaveStdM = WaveAvg - SrcWaveStd(:, Channels(i));
    plot(WaveAvg - 250*(i-1), ['-' ColorCell{i}], 'LineWidth', 1.5);
    plot(WaveStdP - 250*(i-1), ['--' ColorCell{i}]);
    plot(WaveStdM - 250*(i-1), ['--' ColorCell{i}]);
end
plot([55 65],[-2000 -2000],'k',[65 65],[-2000 -1738], 'k', 'LineWidth', 2); % 0.5 ms, 200 uV
hold off;
xlim([1 size(WaveAvg,1)] + 5)
ylim([-2000 250])
set(gca, 'Visible', 'off')

% print('-dmeta', 'tempfigure.wmf');
% s = dir ('tempfigure*.wmf');
% SrcFileNameList = {s.name};
% fullpath = pwd;
% [ flag ] = fileiof_PPTSlideSave( SrcFileNameList, pwd, 'temp.ppt' );

clear Channels ColorCell fignum i numRec SrcWaveAvg SrcWaveStd WaveAvg WaveStdP WaveStdM
clear ScaleBarXX ScaleBarXY ScaleBarYX ScaleBarYY

%% Bar graph over sine wave stimulus phase (all stimulus intensity and Hz)
arrayfun(@cla,findall(0,'type','axes'))
unqInt = UnitInfo(1).StimCircHist.Intensity(:,1);
unqHz = UnitInfo(1).StimCircHist.Hz(1,:);
[lngthInt, lngthHz] = size(UnitInfo(1).StimCircHist.Count);
fignum = 1:(lngthInt*lngthHz); % figure number
indIntMat = repmat((1:lngthInt)',1,lngthHz);
indHzMat = repmat(1:lngthHz, lngthInt, 1);
np2 = nextpow2(length(UnitInfo));
for i = 1:(lngthInt*lngthHz)
    indInt = indIntMat(i);
    indHz = indHzMat(i);
    figure(fignum(i))
    for j = 1:length(UnitInfo)
        ax = subplot(np2,np2,j);
        Phase = linspace(0,4*pi,36);
        Src = UnitInfo(j).StimCircHist.Count{indInt,indHz}(1,:);
        Count = sum(reshape(Src,20,18));
        
            bar(Phase,[Count Count],'facecolor','k','edgecolor','k');
            yl = get(ax, 'YLim');
            t = linspace(0, 4*pi, 720);
            stimwave = 0.25*yl(2)*sin(t + 1.5*pi) + 0.75*yl(2);
            line(t,stimwave,'linestyle','-','color','b');
            xlim([0 4*pi]);
            set(gca, 'XTick', linspace(0,4*pi,3))
            set(gca, 'XTickLabel',{'0','2\pi','4\pi'})
            title(['clu ' num2str(UnitInfo(j).CluID)])
    end
    axes; title(['Sinusoial illumination: ' num2str(unqInt(indInt)) ' mW, ' num2str(unqHz(indHz)) ' Hz']); axis off;
    
    print('-dmeta', ['tempfigure' num2str(i,'%02i') '.wmf']);
end
s = dir('tempfigure*.wmf'); % s is structure array with fields name, date, bytes, isdir
SrcFileNameList = {s.name};
fullpath = pwd;
[ flag ] = fileiof_PPTSlideSave( SrcFileNameList, fullpath, 'temp.ppt' );
delete('tempfigure*.wmf')

clear fignum np2 i Phase Src Count indInt indHz j unqInt unqHz lngthInt lngthHz indIntMat indhzMat
clear indInt indHz ax stimlabel stimwave indHzMat
clear s SrcFileNameList fullpath flag t yl

%% Bar graph over intrinsic phases
arrayfun(@cla,gca)
CField = fieldnames(UnitInfo(1).NetworkHist);
np2 = nextpow2(length(UnitInfo));
for i = 1:numel(CField)
    fignum = i; % figure number
    figure(fignum)
    for j = 1:length(UnitInfo)
        ax = subplot(np2,np2,j);
        Phase = linspace(0,4*pi,36);
        Src = UnitInfo(j).NetworkHist.(CField{i})(1,:);
        
            Count = sum(reshape(Src,20,18));
            bar(Phase,[Count Count],'facecolor','k','edgecolor','k');
            yl = get(ax, 'YLim');
            t = linspace(0, 4*pi, 720);
            ywave = 0.25*yl(2)*sin(t + 1.5*pi) + 0.75*yl(2);
            line(t,ywave,'linestyle','-','color','r');
            xlim([0 4*pi]);
            set(gca, 'XTick', linspace(0,4*pi,3))
            set(gca, 'XTickLabel',{'0','2\pi','4\pi'})
            title(['clu ' num2str(UnitInfo(j).CluID)])
    end
    axes;
    title([CField{i} ' phase modulation']);
    axis off;
    print('-dmeta', ['tempfigure' num2str(i) '.wmf']);
end


s = dir('tempfigure*.wmf'); % s is structure array with fields name, date, bytes, isdir
SrcFileNameList = {s.name};
fullpath = pwd;
[ flag ] = fileiof_PPTSlideSave( SrcFileNameList, fullpath, 'temp.ppt' );
delete('tempfigure*.wmf')
clear ax Count fignum j np2 Phase Src ywave t yl CField i flag fullpath s SrcFileNameList

%% Calculating overall firing rate
CluID = [2:4];
FiringRateVec = unf_CalcFiringRate(KlustaInfo.Cluster,KlustaInfo.Timestamp,CluID,KlustaInfo.numpnts,RecInfo.sr);
clear CluID

%% Save
cd(StructInfo.DataFolder)
aps_Save2
