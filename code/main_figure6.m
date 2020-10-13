%% figure 6 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel A
%%
[pA_sBasicStats, pA_sStatsTest, pA_CorStatTest, pA_No] = figure6a();
%% panel B
%%
[pB_sBasicStats, pB_sStatsTest, pB_CorStatTest, pB_No] = figure6b();
%% panel C
%%
[pC_sBasicStats, pC_sStatsTest, pC_supraCorStat, pC_No] = figure6c();