%% figure 4 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel F, H
%%
[pF_sBasicStats, pF_sStatsTest, pF_sBasicStats_MI, pF_sStatsTest_MI, pH_chi2] = figure4fh();
%% panel G
%%
[pG_sBasicStats, pG_sStatsTest, pG_sBasicStats_pa, pG_sStatsTest_pa, pG_No] = figure4g();
%% panel I
%%
[pI_sBasicStats, pI_sStatsTest, pI_No] = figure4i();