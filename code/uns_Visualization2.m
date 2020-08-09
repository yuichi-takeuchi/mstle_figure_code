% uns_Unit Visualization2.m
% Basic Inspection of KlustaInfo and UnitInfo
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
tic
disp('loading variables...')
load([StructInfo.concadatfilenamebase '_RecInfo.mat'], 'RecInfo')
load([StructInfo.concadatfilenamebase '_DatInfo.mat'], 'DatInfo')
load([StructInfo.concadatfilenamebase '_KlustaInfo.mat'], 'KlustaInfo')
load([StructInfo.concadatfilenamebase '_KlustaFeature.mat'], 'KlustaFeature')
load([StructInfo.concadatfilenamebase '_UnitInfo.mat'], 'UnitInfo')
disp('done')
toc

%% Total number of clusters
disp(length(UnitInfo))

%% List of clusters
disp([[UnitInfo.datfileID]', [UnitInfo.CluID]'])

%% Showing AutoCorrelogram 1 after calcuration
CluID = 1;
BinSize = 20;
HalfBins = 30;
fignum = 2;
figure(fignum);
arrayfun(@cla,findall(0,'type','axes'))
%[out, t, Pairs, Bias ] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs);
[out, t, ~, ~ ] = CCG(double(KlustaInfo.Timestamp), KlustaInfo.Cluster, BinSize, HalfBins, RecInfo.sr, CluID, 'count', []);
h = figure (fignum); bar(t,out(:,1)); xlabel('ms'); title(['cluster ' num2str(CluID)]); xlim([min(t) max(t)]);

clear CluID BinSize HalfBins out t fignum h

%% Showing AutoCorrelogram from calucuration
CluID = 1;
BinSize = 20;
HalfBins = 30;
fignum = 2;
figure(fignum);
arrayfun(@cla,findall(0,'type','axes'))
%[out, t, Pairs, Bias ] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs);
[out, t, ~, ~ ] = CCG(double(KlustaInfo.Timestamp), KlustaInfo.Cluster, BinSize, HalfBins, RecInfo.sr, CluID, 'count', []);
h = figure (fignum); bar(t,out(:,1)); xlabel('ms'); title(['cluster ' num2str(CluID)]); xlim([min(t) max(t)]);

clear CluID BinSize HalfBins out t fignum h

%% Showing All-correlogram from calucuration
CluID = [2:36]; % CluID
BinSize = 20;
HalfBins = 50;
fignum = 2; % figure number
figure(fignum);
arrayfun(@cla,findall(0,'type','axes'))
%[out, t, Pairs, Bias ] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs);
[out, t, ~, ~ ] = CCG(double(KlustaInfo.Timestamp), KlustaInfo.Cluster, BinSize, HalfBins, RecInfo.sr, CluID, 'count', []);
h = figure (fignum);
for i = 1:length(CluID)
    subplot(6,6,i)
    bar(t,out(:,i,i)); title(['cluster ' num2str(CluID(i))]); xlim([min(t) max(t)]);
end
clear CluID BinSize HalfBins out t fignum h i


%% Raster plot marker
% [hstruct] = mfRasterPlot(CluVec, Timestamp, CluID, fignum)
CluID = 2:3; % CluID
fignum = 1; % figure number
figure(fignum)
arrayfun(@cla,findall(0,'type','axes'))
[hstruct] = unf_RasterPlotDot(KlustaInfo.Cluster, KlustaInfo.Timestamp, CluID, fignum);
clear hstruct CluID fignum

%% Raster plot line
CluID = 2:3; % CluID
fignum = 1; % figure number
figure(fignum)
arrayfun(@cla,findall(0,'type','axes'))
[hstruct] = unf_RasterPlotLine(KlustaInfo.Cluster, KlustaInfo.Timestamp, CluID, fignum);
clear hstruct

%% Calculating timecourse firing rate
CluID = [2:36];
FiringRateMat = unf_CalcFiringRateTimecourse(KlustaInfo.Cluster,KlustaInfo.Timestamp,CluID,KlustaInfo.numpnts,RecInfo.sr,1);
clear CluID

%% Plot firing rate matrix
CluID = [2:36];
fignum = 1; % figure number
figure(fignum)
arrayfun(@cla,findall(0,'type','axes'))
[hstruct] = unf_PlotFiringRateMat(FiringRateMat, CluID, fignum);
clear hstruct CluID fignum

%% Image firing rate matrix sc
CluID = [2:36];
fignum = 1; % figure number
Clims = [];
figure(fignum)
arrayfun(@cla,findall(0,'type','axes'))
[hstruct] = unf_ImageSCFiringRateMat(FiringRateMat, Clims, CluID, fignum);
clear hstruct CluID fignum Clims

%% Image normalized firng rate matrix sc (z-score)
CluID = [2:36];
fignum = 1; % figure number
ZMat = zscore(FiringRateMat);
Clims = [0 5];
figure(fignum)
arrayfun(@cla,findall(0,'type','axes'))
[hstruct] = unf_ImageSCFiringRateMat(ZMat, Clims, CluID, fignum);
hstruct.hcb.Label.String = 'z-score';
clear hstruct CluID fignum Clims ZMat


%% Showing AutoCorrelogram 1 after calcuration
CluID = 1;
BinSize = 20;
HalfBins = 30;
fignum = 2;
figure(fignum);
arrayfun(@cla,findall(0,'type','axes'))
%[out, t, Pairs, Bias ] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs);
[out, t, ~, ~ ] = CCG(double(KlustaInfo.Timestamp), KlustaInfo.Cluster, BinSize, HalfBins, RecInfo.sr, CluID, 'count', []);
h = figure (fignum); bar(t,out(:,1)); xlabel('ms'); title(['cluster ' num2str(CluID)]); xlim([min(t) max(t)]);

clear CluID BinSize HalfBins out t fignum h

%% Showing AutoCorrelogram from calucuration
CluID = 1;
BinSize = 20;
HalfBins = 30;
fignum = 2;
figure(fignum);
arrayfun(@cla,findall(0,'type','axes'))
%[out, t, Pairs, Bias ] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs);
[out, t, ~, ~ ] = CCG(double(KlustaInfo.Timestamp), KlustaInfo.Cluster, BinSize, HalfBins, RecInfo.sr, CluID, 'count', []);
h = figure (fignum); bar(t,out(:,1)); xlabel('ms'); title(['cluster ' num2str(CluID)]); xlim([min(t) max(t)]);

clear CluID BinSize HalfBins out t fignum h

%% Showing All-correlogram from calucuration
CluID = [2:36]; % CluID
BinSize = 20;
HalfBins = 50;
fignum = 2; % figure number
figure(fignum);
arrayfun(@cla,findall(0,'type','axes'))
%[out, t, Pairs, Bias ] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs);
[out, t, ~, ~ ] = CCG(double(KlustaInfo.Timestamp), KlustaInfo.Cluster, BinSize, HalfBins, RecInfo.sr, CluID, 'count', []);
h = figure (fignum);
for i = 1:length(CluID)
    subplot(6,6,i)
    bar(t,out(:,i,i)); title(['cluster ' num2str(CluID(i))]); xlim([min(t) max(t)]);
end
clear CluID BinSize HalfBins out t fignum h i


%% Save
cd(StructInfo.DataFolder)
aps_Save2