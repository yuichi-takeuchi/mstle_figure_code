function [ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( srcTable, VarNames, logicVec )
%
% This function returns structures containing results of discriptive
% statistics and statistical tests.
% 
% Usage:
%   [ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( srcTable, VarNames, logicVec )
%
% INPUTS:
%    srcTable (table): data source table
%    VarNames (cell): variable name list for analysis
%    logicVec (vector): 0 or 1
% OUTPUT:
%    sBasicStats: Cell vector, each element of which contains
%    sStatsTest: structure for statistical tests
%
% (c) Yuichi Takeuchi 2018
%

logicVec = logical(logicVec);

for i = 1:length(VarNames)
    False = srcTable.(VarNames{i})(logicVec == false);
    True  = srcTable.(VarNames{i})(logicVec == true);
    
    % calculating basic statistics
    sBasicStats(i).Variable = VarNames{i};
    [ Mean, Std, Sem, Prctile ] = stats_Summary1( [False True] );
    sBasicStats(i).Mean = Mean;
    sBasicStats(i).Std = Std;
    sBasicStats(i).Sem = Sem;
    sBasicStats(i).Prctile = Prctile;
    
    % statistical test
    sStatsTest(i).Variable = VarNames{i};
    sStatsTest(i).TTest1 = stats_BuildStructTTest1(False, True);
    sStatsTest(i).TTest2 = stats_BuildStructTTest2(False, True);
    sStatsTest(i).RankSum = stats_BuildStructRankSum(False, True);
    sStatsTest(i).SignRank = stats_BuildStructSignRank(False, True);
    sStatsTest(i).KSTest2 = stats_BuildStructKSTest2(False, True);
end


