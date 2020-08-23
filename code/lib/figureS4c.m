function figureS4c()
% Copyright (c) 2017–2020 Yuichi Takeuchi

%% data import
load('../data/FigureS4_Fg_599_DataSum.mat')

%% Recording list
RecList = fieldnames(UnitSum);
for i = 1:length(RecList)
    disp([num2str(i) ': ' RecList{i}])
end

%% Unit Info
recID = 7;
UnitInfo = UnitSum.(RecList{recID});

%% Unit char automatic
% This function gives a summary figure of the unit and prints and pdf of
% the figure
CluID = 7; % not a record number
numRec = [UnitInfo.CluID] == CluID;
close all
fignum = 1; 
[ hstruct ] = unf_UnitCharactorization1( UnitInfo, numRec, fignum, 'figureS4c');
close all
disp('done')

end
