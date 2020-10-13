%% figure S9 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel A
%%
[pA_sBasicStats, pA_sStatsTest, pA_No] = figureS9a();
%% panel B
%%
[pB_sBasicStats, pB_sStatsTest, pB_No] = figureS9b();
%% panel C
%%
[pC_sBasicStats, pC_sStatsTest, pC_No] = figureS9c();