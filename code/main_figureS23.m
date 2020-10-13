%% figure S23 main
% Copyright © 2020 Yuichi Takeuchi
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel D
%%
[pD_sBasicStat, pD_sStatsTest, pD_sBasicStats_MI, pD_sStatsTest_MI, pD_No] = figureS23d();
%% panel E
%%
[pE_sBasicStats, pE_sStatsTest, pE_sBasicStats_pa, pE_sStatsTest_pa, pE_No] = figureS23e();
%% panel I
%%
[pI_sBasicStat, pI_sStatsTest, pI_sBasicStats_MI, pI_sStatsTest_MI, pI_No] = figureS23i();
%% panel J
%%
[pJ_sBasicStat, pJ_sStatsTest, pJ_sBasicStats_pa, pJ_sStatsTest_pa, pJ_No] = figureS23j();