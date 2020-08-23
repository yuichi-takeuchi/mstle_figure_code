%% figure 2 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel D
%%
[pD_sBasicStats, pD_sStatsTest, pD_sBasicStats_MI, pD_sStatsTest_MI, pD_No] = figure2d();
%% panel E
%%
[pE_sBasicStats, pE_sStatsTest, pE_sBasicStats_pa, pE_sStatsTest_pa, pE_No] = figure2e();
%% panel F, H
%%
[pF_sBasicStats, pF_sStatsTest, pF_sBasicStats_MI, pF_sStatsTest_MI, pH_percThrshlded, pH_chi2] = figure2fh();
%% panel G
%%
[pG_sBasicStats, pG_sStatsTest, pG_sBasicStats_pa, pG_sStatsTest_pa, pG_No] = figure2g();
%% panel I
%%
[pI_sBasicStats, pI_sStatsTest, pI_No] = figure2i();