function [ Mean, Std, Sem, Prctile ] = stats_Summary3( srcVec1, srcVec2 )
%
% [ Mean, Std, Sem, Prctile ] = stats_Summary3( srcVec1, srcVec2 )
%
% caluculation arong column
%   
% Copyright (C) Yuichi Takeuchi 2019
%

srcVec1 = srcVec1(:);
srcVec2 = srcVec2(:);

Mean = zeros(1, 2);
Std = zeros(1, 2);
Sem = zeros(1, 2);
Prctile = zeros(7, 2);

Mean(1) = mean(srcVec1);
Std(1) = std(srcVec1);
Sem(1) = sem(srcVec1);
Prctile(:,1) = prctile(srcVec1, [0 10 25 50 75 90 100]);

Mean(2) = mean(srcVec2);
Std(2) = std(srcVec2);
Sem(2) = sem(srcVec2);
Prctile(:,2) = prctile(srcVec2, [0 10 25 50 75 90 100]);
