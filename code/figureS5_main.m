%% figure S5 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel A
%%
figureS5a();
%% panel B
%%
[pB_No] = figureS5b();
%% panel C
%%
[pC_sBasicStats, pC_sStatsTest, pC_sBasicStats_pa, pC_sStatsTest_pa] = figureS5c();
%% panel D
%%
[pD_sBasicStats, pD_sStatsTest, pD_sBasicStats_pa, pD_sStatsTest_pa] = figureS5d();
%% panel E
%%
figureS5e();
%% panel F
%%
[pF_sBasicStats, pF_sStatsTest, pF_sBasicStats_pa, pF_sStatsTest_pa] = figureS5f();