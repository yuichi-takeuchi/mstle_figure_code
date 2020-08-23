%% figure S10 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel F
%%
[pF_sBasicStats, pF_sStatsTest, pF_sBasicStats_MI, pF_sStatsTest_MI, pF_No] = figureS10f();
%% panel G
%%
[pG_sBasicStats, pG_sStatsTest, pG_sBasicStats_pa, pG_sStatsTest_pa, pG_No] = figureS10g();