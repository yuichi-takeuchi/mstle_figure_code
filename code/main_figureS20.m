%% figure S20 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% metainfo
%%
ratId = [74 88 104 105];
%% figure preparation
%%
for i = 1:length(ratId)
    [sBasicStat{i}, sStatsTest{i}, No{i}] = figureS20(ratId(i), i);
end
clear i