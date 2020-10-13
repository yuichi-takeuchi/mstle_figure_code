%% figure S15 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel D, F
%%
[pD_sBasicStats, pD_sStatsTest, pD_sBasicStats_MI, pD_sStatsTest_MI, pF_chi2] = figureS15df();
%% panel E
%%
[pE_sBasicStats, pE_sStatsTest, pE_sBasicStats_pa, pE_sStatsTest_pa, pE_No] = figureS15e();
%% panel G
%%
[pG_sBasicStats, pG_sStatsTest, pG_No] = figureS15g();