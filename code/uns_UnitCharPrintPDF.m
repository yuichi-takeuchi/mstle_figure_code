% MSOptogeneticss paper FigureS (Fg_599), Unit charactorization
%(c) Yuichi Takeuchi 2017, 2018
%% StructInfo
%% UnitChar_UnitChar
UnitCharInfo = struct(...
    'matfilenamebase', 'FigureS_Fg_599_DataSum',...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', 'C:\Users\Lenovo\Dropbox\Scrivener\MSOptogenetics\Figures\FigureS_Fg_599\Graphs'...
    );

%% Move to Matlab folder
cd(UnitCharInfo.MatlabFolder)

%% Move to data folder
cd(UnitCharInfo.DataFolder)

%% Load
cd(UnitCharInfo.DataFolder)
disp('loading variables...'); tic
load('FigureS_Fg_599_DataSum.mat')
disp('done'); toc

%% Recording list
RecList = fieldnames(UnitSum);
for i = 1:length(RecList)
    disp([num2str(i) ': ' RecList{i}])
end
clear i

%% Unit Info
recID = 5;
UnitInfo = UnitSum.(RecList{recID});

%% Unit char automatic
% This function gives a summary figure of the unit and prints and pdf of
% the figure
CluID = 13; % not a record number
numRec = [UnitInfo.CluID] == CluID;
close all
fignum = 1; 
[ hstruct ] = unf_UnitCharactorization1( UnitInfo, numRec, fignum );

clear hstruct CluID fignum

%% Save
disp('loading variables...'); tic
save([StructInfo.matfilenamebase '.mat'], '-v7.3');
disp('done'); toc
