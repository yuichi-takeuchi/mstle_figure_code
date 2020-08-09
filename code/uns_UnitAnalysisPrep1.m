% uns_UnitAnalysisPrep1.m
% Unit analyse preparation1 (with sine wave and square wave stimuli, and
% digital channel labelings)
% (C) Yuichi Takeuchi 2017
%% Organize RecInfo structure
date = 170630;
expnum = 3;
shankID = 0;
datfilenamebase = ['AP_' num2str(date) '_exp' num2str(expnum)];
RecInfo = struct(...
    'date', date,...
    'expnum', expnum,...
    'shankID', shankID,...
    'datfileID', str2num(['uint64(' num2str(date) num2str(expnum,'%02i') num2str(shankID, '%02i') ')']),...
    'datfilenamebase', datfilenamebase,...
    'concadatfilenamebase', [datfilenamebase '_shk' num2str(shankID)],...
    'nChannels', 32,... % without stimwave and digital channel
    'StimWaveCh', 1,...
    'DigitalCh', 1,...
    'sr', 20000,...
    'srDown', 1250,...
    'ProbeName', 'Poly2_H32',...
    'StimLabel', 'Camkiia-iC++',...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['D:\Research\Data\LongTermRec1\LTRec1_42\170630\concatenated' num2str(expnum)]...
    );

clear date expnum shankID datfilenamebase

%% Move to Matlab folder
cd(RecInfo.MatlabFolder)

%% Move to data folder
cd(RecInfo.DataFolder)

%% Organize DatInfo structure (just inputs)
DatFileIndex = 1:2;
stimlabel = {2 1}; % 0: none, 1: sine, 2: square
stimIntensity = {3 3}; % mW
numTrials = [20 20]; % 1: sine, 2: square
StimHzSine = [1 4 8 12 20];
StimHzSquare = [1 5 10 20 40];
pulseWidth = [0 0.01]; % s
minCycle = [10 20]; % (none, sine, square)
minTime = [10 5];
latency = [0 0]; % s
afterPause = [3 3]; % s

% preallocation of structure
Network = struct(...
    'Delta', [],...
    'Theta', [],...
    'Beta', [],...
    'LowGamma', [],...
    'MidGamma', [],...
    'HighGamma', []);
DatInfo = struct(...
    'datfileID', RecInfo.datfileID,...
    'datfilename', '',...
    'offset', [],...
    'numpnts', [],...
    'stimlabel', stimlabel,...
    'stimIntensity', stimIntensity,...
    'StimHz', [],...
    'numTrials', [],...
    'pulseWidth', [],...
    'minCycle', [],...
    'minTime', [],...
    'latency', [],...
    'afterPause', [],...
    'stimwavename', '',...
    'digwavename', '',...
    'PreStimTimestampRF', [],...
    'StimTimestampRF', [],...
    'SineStimPhaseDS', [],...
    'SquareStimOnsetTS', [],...
    'NetworkPhase', Network...
    );

for i = DatFileIndex
    DatInfo(i).datfilename = [RecInfo.datfilenamebase '_' num2str(i) '_shk' num2str(RecInfo.shankID) '.dat'];
    infoFile = dir([DatInfo(i).datfilename]);
    nSamples = floor(infoFile.bytes/(RecInfo.nChannels*2));
    if i == 1
        DatInfo(i).offset = 0;
    else
        DatInfo(i).offset = DatInfo(i-1).offset + DatInfo(i-1).numpnts;
    end
    DatInfo(i).numpnts = nSamples;
%     DatInfo(i).stimlabel = stimlabel(i);
%     DatInfo(i).stimIntensity = stimIntensity(i);
    switch stimlabel{i}
        case 1 % sine wave stimuli
            DatInfo(i).numTrials = numTrials(1);
            DatInfo(i).StimHz = StimHzSine;
            DatInfo(i).pulseWidth = pulseWidth(1);
            DatInfo(i).minCycle = minCycle(1);
            DatInfo(i).minTime = minTime(1);
            DatInfo(i).latency = latency(1);
            DatInfo(i).afterPause = afterPause(1);
        case 2 % square wave stimuli
            DatInfo(i).numTrials = numTrials(2);
            DatInfo(i).StimHz = StimHzSquare;
            DatInfo(i).pulseWidth = pulseWidth(2);
            DatInfo(i).minCycle = minCycle(2);
            DatInfo(i).minTime = minTime(2);
            DatInfo(i).latency = latency(2);
            DatInfo(i).afterPause = afterPause(2);
        otherwise
    end
    DatInfo(i).stimwavename = [RecInfo.datfilenamebase '_' num2str(i) '_stim.dat'];
    DatInfo(i).digwavename = [RecInfo.datfilenamebase '_' num2str(i) '_dig.dat'];
end

clear DatFileIndex stimlabel StimHzSine StimHzSquare numTrials minCycle minTime latency afterPause stimPulseWidth i infoFile
clear nSamples pulseWidth stimIntensity Network

%% ...analysis of digital and stimulus waves
% sine, square stim data analyses
disp('Starting stim data analysis...'); tic
h = waitbar(0,'analyzing stim channels...');
for i = 1:length(DatInfo)
    waitbar(i/length(DatInfo));
    mg = memmapfile(DatInfo(i).digwavename, 'format', 'int16');
    digch = mg.data';
    ms = memmapfile(DatInfo(i).stimwavename, 'format', 'int16');
    stimch = ms.data';
    for j = 1:length(DatInfo(i).StimHz)
        [~,tempR,tempF] = ssf_FindConsecutiveTrueChunks(digch == 2*j-1);
        tempRF = uint64([tempR' tempF']);
        if size(tempRF,1) ~= DatInfo(i).numTrials
            tempRF(1,:) = [];
        end
        tempRF = mat2cell(tempRF,ones(DatInfo(i).numTrials,1),2);
        tempRF = reshape(tempRF, 1, DatInfo(i).numTrials);
        DatInfo(i).PreStimTimestampRF = cat(1,DatInfo(i).PreStimTimestampRF, tempRF);
        [~,tempR,tempF] = ssf_FindConsecutiveTrueChunks(digch == 2*j);
        tempRF = uint64([tempR' tempF']);
        if size(tempRF,1) > DatInfo(i).numTrials
            tempRF(1,:) = [];
        end
        tempRF = mat2cell(tempRF,ones(DatInfo(i).numTrials,1),2);
        tempRF = reshape(tempRF, 1, DatInfo(i).numTrials);
        DatInfo(i).StimTimestampRF = cat(1, DatInfo(i).StimTimestampRF, tempRF);
        for k = 1:DatInfo(i).numTrials
            si = DatInfo(i).StimTimestampRF{j,k}(1);
            ei = DatInfo(i).StimTimestampRF{j,k}(2);
            stimchcut = stimch(si:ei);
            switch DatInfo(i).stimlabel
                case 1  % sine wave stimuli
                    % instantaneous phase of stim wave (sine)
                    tempSine = double(stimchcut);
                    y = hilbert(tempSine);
                    tempPhaseV = angle(y) + pi;
                    DatInfo(i).SineStimPhaseDS{j,k} = tempPhaseV(1:floor(RecInfo.sr/RecInfo.srDown):end);
                case 2  % square wave stimuli
                    % detection of each square pulses
                    [~,tempR,~] = ssf_FindConsecutiveTrueChunks(stimchcut > 1000);
                    tempR = uint64(tempR) + si;
                    DatInfo(i).SquareStimOnsetTS{j,k} = tempR;
                otherwise
            end
        end
    end
end
close(h)
disp('Stim analysis done.'); toc
clear j mg digch tempR tempF tempRF k ms stimch tempSine y tempPhaseV si ei i stimchcut h

%% ...analysis of intrinsic LFP phase
disp('Starting LFP phase analysis...'); tic
CField = fieldnames(DatInfo(1).NetworkPhase);
FreqTb = [1,4;4,12;12,30;30,45;45,80;80,300];
h = waitbar(0,'analyzing instantaneous phases...');
for i = 1:length(DatInfo)
    waitbar(i/length(DatInfo));
    m = memmapfile(DatInfo(i).datfilename, 'format', 'int16');
    data = reshape(m.data, RecInfo.nChannels,[]);
    for j = 1:length(DatInfo(i).StimHz)
        for k = 1:DatInfo(i).numTrials
            fprintf('StimHz %d, Trial %d\n', j, k)
            si = DatInfo(i).PreStimTimestampRF{j,k}(1);
            ei = DatInfo(i).PreStimTimestampRF{j,k}(2);
%             segmentDs = data(:,si:floor(RecInfo.sr/RecInfo.srDown):ei);
            segmentData = data(:,si:ei);
            mSegData = mean(segmentData);
            for l = 1:numel(CField)
                mSegDataM = filtf_LowPassButter3(mSegData, FreqTb(l,2), 3, RecInfo.srDown);
                FltdLFP = filtf_HighPassButter3(mSegDataM, FreqTb(l,1), 3, RecInfo.srDown);
                y = hilbert(FltdLFP);
                tempPhaseV = angle(y) + pi;
                tempPhaseVDs = tempPhaseV(1:floor(RecInfo.sr/RecInfo.srDown):end);
                DatInfo(i).NetworkPhase.(CField{l}){j,k} = tempPhaseVDs;
%                 fprintf('DatInfo(%d), %s\n', i, CField{l})
%                 figure(1);histogram(tempPhaseV)
%                 pause(1)
            end
        end
    end
end
close(h)
disp('intrinsic phase analysis done.'); toc
clear h i j k si ei segmentData mSegData mSegDataM FltdLFP y tempPhaseV tempPhaseVDs m data CField FreqTb l

%% Organizing KlustaInfo structure
KlustaInfo = struct(...
    'datfileID', RecInfo.datfileID,...
    'Timestamp', [],...
    'Cluster', [],...
    'numpnts', []);

% Extracting Timestamp and Cluster
[Timestamp, Cluster] = ssf_ReadKwik(RecInfo.concadatfilenamebase, RecInfo.shankID);
KlustaInfo.Timestamp = Timestamp;
KlustaInfo.Cluster = Cluster;

% Making Clu and Res files
ssf_MakeCluRes(RecInfo.concadatfilenamebase, Cluster, Timestamp, RecInfo.shankID);

% numpnts
infoFile = dir([RecInfo.concadatfilenamebase '.dat']);
KlustaInfo.numpnts = floor(infoFile.bytes/(RecInfo.nChannels*2));

clear Timestamp Cluster infoFile

%% Organizing KlustaFeature structure
KlustaFeature = struct(...
    'datfileID', RecInfo.datfileID,...
    'PC', [],...
    'EV', []);

% extraction of feature
disp('Exracting feature...'); tic
[Feature] = ssf_ReadKwd(RecInfo.concadatfilenamebase, RecInfo.shankID);
disp('done'); toc

% principal component analysis
disp('PCA...'); tic
[ PC, EV ] = ssf_Feature2PC( Feature );
KlustaFeature.PC = PC;
KlustaFeature.EV = EV;
disp('done'); toc

clear Feature PC EV

%% Organizing UnitInfo
% initialization
CluNum = nnz(unique(KlustaInfo.Cluster) > 1); % number of isolated units
CluID = num2cell(2:(CluNum+1));
Channel = struct(...
    'Best', [],... % substructure definitions
    'Range', []);
Waveform = struct('Average', [],...
    'Std', []);
WaveformFet = struct(...
    'Trough2PeakTime', [],...
    'Trough2PeakRatio', [],...
    'HalfWidth', []);
FR = struct(...
    'PreSine', [],...
    'SineStim', [],...
    'PreSquare', [],...
    'SquareStim',[],...
    'SineMI', [],...
    'SquareMI',[]);
StimModTag = struct(...
    'SineBase', [],...
    'SinePhase', [],...
    'SquareBase', [],...
    'PSTHExc', [],...
    'PSTHInh', [],...
    'ACG', []);
NetworkHist = struct(...
    'Delta', [],...
    'Theta', [],...
    'Beta', [],...
    'LowGamma', [],...
    'MidGamma', [],...
    'HighGamma', []);
ACG = struct(...
    'Baseline', [],...
    'Stimulated', [],...
    'Time', []);
PSTH = struct(...
    'Each', [],...
    'Sum', [],...
    'Time', []);
StimCircHist = struct(...
    'Count', [],...
    'Intensity', [],...
    'Hz', []);
UnitInfo = struct(...   % destination structure
    'datfileID', RecInfo.datfileID,... 
    'StimLabel', RecInfo.StimLabel,...
    'CluID', CluID,...
    'Channel', Channel,...
    'Waveform', Waveform,...
    'WaveformFet', WaveformFet,...
    'BaseFRMean', [],...
    'BaseFRStd', [],...
    'FR', FR,...
    'NetworkSignif', false(1,6),...
    'NetworkMI', zeros(1,6),...
    'NetworkHist', NetworkHist,...
    'StimSignif', false(1,6),...
    'StimModTag', StimModTag,...
    'StimMI', [zeros(1,5) NaN],...
    'PSTH', PSTH,...
    'StimCircHist', StimCircHist,...
    'ACG', ACG,...
    'Type', []...
    );
    
clear CluNum CluID Channel Waveform WaveformFet FR StimModTag NetworkHist ACG PSTH StimCircHist

%% ...getting waveforms
a = dir([RecInfo.concadatfilenamebase '.res.*']);
[spiket, spikeind, numclus, ~, ~] = ReadEl4CCG(RecInfo.concadatfilenamebase,0:size(a,1)-1);
h = waitbar(0, 'getting waveforms');  tic
for i = 1:numclus
    waitbar(i/numclus);
    disp(i)
    [UnitInfo(i).Waveform.Average, UnitInfo(i).Waveform.Std, ~] = TriggeredAvMdetrend(RecInfo.concadatfilenamebase, spiket(spikeind == i), [1.5 1.5], RecInfo.sr, RecInfo.nChannels, 1,'dat');
end
close(h); disp('done'); toc
clear i numclus spiket spikeind a h

%% ...Basic charactorization of Units
% Channels (Best, Range)
disp('Basic charactorization of Units...')
nChannels = size(UnitInfo(1).Waveform.Average,2);
for i = 1:length(UnitInfo)
    [minValue, ~] = min(UnitInfo(i).Waveform.Average);
    [~, BestCh] = min(minValue);
    if BestCh < 5
        Range = 1:8;
    elseif BestCh > (nChannels - 4)
        Range = (nChannels - 7):nChannels;
    else
        Range = (BestCh - 3):(BestCh + 4);
    end
    
    UnitInfo(i).Channel.Best = BestCh;
    UnitInfo(i).Channel.Range = Range;
end
clear nChannels i BestCh Range 

% Wavewaveform Features
for i = 1:length(UnitInfo)
    BestCh = UnitInfo(i).Channel.Best;
    BestAvgWaveform = UnitInfo(i).Waveform.Average(:,BestCh);
    [minValue, minIndex] = min(BestAvgWaveform);
    [maxValue, maxIndex] = max(BestAvgWaveform);
    baseValue = mean(BestAvgWaveform(1:10));
    Trough2PeakTime = maxIndex - minIndex;
    Trough2PeakRatio = abs((minValue - baseValue)/(maxValue - baseValue));
    indexwave = BestAvgWaveform < baseValue + (minValue - baseValue)/2;
    HalfWidth = length(find(indexwave));
    
    UnitInfo(i).WaveformFet.Trough2PeakTime = Trough2PeakTime;
    UnitInfo(i).WaveformFet.Trough2PeakRatio = Trough2PeakRatio;
    UnitInfo(i).WaveformFet.HalfWidth = HalfWidth;
end
clear i BestCh BestAvgWaveform minValue minIndex maxValue maxIndex baseValue
clear Trough2PeakTime Trough2PeakRatio indexWave HalfWidth indexwave
disp('done.')

%% ...getting Firing rates of specific periods (StimModTag Indexes of Sine and Square Periods)
% PeriStimIimestamp
disp('getting Firing rates of specific periods...')
Cluster = KlustaInfo.Cluster;
Timestamp = KlustaInfo.Timestamp;
CluID = [UnitInfo.CluID];
sr = RecInfo.sr;
for i = 1:length(DatInfo)
    offset = DatInfo(i).offset;
%     stimLabel = DatInfo(i).stimlabel;
    PreTimestampRF = DatInfo(i).PreStimTimestampRF;
    StimTimestampRF = DatInfo(i).StimTimestampRF;
    for j = 1:length(DatInfo(i).StimHz)
        for k = 1:(DatInfo(i).numTrials)
            sip = PreTimestampRF{j,k}(1,1) + offset;
            eip = PreTimestampRF{j,k}(1,end) + offset;
            IndexwavePre = Timestamp >= sip & Timestamp <= eip;
            npntsp = double(eip - sip + 1);
            sis = StimTimestampRF{j,k}(1,1) + offset;
            eis = StimTimestampRF{j,k}(1,end) + offset;
            IndexwaveStim = Timestamp >= sis & Timestamp <= eis;
            npntss = double(eis - sis + 1);
            FiringRatePre = unf_CalcFiringRate(Cluster(IndexwavePre),Timestamp(IndexwavePre),CluID,npntsp,sr);
            FiringRateStim = unf_CalcFiringRate(Cluster(IndexwaveStim),Timestamp(IndexwaveStim),CluID,npntss,sr);
            for l = 1:length(CluID)
                switch DatInfo(i).stimlabel
                    case 1
                        UnitInfo(l).FR.PreSine{i}(j,k) = FiringRatePre(l);
                        UnitInfo(l).FR.SineStim{i}(j,k) = FiringRateStim(l);
                    case 2
                        UnitInfo(l).FR.PreSquare{i}(j,k) = FiringRatePre(l);
                        UnitInfo(l).FR.SquareStim{i}(j,k) = FiringRateStim(l);
                    otherwise
                end
            end
        end            
    end
end
clear Cluster Timestamp i j k l offset PreTimestampRF StimTimestampRF sip eip sis eis IndexwavePre IndexwaveStim CluID npntsp npntss sr
clear FiringRatePre FiringRateStim
disp('done.')

%% ...doing firing rate analysis
% Firing rate analysis
CluID = [UnitInfo.CluID];
indIntSine = find(~cellfun(@isempty, UnitInfo(1).FR.PreSine));
numIntSine = numel(indIntSine);
indIntSquare = find(~cellfun(@isempty, UnitInfo(1).FR.PreSquare));
numIntSquare = numel(indIntSquare);
for i = 1:length(UnitInfo)  % firing rate and significance
    disp(['Firing rate calculation: CluID ' num2str(CluID(i))])
    % collecting and analyzing firing rate data
    % sine wave stimuli
    FRSineBase = [];
    TrueTable = [];
    MISine = [];
    for j = indIntSine
        PreMat = UnitInfo(i).FR.PreSine{j};
        StimMat = UnitInfo(i).FR.SineStim{j};
        TempTrueTable = [];
        numHzSine = size(PreMat,1);
        for k = 1:numHzSine
            h = ttest(PreMat(k,:), StimMat(k,:),'Alpha', 0.05/(numIntSine*numHzSine)); % paired t-test with Bonferroni correction
            TempTrueTable = [TempTrueTable h];
        end           
        FRSineBase = [FRSineBase; PreMat(:)];
        TrueTable = [TrueTable; TempTrueTable];
        PreMean = mean(PreMat, 2);    % modulation index
        StimMean = mean(StimMat, 2);
        tempMI = (StimMean - PreMean)./PreMean;
        UnitInfo(i).FR.SineMI{j} = tempMI;
        MISine = [MISine tempMI];
    end
    UnitInfo(i).StimModTag.SineBase = TrueTable;
    if any(TrueTable)       % StimModTag tag
        UnitInfo(i).StimSignif(1) = true;
    else
        UnitInfo(i).StimSignif(1) = false;
    end
    UnitInfo(i).StimMI(1) = mean(MISine(:));
    
    % square wave stimuli
    FRSquareBase = [];
    TrueTable = [];
    MISquare = [];
    for j = indIntSquare
        PreMat = UnitInfo(i).FR.PreSquare{j};
        StimMat = UnitInfo(i).FR.SquareStim{j};
        TempTrueTable = [];
        numHzSquare = size(PreMat,1);
        for k = 1:size(PreMat,1)
            h = ttest(PreMat(k,:), StimMat(k,:),'Alpha', 0.05/(numIntSquare*numHzSquare)); % paired t-test with Bonferroni correction
            TempTrueTable = [TempTrueTable h];
        end
        FRSquareBase = [FRSquareBase; PreMat(:)];
        TrueTable = [TrueTable; TempTrueTable];
        PreMean = mean(PreMat, 2);    % modulation index
        StimMean = mean(StimMat, 2);
        tempMI = (StimMean - PreMean)./PreMean;
        UnitInfo(i).FR.SquareMI{j} = tempMI;
        MISquare = [MISquare tempMI];
    end
    UnitInfo(i).StimModTag.SquareBase = TrueTable;
    if any(TrueTable)       % StimModTag tag
        UnitInfo(i).StimSignif(3) = true;
    else
        UnitInfo(i).StimSignif(3) = false;
    end
    UnitInfo(i).StimMI(3) = mean(MISquare(:));
    
    UnitInfo(i).BaseFRMean = mean([FRSineBase;FRSquareBase]);
    UnitInfo(i).BaseFRStd = std([FRSineBase;FRSquareBase]);
end
disp('done.')
clear i j FRSineBase FRSineStim FRSquareBase FRSquareStim h k PreMat StimMat TempTrueTable TrueTable
clear CluID MISine MISquare PreMean StimMean tempMI indIntSine indIntSquare numHzSine numHzSquare numIntSine numIntSquare

%% ...getting Auto correlograms
disp('getting Auto correllograms...');tic
% getting indexes
Cluster = KlustaInfo.Cluster;
Timestamp = KlustaInfo.Timestamp;
IndexBase = Timestamp < 0;
IndexStim = Timestamp < 0;
for i = 1:length(DatInfo)
    offset = DatInfo(i).offset;
    PreTimestampRF = DatInfo(i).PreStimTimestampRF;
    StimTimestampRF = DatInfo(i).StimTimestampRF;
    for j = 1:length(DatInfo(i).StimHz)
        for k = 1:(DatInfo(i).numTrials)
            sip = PreTimestampRF{j,k}(1,1) + offset;
            eip = PreTimestampRF{j,k}(1,end) + offset;
            IndexwavePre = Timestamp >= sip & Timestamp <= eip;
            IndexBase = IndexBase | IndexwavePre;
            sis = StimTimestampRF{j,k}(1,1) + offset;
            eis = StimTimestampRF{j,k}(1,end) + offset;
            IndexwaveStim = Timestamp >= sis & Timestamp <= eis;
            IndexStim = IndexStim | IndexwaveStim;
        end            
    end
end
clear i offset PreTimestampRF StimTimestampRF j k sip eip sis eis IndexwavePre IndexwaveStim

% CCG
BinSize = 20; % 1 ms
HalfBins = 50; % 50 ms
sr = RecInfo.sr; % 20000 Hz
CluID = [UnitInfo.CluID];
[outb, t, ~, ~ ] = CCG(double(Timestamp(IndexBase)), Cluster(IndexBase), BinSize, HalfBins, sr, CluID, 'count', []);
[outs, t, ~, ~ ] = CCG(double(Timestamp(IndexStim)), Cluster(IndexStim), BinSize, HalfBins, sr, CluID, 'count', []);
for i = 1:length(UnitInfo)
    disp(['ACG calculation: CluID ' num2str(CluID(i))])
    UnitInfo(i).ACG.Baseline = outb(:,i,i);
    UnitInfo(i).ACG.Stimulated = outs(:,i,i);
    UnitInfo(i).ACG.Time = t(:);
    ISIbase = unf_InterSpikeIntervals(Timestamp(IndexBase & Cluster == CluID(i)), BinSize, HalfBins);
    ISIstim = unf_InterSpikeIntervals(Timestamp(IndexStim & Cluster == CluID(i)), BinSize, HalfBins);
    if(~isempty(ISIbase) && ~isempty(ISIstim))
        h = kstest2(ISIbase, ISIstim, 'Alpha', 0.01);
    else
        h = false;
    end
    
    UnitInfo(i).StimModTag.ACG = h;
    UnitInfo(i).StimSignif(6) = h;
    UnitInfo(i).StimMI(6) = NaN;
end
disp('done.');toc

clear i BinSize CluID Cluster Timestamp h HalfBins IndexBase IndexStim ISIbase ISIstim outb outs sr t

%% ...doing PTSH analysis
% getting timestamps of square pulses
disp('PTSH analsysis...'); tic;
stimlabel = [DatInfo.stimlabel];
Intensity = unique([DatInfo(stimlabel == 2).stimIntensity]);
StimHz = unique(cell2mat({DatInfo(stimlabel == 2).StimHz}));
StimHz = StimHz(StimHz <= 50);
SquareStimTS = cell(length(Intensity), length(StimHz));

for i = find(stimlabel == 2) % getting square pulse timestamps
    offset = DatInfo(i).offset;
    for j = 1:size((DatInfo(i).SquareStimOnsetTS),1)
        tempIntensity = DatInfo(i).stimIntensity;
        tempStimHz = DatInfo(i).StimHz(j);
        if ~any(StimHz == tempStimHz)
            continue
        end
        tempTS = cell2mat({DatInfo(i).SquareStimOnsetTS{j,:}}) + offset;
        ri = Intensity == tempIntensity;
        ci = StimHz == tempStimHz;
        SquareStimTS{ri,ci} = tempTS;
    end
end
clear offset tempIntensity tempStimHz tempTS ri ci i j 

% CCG
CluID = [UnitInfo.CluID];
Cluster = KlustaInfo.Cluster;
Timestamp = KlustaInfo.Timestamp;
BinSize = 20; % 1 ms
HalfBins = 50; % 50 ms
sr = RecInfo.sr; % 20000 Hz
tempCCG = cell(size(SquareStimTS,1),size(SquareStimTS,2));
PSTHID = CluID(end)+1;
CluIDPlus = [CluID PSTHID];
ClusterPlus = Cluster;
TimestampPlus = Timestamp;
for i = 1:size(SquareStimTS,1)  % getting CCG table
   for j = 1:size(SquareStimTS,2)
       TimestampPlusTemp = [Timestamp; SquareStimTS{i,j}(:)];
       TimestampPlus = [TimestampPlus; SquareStimTS{i,j}(:)];
       nSquarePulses = length(SquareStimTS{i,j});
       ClusterPlusTemp = [Cluster; ones(nSquarePulses,1)*PSTHID];
       ClusterPlus = [ClusterPlus; ones(nSquarePulses,1)*PSTHID];
       [out, t, ~, ~ ] = CCG(double(TimestampPlusTemp), ClusterPlusTemp, BinSize, HalfBins, sr, CluIDPlus, 'count', []);
       tempCCG{i,j} = out;
   end
   tempt = t;
end

StimHzLess = StimHz(StimHz <= 10);
for i = 1:length(UnitInfo)  % taking relationship between stimulus and spike timestamps
    UnitInfo(i).PSTH.CCGEach = cell(size(tempCCG,1),size(tempCCG,2));
    UnitInfo(i).PSTH.CCGAll = zeros(size(tempt,2),size(tempt,1));
    UnitInfo(i).PSTH.Sum = zeros(size(tempt,2),size(tempt,1));
    for j = 1:numel(tempCCG)
        UnitInfo(i).PSTH.CCGEach{j} = tempCCG{j}(:,end,i);
        UnitInfo(i).PSTH.CCGAll = UnitInfo(i).PSTH.CCGAll + tempCCG{j}(:,end,i);
        if j < size(tempCCG,1)*length(StimHzLess)
            UnitInfo(i).PSTH.CCGR = UnitInfo(i).PSTH.CCGAll + tempCCG{j}(:,end,i);
        end
    end
    UnitInfo(i).PSTH.Time = tempt;
end

StimTimestampRFOffset = [];
for i = find(stimlabel == 2) % getting StimTimestampRFOffset
    for j = find(DatInfo(i).StimHz <= 10)
        for k = 1:DatInfo(i).numTrials
           StimTimestampRFOffset = [StimTimestampRFOffset; [DatInfo(i).StimTimestampRF{j,k} DatInfo(i).offset]];
        end
    end
end

hw = waitbar(0);
lngth = length(UnitInfo);
for i = 1:length(UnitInfo) % statistical test and modulation index
    waitbar(i/lngth);
    % surrogation (shuffle and pointwise and global significanse lines)
    [~,ccgR,ccgSM,pt,gb,GSPExc,GSPInh] = unf_CCG_shuffle(TimestampPlus,ClusterPlus,PSTHID,CluID(i),StimTimestampRFOffset,BinSize,HalfBins);
    UnitInfo(i).PSTH.CCGMean = ccgSM;
    UnitInfo(i).PSTH.Global = gb(1,:);
    UnitInfo(i).PSTH.Local = pt;
    UnitInfo(i).PSTH.GBSignifE = GSPExc;
    UnitInfo(i).PSTH.GBSignifI = GSPInh;
    h = any(GSPExc(1+HalfBins:end));    % significance
    UnitInfo(i).StimModTag.PSTHExc = h;
    UnitInfo(i).StimSignif(4) = h;
    h = any(GSPInh(1+HalfBins:end));    % significance
    UnitInfo(i).StimModTag.PSTHInh = h;
    UnitInfo(i).StimSignif(5) = h;
    gbMean = mean(ccgSM);
    UnitInfo(i).StimMI(4) = (max(ccgR) - gbMean)/gbMean;
    UnitInfo(i).StimMI(5) = (min(ccgR) - gbMean)/gbMean;
end
close(hw)
disp('done.'); toc;

clear i j k BinSize CluID CluIDPlus Cluster ClusterPlus ClusterPlusTemp HalfBins nSquarePulses out PSTHID SquareStimTS sr
clear tempCCG  tempt Timestamp TimestampPlus TimestampPlusTemp ccgR ccgSM gb GSPExc GSPInh h hw Intensity
clear lngth StimHz StimHzLess stimlabel t StimTimestampRFOffset pt gbMean

%% ...getting Stimulus phase modulation
% Preparing histogram on each stimulus and each frequency and trials
disp('stimulus phase analsysis...'); tic;
stimlabel = [DatInfo.stimlabel];
unqIntensity = unique([DatInfo(stimlabel == 1).stimIntensity]);
unqStimHz = unique(cell2mat({DatInfo(stimlabel == 1).StimHz}));
Cluster = KlustaInfo.Cluster;
Timestamp = KlustaInfo.Timestamp;
lngthInt = length(unqIntensity);
lngthHz = length(unqStimHz);
StimCircHistCell = cell(lngthInt,lngthHz);
StimCircHistInt = repmat(unqIntensity',1,lngthHz);
StimCircHistHz = repmat(unqStimHz, lngthInt, 1);
for i = 1:length(UnitInfo)
    UnitInfo(i).StimCircHist.Count = StimCircHistCell;
    UnitInfo(i).StimCircHist.Intensity = StimCircHistInt;
    UnitInfo(i).StimCircHist.Hz = StimCircHistHz;
end
for i = find(stimlabel == 1)
    offset = DatInfo(i).offset;
    intensity = DatInfo(i).stimIntensity;
    StimHz = DatInfo(i).StimHz;
    for j = 1:length(StimHz)
        PhaseStacked = [];
        CluStacked = [];
        for k = 1:DatInfo(i).numTrials
            si = DatInfo(i).StimTimestampRF{j,k}(1) + offset;
            ei = DatInfo(i).StimTimestampRF{j,k}(2) + offset;
            index1 = Timestamp > si & Timestamp < ei;
            Clu = Cluster(index1);
            CluStacked = [CluStacked; Clu];
            AlignedRes = Timestamp(index1) - si + 1;
            HighResTS = double(1:(ei - si + 1));
            SineStimPhaseDS = double(DatInfo(i).SineStimPhaseDS{j,k});
            [ InstantaneousPhase ] = unf_phaseintp1restoration( HighResTS, SineStimPhaseDS, AlignedRes );
            PhaseStacked = [PhaseStacked, InstantaneousPhase];
        end
        intensityIndex = unqIntensity == intensity;
        stimHzIndex = unqStimHz == StimHz(j);

        for l = 1:length(UnitInfo)
            CluID = UnitInfo(l).CluID;
            index2 = CluStacked == CluID;
            Phase = PhaseStacked(index2);
            edges = linspace(0, 2*pi, 360);
            [N, edges] = histcounts(Phase,edges);
            UnitInfo(l).StimCircHist.Count{intensityIndex, stimHzIndex} = [[N 0];edges];
        end
    end
end
toc;
clear AlignedRes Clu CluID CluStacked Cluster count StimCircHistCell lngthInt lngthHz StimCircHistInt StimCircHistHz

% Rayleigh test for statistical significance
CluID = [UnitInfo.CluID];
for i = 1:length(UnitInfo)  % modulation index and significance
    disp(['modulation index and significance test: CluID ' num2str(CluID(i))])
    TempTrueTable = zeros(size(UnitInfo(i).StimCircHist.Count));
    TempMIPhase = zeros(size(UnitInfo(i).StimCircHist.Count));
    numOfComparison = numel(TempTrueTable);
    for j = 1:length(unqIntensity)
        for k = 1:length(unqStimHz)
            OrigCount = UnitInfo(i).StimCircHist.Count{j,k}(1,:); % Rayleigh test
            OrigAngle = UnitInfo(i).StimCircHist.Count{j,k}(2,:);
            [pval, ~] = circ_rtest(OrigAngle, OrigCount);
            if pval < 0.05/numOfComparison   % Bonferroni correction
                TempTrueTable(j,k) = 1;
            end
            Count = sum(reshape(OrigCount, 20, 18)); % modulation index
            meanCount = mean(Count,2);
            [maxCount, ~] = max(Count);
            [minCount, ~] = min(Count);
            if abs(maxCount - meanCount) > abs(minCount - meanCount)
                diffCount = maxCount - meanCount;
            else
                diffCount = minCount - meanCount;
            end
            TempMIPhase(j,k) = abs(diffCount/meanCount);
        end
    end
    
    UnitInfo(i).StimModTag.SinePhase = TempTrueTable;
    if any(TempTrueTable)       % StimModTag tag
        UnitInfo(i).StimSignif(2) = true;
    else
        UnitInfo(i).StimSignif(2) = false;
    end
    
    UnitInfo(i).StimMI(2) = mean(TempMIPhase(:));
end
disp('done.')

clear CluID Count diffCount edges ei HighResTS i index1 index2 InstantaneousPhase intensity
clear intensityIndex j k l maxCount meanCount minCount N offset OrigAngle OrigCount
clear Phase PhaseStacked pval si SineStimPhaseDS SineStimPhaseRS StimHz stimHzIndex
clear stimlabel TempMIPhase TempTrueTable Timestamp unqIntensity unqStimHz z StimCircHistCell numOfComparison

%% ...getting intrinsic phase modulation
% Preparing histogram along non-stimulated phase
disp('intrinsic phase analsysis...'); tic
Cluster = KlustaInfo.Cluster;
Timestamp = KlustaInfo.Timestamp;
CField = fieldnames(UnitInfo(1).NetworkHist);
for i = 1:numel(CField); PhaseStacked.(CField{i}) = []; end
CluStacked = [];
for i = 1:length(DatInfo);
    offset = DatInfo(i).offset;
    StimHz = DatInfo(i).StimHz;
    for j = 1:length(StimHz)
        for k = 1:DatInfo(i).numTrials
            si = DatInfo(i).PreStimTimestampRF{j,k}(1) + offset;
            ei = DatInfo(i).PreStimTimestampRF{j,k}(2) + offset;
            index1 = Timestamp > si & Timestamp < ei;
            Clu = Cluster(index1);
            CluStacked = [CluStacked; Clu];
            AlignedRes = Timestamp(index1) - si + 1;
            HighResTS = double(1:(ei - si + 1));
            for l = 1:numel(CField)
                PhaseDS = double(DatInfo(i).NetworkPhase.(CField{l}){j,k});
                [ InstantaneousPhase ] = unf_phaseintp1restoration( HighResTS, PhaseDS, AlignedRes );
                PhaseStacked.(CField{l}) = [PhaseStacked.(CField{l}), InstantaneousPhase];
            end
        end
    end
end

for i = 1:length(UnitInfo)
    CluID = UnitInfo(i).CluID;
    index2 = CluStacked == CluID;
    for j = 1:numel(CField)
        Phase = PhaseStacked.(CField{j})(index2);
        edges = linspace(0, 2*pi, 360);
        [N, edges] = histcounts(Phase,edges);
        UnitInfo(i).NetworkHist.(CField{j}) = [[N 0];edges];
    end
end
clear AlignedRes Clu CluID CluStacked Cluster edges ei HighResTS i index1 index2 InstantaneousPhase j k l LowResTS
clear N offset Phase si StimHz ThetaPhaseDS ThetaPhaseRS Timestamp PhaseStacked PhaseDS

% Rayleigh test for statistical significance
CluID = [UnitInfo.CluID];
CField = fieldnames(UnitInfo(1).NetworkHist);
for i = 1:numel(CField); PhaseStacked.(CField{i}) = []; end
for i = 1:length(UnitInfo)  % modulation index and significance
    for j = 1:numel(CField)
        disp(['modulation index and significance test: CluID ' num2str(CluID(i))])
        OrigCount = UnitInfo(i).NetworkHist.(CField{j})(1,:); % Rayleigh test
        OrigAngle = UnitInfo(i).NetworkHist.(CField{j})(2,:);
        [pval, ~] = circ_rtest(OrigAngle, OrigCount);
        if pval < 0.05
            UnitInfo(i).NetworkSignif(j) = true;
        else
            UnitInfo(i).NetworkSignif(j) = false;
        end
        Count = sum(reshape(OrigCount, 20, 18)); % modulation index
        meanCount = mean(Count,2);
        [maxCount, ~] = max(Count);
        [minCount, ~] = min(Count);
        if abs(maxCount - meanCount) > abs(minCount - meanCount)
            diffCount = maxCount - meanCount;
        else
            diffCount = minCount - meanCount;
        end
        UnitInfo(i).NetworkMI(j) = abs(diffCount/meanCount);
    end
end
disp('done.');toc
clear CField CluID Count diffCount i maxCount meanCount minCount OrigAngle OrigCount pval j PhaseStacked

%% save mat files
disp('saving variables...'); tic
save([RecInfo.concadatfilenamebase '_RecInfo.mat'], 'RecInfo', '-v7.3')
save([RecInfo.concadatfilenamebase '_DatInfo.mat'], 'DatInfo', '-v7.3')
save([RecInfo.concadatfilenamebase '_KlustaInfo.mat'], 'KlustaInfo', '-v7.3')
save([RecInfo.concadatfilenamebase '_KlustaFeature.mat'], 'KlustaFeature', '-v7.3')
save([RecInfo.concadatfilenamebase '_UnitInfo.mat'], 'UnitInfo', '-v7.3')
disp('done'); toc

%% load variables
disp('loading variables...'); tic
load([RecInfo.concadatfilenamebase '_RecInfo.mat'], 'RecInfo')
load([RecInfo.concadatfilenamebase '_DatInfo.mat'], 'DatInfo')
load([RecInfo.concadatfilenamebase '_KlustaInfo.mat'], 'KlustaInfo')
load([RecInfo.concadatfilenamebase '_KlustaFeature.mat'], 'KlustaFeature')
load([RecInfo.concadatfilenamebase '_UnitInfo.mat'], 'UnitInfo')
disp('done'); toc

%% save m file copy as archive
% cd(RecInfo.MatlabFolder)
copyfile([RecInfo.MatlabFolder '\Yuichi\Unit\uns_UnitAnalysisPrep1.m'],...
    [RecInfo.DataFolder '\' RecInfo.datfilenamebase '_UnitAnalysisPrep1.m']);
disp('done')