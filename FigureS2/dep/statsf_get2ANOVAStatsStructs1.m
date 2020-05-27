function [ sBasicStats, sStatsTest ] = statsf_get2ANOVAStatsStructs1( srcTable, dataVarNames, OnOffVarName, linearVarName)
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
%    linearVarName (char): variabl name for linear factor
% OUTPUT:
%    sBasicStats: Cell vector, each element of which contains one
%    sStatsTest: structure for statistical tests
%
% (c) Yuichi Takeuchi 2018
%

for i = 1:length(dataVarNames)
    Off = srcTable.(dataVarNames{i})(srcTable.(OnOffVarName) == 0);
    OffLin = srcTable.(linearVarName)(srcTable.(OnOffVarName) == 0);
    On  = srcTable.(dataVarNames{i})(srcTable.(OnOffVarName) == 1);
    OnLin = srcTable.(linearVarName)(srcTable.(OnOffVarName) == 1);
       
    % calculating basic statistics
    sBasicStats(i).Variable = dataVarNames{i};
    [ MeanOff, StdOff, SemOff, PrctileOff ] = stats_Summary2( Off, OffLin );
    [ MeanOn, StdOn, SemOn, PrctileOn ] = stats_Summary2( On, OnLin );
    
    sBasicStats(i).Mean = [MeanOff; MeanOn];
    sBasicStats(i).Std = [StdOff; StdOn];
    sBasicStats(i).Sem = [SemOff; SemOn];
    sBasicStats(i).Prctile = [PrctileOff; PrctileOn];

    % statistical test (two-way ANOVA with multicompare)
    sStatsTest(i).Variable = dataVarNames{i};
    y = srcTable.(dataVarNames{i});
    gOnOff = srcTable.(OnOffVarName);
    gLinear = srcTable.(linearVarName);
    [p, tbl, stats, terms] = anovan(y, {gOnOff, gLinear}, 'model', 'interaction', 'varnames', {'gOnOff', 'gLinear'}, 'display', 'off');
    c = multcompare(stats, 'Dimension',[1 2], 'display', 'off');
    sStatsTest(i).PValues = p;
    sStatsTest(i).Table = tbl;
    sStatsTest(i).Structure = stats;
    sStatsTest(i).Terms = terms;
    sStatsTest(i).MultiComp = c;
end

