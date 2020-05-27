function [ Mean, Std, Sem, Prctile ] = stats_Summary1( srcMat )
%
% [ Mean, Std, Sem, Prctile ] = stats_Summary1( srcMat )
%
% caluculation arong column
%   
% Copyright (C) Yuichi Takeuchi 2017
%

Mean = mean(srcMat);
Std = std(srcMat);
Sem = sem(srcMat);
Prctile = prctile(srcMat, [0 10 25 50 75 90 100]);

end

