%% figure S12 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel A
%%
[pA_sBasicStats, pA_sStatsTest, pA_No] = figureS12a();
%% panel B
%%
[pB_No] = figureS12b();
%% panel C
%%
[pC_sBasicStats, pC_sStatsTest, pC_sBasicStats_ind, pC_sStatsTest_ind, pC_sBasicStats_pa, pC_No] = figureS12c();
%% panel D
%%
[pD_pCorStatTest, pD_No] = figureS12d();