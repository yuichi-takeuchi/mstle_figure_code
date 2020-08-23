%% figure 3 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel E, G
%%
[pE_sBasicStat, pE_sStatsTest, pE_sBasicStats_MI, pE_sStatsTest_MI, pG_percThrshlded, pG_chi2] = figure3eg();
%% panel F
%%
[pF_sBasicStats, pF_sStatsTest, pF_sBasicStats_pa, pF_sStatsTest_pa, pF_No] = figure3f();
%% panel H
%%
[pH_sBasicStats, pH_sStatsTest, pH_No] = figure3h();