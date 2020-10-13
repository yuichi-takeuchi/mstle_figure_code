%% figure S10 main
% Copyright © 2020 Yuichi Takeuchi
%% initialization

clear; clc
%% path
%%
addpath(genpath('helper'))
addpath(genpath('lib'))
%% metainfo
%%
ratId = [80 127 99 128 129 100 130];
%% figure preparation
%%
for i = 1:length(ratId)
    [sBasicStat{i}, sStatsTest{i}, No{i}] = figureS10(ratId(i), i);
end
clear i