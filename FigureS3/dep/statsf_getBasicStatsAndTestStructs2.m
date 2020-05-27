function [ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs2( srcVec1, srcVec2 )
%
% This function returns structures containing results of discriptive
% statistics and statistical tests.
% 
% Usage:
%   [ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs2( srcVec1, srcVec2 )
%
% INPUTS:
%    srcVec1,2 (vector): data with independent values
% OUTPUT:
%    sBasicStats: Cell vector, each element of which contains
%    sStatsTest: structure for statistical tests
%
% Copyright (c) Yuichi Takeuchi 2019
%
    
% calculating basic statistics
[ Mean, Std, Sem, Prctile ] = stats_Summary3( srcVec1, srcVec2 );
sBasicStats.Mean = Mean;
sBasicStats.Std = Std;
sBasicStats.Sem = Sem;
sBasicStats.Prctile = Prctile;

% statistical test
sStatsTest.TTest2 = stats_BuildStructTTest2(srcVec1, srcVec2);
sStatsTest.RankSum = stats_BuildStructRankSum(srcVec1, srcVec2);
sStatsTest.KSTest2 = stats_BuildStructKSTest2(srcVec1, srcVec2);

end


