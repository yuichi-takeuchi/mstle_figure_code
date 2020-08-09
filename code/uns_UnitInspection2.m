% Basic Inspection of KlustaInfo and UnitInfo of collected unit
% informations into a structure named as UnitSum
% Copyright (C) Yuichi Takeuchi 2017
%% Organize InspectInfo
InspectInfo = struct(...
    'matfilenamebase', 'FigureS_Fg_599_DataSum',...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', 'C:\Users\Lenovo\Dropbox\Scrivener\MSOptogenetics\Figures\FigureS7_Fg_599\Graphs'...
    );

%% Move to Matlab folder
cd(InspectInfo.MatlabFolder)

%% Move to data folder
cd(InspectInfo.DataFolder)

%% Load variables
load([InspectInfo.matfilenamebase '.mat'])
RecList = fieldnames(UnitSum);

%% Define recording targeted
recNum = 12;
UnitInfo = UnitSum.(RecList{recNum});
close all

%% Showing AutoCorrelogram base all from UnitInfo
%%%%%%%%%%%%%%%
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
fignum = 1; % figure number
figure(fignum); arrayfun(@cla,gca)
ce = ceil(sqrt(length(UnitInfo)));
for i = 1:length(UnitInfo)
    subplot(ce,ce,i);
    bar(UnitInfo(i).ACG.Time, UnitInfo(i).ACG.Baseline, 'facecolor','k','edgecolor','k');
    xlim([min(UnitInfo(i).ACG.Time) max(UnitInfo(i).ACG.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes; title('ACG for all unit during non-stimulated sessions'); axis off;
fileiof_SinglePPTSlideSave( [num2str(UnitInfo(1).datfileID) '_ACG.ppt'] )
% print([num2str(UnitInfo(1).datfileID) '_ACG.pdf'], '-dpdf'); % pdf file output
close all
clear fignum i ce

%% PSTH view of all unit and all stimulus intensity at <= 10 Hz
%%%%%%%%%%%%%%%
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
fignum = 4; % figure number
figure(fignum); arrayfun(@cla,gca)
ce = ceil(sqrt(length(UnitInfo)));
for i = 1:length(UnitInfo)
    ax = subplot(ce,ce,i);
    t = UnitInfo(i).PSTH.Time;
    CCGR = UnitInfo(i).PSTH.CCGR;
    CCGMean = UnitInfo(i).PSTH.CCGMean;
    Global = UnitInfo(i).PSTH.Global;
    Local = UnitInfo(i).PSTH.Local;
    Title = ['clu ' num2str(UnitInfo(i).CluID)];
    [ hstruct ] = unf_CCG_PlotMeanGlbLcl1( t, CCGR, CCGMean, Global, Local, Title );
    yl = get(gca, 'YLim');
    p = patch([0 10 10 0],[yl(1) yl(1) yl(2) yl(2)],'b');
    set(p,'FaceAlpha',0.25,'edgecolor','none');
end
axes; title('PSTH for all unit and all stimulus intensity and 1 to 10 Hz stimluation'); axis off;
fileiof_SinglePPTSlideSave( [num2str(UnitInfo(1).datfileID) '_PSTH.ppt'] )
% print([num2str(UnitInfo(1).datfileID) '_PSTH.pdf'], '-dpdf'); % pdf file output
close all
clear fignum ce t i yl p ax CCGMean CCGR Global hstruct Local Title

%% Bar graph over sine wave stimulus phase (all stimulus intensity and Hz)
%%%%%%%%%%%%%%%
close all
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
unqInt = UnitInfo(1).StimCircHist.Intensity(:,1);
unqHz = UnitInfo(1).StimCircHist.Hz(1,:);
[lngthInt, lngthHz] = size(UnitInfo(1).StimCircHist.Count);
fignum = 1:(lngthInt*lngthHz); % figure number
indIntMat = repmat((1:lngthInt)',1,lngthHz);
indHzMat = repmat(1:lngthHz, lngthInt, 1);
ce = ceil(sqrt(length(UnitInfo)));
for i = 1:(lngthInt*lngthHz)
    indInt = indIntMat(i);
    indHz = indHzMat(i);
    figure(fignum(i))
    for j = 1:length(UnitInfo)
        ax = subplot(ce,ce,j);
        Src = UnitInfo(j).StimCircHist.Count{indInt,indHz}(1,:);
        Title = ['clu ' num2str(UnitInfo(j).CluID)];
        [ hstruct ] = unf_PlotPhaseHist1( Src, 20, 720, '-b', Title);
    end
    axes; title(['Sinusoial illumination: ' num2str(unqInt(indInt)) ' mW, ' num2str(unqHz(indHz)) ' Hz']); axis off;
    print('-dmeta', ['tempfigure' num2str(i,'%02i') '.wmf']);
end
fileiof_MultiPPTSlideSave( 'tempfigure*.wmf', [num2str(UnitInfo(1).datfileID) '_SineStim.ppt'] )
% print([num2str(UnitInfo(1).datfileID) '_SineStim.pdf'], '-dpdf'); % pdf file output
close all
clear fignum ce i Src indInt indHz j unqInt unqHz lngthInt lngthHz indIntMat indhzMat
clear indInt indHz ax indHzMat Title

%% Bar graph over intrinsic phases
%%%%%%%%%%%%%%%
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
arrayfun(@cla,findall(0,'type','axes'))
CField = fieldnames(UnitInfo(1).NetworkHist);
ce = ceil(sqrt(length(UnitInfo)));
for i = 1:numel(CField)
    fignum = i; % figure number
    figure(fignum)
    for j = 1:length(UnitInfo)
        ax = subplot(ce,ce,j);
        Src = UnitInfo(j).NetworkHist.(CField{i})(1,:);
        Title = ['clu ' num2str(UnitInfo(j).CluID)];
        [ hstruct ] = unf_PlotPhaseHist1( Src, 20, 720, '-r', Title);
    end
    axes; title([CField{i} ' phase modulation']); axis off;
    print('-dmeta', ['tempfigure' num2str(i,'%02i') '.wmf']);
end
fileiof_MultiPPTSlideSave( 'tempfigure*.wmf', [num2str(UnitInfo(1).datfileID) '_IntPhaseMod.ppt'] )
close all
clear ax Count fignum j ce Phase Src ywave t yl CField i Title hstruct

%% List of clusters
% recNum = 1;
disp([[UnitSum.(RecList{recNum}).datfileID]', [UnitSum.(RecList{recNum}).CluID]'])

%% Showing AutoCorrelogram stimulated 
all from UnitInfo
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
fignum = 2; % figure number
figure(fignum); arrayfun(@cla,gca)
ce = ceil(sqrt(length(UnitInfo)));
for i = 1:length(UnitInfo)
    subplot(ce,ce,i);
    bar(UnitInfo(i).ACG.Time, UnitInfo(i).ACG.Stimulated,'facecolor','k','edgecolor','k');
    xlim([min(UnitInfo(i).ACG.Time) max(UnitInfo(i).ACG.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes; title('ACG for all unit during stimulated sessions'); axis off;
% fileiof_SinglePPTSlideSave( 'temp.ppt' )
clear fignum i ce

%% AutoCorrelogram of selected Unit
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
fignum = 8; % figure number
CluID = 4; % record number
numRec = [UnitInfo.CluID] == CluID;
figure(fignum); arrayfun(@cla,gca)
bar(UnitInfo(numRec).ACG.Time, UnitInfo(numRec).ACG.Baseline, 'facecolor','k','edgecolor','k');
xlim([min(UnitInfo(numRec).ACG.Time) max(UnitInfo(numRec).ACG.Time)]);
title(['clu ' num2str(UnitInfo(numRec).CluID)])
% fileiof_SinglePPTSlideSave( 'temp.ppt' )
clear fignum CluID numRec

%% PSTH view of all unit and all stimulus intensity and stimulus Hz
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
fignum = 3; % figure number
figure(fignum); arrayfun(@cla,gca)
ce = ceil(sqrt(length(UnitInfo)));
for i = 1:length(UnitInfo)
    subplot(ce,ce,i);
    bar(UnitInfo(i).PSTH.Time, UnitInfo(i).PSTH.CCGR, 'facecolor','k','edgecolor','k');
    xlim([min(UnitInfo(i).PSTH.Time) max(UnitInfo(i).PSTH.Time)]);
    title(['clu ' num2str(UnitInfo(i).CluID)])
end
axes; title('PSTH for all unit and all stimulus intensity and stimulus Hz'); axis off;
% fileiof_SinglePPTSlideSave( [num2str(UnitInfo(1).datfileID) 'PSTH.ppt'] )
% print([num2str(UnitInfo(1).datfileID) 'PSTH.pdf'], '-dpdf'); % pdf file output
clear i fignum ce

%% PSTH view of one unit
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
i = 1;
fignum = 5; % figure number
figure(fignum);arrayfun(@cla,gca)
t = UnitInfo(i).PSTH.Time;
CCGR = UnitInfo(i).PSTH.CCGR;
CCGMean = UnitInfo(i).PSTH.CCGMean;
Global = UnitInfo(i).PSTH.Global;
Local = UnitInfo(i).PSTH.Local;
Title = ['clu ' num2str(UnitInfo(i).CluID)];
[ hstruct ] = unf_CCG_PlotMeanGlbLcl1( t, CCGR, CCGMean, Global, Local, Title );
% fileiof_SinglePPTSlideSave( 'temp.ppt' )
clear i fignum t ax CCGMean CCGR Global hstruct Local Title

%% Averaged Waveform plot with Std (all channels of one cluster)
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
i = 1; % record number
fignum = 6; % figure number
figure(fignum);arrayfun(@cla,gca)
[hstruct] = unf_PlotWaveformAvgStd(UnitInfo(i).Waveform.Average, UnitInfo(i).Waveform.Std, fignum);
hstruct.hfig.Name = ['Cluster_' num2str(UnitInfo(i).CluID)];
% fileiof_SinglePPTSlideSave( 'temp.ppt' )
clear CluID fignum hstruct i 

%% Averaged Waveform plot with Std (all clusters, all channels)
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
arrayfun(@cla,findall(0,'type','axes'))
fignum = 1:length(UnitInfo); % figure number
for i = fignum
    [hstruct] = unf_PlotWaveformAvgStd(UnitInfo(i).Waveform.Average, UnitInfo(i).Waveform.Std, i);
    hstruct.hfig.Name = ['Cluster_' num2str(UnitInfo(i).CluID)];
    axes; title(['cluster ' num2str(i)]); axis off;
    print('-dmeta', ['tempfigure' num2str(i,'%02i') '.wmf']);
end
fileiof_MultiPPTSlideSave( 'tempfigure*.wmf', 'temp.ppt' )
clear CluID fignum hstruct i

%% Averaged Waveform plot with std (one cluster, selected channels)
% recNum = 1
UnitInfo = UnitSum.(RecList{recNum});
fignum = 7; % figure number
CluID = 4; % record number
numRec = [UnitInfo.CluID] == CluID;
Channels = UnitInfo(numRec).Channel.Range;
SrcWaveAvg = UnitInfo(numRec).Waveform.Average;
SrcWaveStd = UnitInfo(numRec).Waveform.Std;
axisVisible = false;
[ hstruct ] = unf_WaveformPlotSelected( Channels, SrcWaveAvg, SrcWaveStd, axisVisible, fignum );
FRMean = UnitInfo(numRec).BaseFRMean;
FRStd = UnitInfo(numRec).BaseFRStd;
str = ['clu ' num2str(CluID) ', FR: ' num2str(FRMean) ' ± ' num2str(FRStd) ' Hz'];
annotation(hstruct.hfig, 'textbox', [0.3 0.75 0.4 0.2], 'String', str, 'LineStyle', 'none');
% fileiof_SinglePPTSlideSave( 'temp.ppt' )
clear Channels ColorCell fignum i numRec SrcWaveAvg SrcWaveStd CluID hstruct str FRMean FRStd

%% Calculating overall firing rate
CluID = [2:4];
FiringRateVec = unf_CalcFiringRate(KlustaInfo.Cluster,KlustaInfo.Timestamp,CluID,KlustaInfo.numpnts,RecInfo.sr);
clear CluID

%% Save
cd(InspectInfo.DataFolder)
aps_Save2
