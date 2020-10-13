%% figure 3 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel E, H
%%
[pE_sBasicStat, pE_sStatsTest, pE_sBasicStats_MI, pE_sStatsTest_MI, pH_percThrshlded, pH_chi2] = figure3eh();
%% panel F
%%
[pF_sBasicStats, pF_sStatsTest, pF_No] = figure3f();
%% panel G
%%
[pG_sBasicStats, pG_sStatsTest, pG_sBasicStats_pa, pG_sStatsTest_pa, pG_No] = figure3g();
%% panel I
%%
[pI_sBasicStats, pI_sStatsTest, pI_No] = figure3i();