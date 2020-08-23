%% figure S7 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% metainfo
%%
ratId = [80 99 100 127 128 129 130];
%% figure preparation
%%
for i = 1:length(ratId)
    [sBasicStat{i}, sStatsTest{i}, sBasicStats_MI{i}, sStatsTest_MI{i}, No{i}] = figureS7(ratId(i), i);
end
clear i