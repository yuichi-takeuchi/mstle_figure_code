function [ sBasicStats, sStatsTest ] = statsf_get3ANOVAStatsStructs1( srcTable, dataVarNames, OnOffVarName, linearVarName, ThrshldVarName)
%
% This function returns structures containing results of discriptive
% statistics and statistical tests.
% 
% Usage:
%   [ sBasicStats, sStatsTest ] = statsf_getBasicStatsAndTestStructs1( srcTable, VarNames, logicVec )
%
% INPUTS:
%    srcTable (table): source table
%    dataVarNames (cell): variable name list for quantitative analysis
%    OnOffVarName (char): variable name for on/off factor
%    linearVarName (char): variable name for linear factor
%    ThrshldVarName (char): variable name for thresholded condition
% OUTPUT:
%    sBasicStats: Cell vector, each element of which contains one
%    sStatsTest: structure for statistical tests
%
% Copyright (c) Yuichi Takeuchi 2018
%

for i = 1:length(dataVarNames)
    Off = srcTable.(dataVarNames{i})(srcTable.(OnOffVarName) == 0);
    OffLin = srcTable.(linearVarName)(srcTable.(OnOffVarName) == 0);
    OnNoThrshlded  = srcTable.(dataVarNames{i})(srcTable.(OnOffVarName) == 1 & srcTable.(ThrshldVarName) == 0);
    OnNoThrshldedLin = srcTable.(linearVarName)(srcTable.(OnOffVarName) == 1 & srcTable.(ThrshldVarName) == 0);
    OnThrsdhlded  = srcTable.(dataVarNames{i})(srcTable.(OnOffVarName) == 1 & srcTable.(ThrshldVarName) == 1);
    OnThrshldedLin = srcTable.(linearVarName)(srcTable.(OnOffVarName) == 1 & srcTable.(ThrshldVarName) == 1);
    
    % calculating basic statistics
    sBasicStats(i).Variable = dataVarNames{i};
    [ MeanOff, StdOff, SemOff, PrctileOff ] = stats_Summary2( Off, OffLin );
    [ MeanOnUpper, StdOnUpper, SemOnUpper, PrctileOnUpper ] = stats_Summary2( OnNoThrshlded, OnNoThrshldedLin );
    [ MeanOnLower, StdOnLower, SemOnLower, PrctileOnLower ] = stats_Summary2( OnThrsdhlded, OnThrshldedLin );
    
    sBasicStats(i).Mean = [MeanOff; MeanOnUpper; MeanOnLower];
    sBasicStats(i).Std = [StdOff; StdOnUpper; StdOnLower];
    sBasicStats(i).Sem = [SemOff; SemOnUpper; SemOnLower];
    sBasicStats(i).Prctile = [PrctileOff; PrctileOnUpper; PrctileOnLower];

    % statistical test (two-way ANOVA with multicompare)
    sStatsTest(i).Variable = dataVarNames{i};
    y = srcTable.(dataVarNames{i});
    gOnOff = srcTable.(OnOffVarName);
    gThreshold = srcTable.(ThrshldVarName);
    gLinear = srcTable.(linearVarName);
    [p, tbl, stats, terms] = anovan(y, {gOnOff, gThreshold, gLinear}, 'model', 'interaction', 'varnames', {'gOnOff', 'gThreshold', 'gLinear'}, 'display', 'off');
    c = multcompare(stats, 'Dimension',[1 2], 'display', 'off');
    sStatsTest(i).PValues = p;
    sStatsTest(i).Table = tbl;
    sStatsTest(i).Structure = stats;
    sStatsTest(i).Terms = terms;
    sStatsTest(i).MultiComp = c;
end

