%% figure S21 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel D
%%
[pD_sBasicStats, pD_sStatsTest, pD_sBasicStats_MI, pD_sStatsTest_MI, pD_No] = figureS21d();
%% panel E
%%
[pE_sBasicStats, pE_sStatsTest, pE_sBasicStats_pa, pE_sStatsTest_pa, pE_No] = figureS21e();