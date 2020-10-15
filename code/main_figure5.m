%% figure 5 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel G
%%
[pG_sBasicStats, pG_sStatsTest, pG_sBasicStats_pa, pG_sStatsTest_pa, pG_No] = figure5g();
%% panel H
%%
[pH_sBasicStats, pH_sStatsTest, pH_sBasicStats_pa, pH_sStatsTest_pa, pH_No] = figure5h();
%% panel I
%%
[pI_sBasicStats, pI_sStatsTest, pI_sBasicStats_pa, pI_sStatsTest_pa, pI_No] = figure5i();
%% panel J
%%
[pJ_sBasicStats, pJ_sStatsTest, pJ_sBasicStats_pa, pJ_sStatsTest_pa, pJ_No] = figure5j();