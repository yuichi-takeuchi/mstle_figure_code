%% figure S19 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% panel A
%%
[pA_sBasicStats, pA_sStatsTest, pA_No] = figureS19a();
%% panel B
%%
[pB_sBasicStats, pB_sStatsTest, pB_No] = figureS19b();