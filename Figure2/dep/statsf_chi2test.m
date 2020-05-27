function [ h, p, stats ] = statsf_chi2test( counts, totalCounts )
%
% counts, totalCounts: vectors with same length
%
%   Copyright (c) Yuichi Takeuchi 2019

% Observed data
noncounts = totalCounts - counts;

% Pooled estimate of proportion
p0 = sum(counts)/sum(totalCounts);

% Expected count under H0 (null hypothesis)
n0 = totalCounts.*p0;
n0n = totalCounts - n0;

% Chi-square test, by hand
observed = interleave(counts, noncounts);
expected = interleave(n0, n0n);
x = 1:length(counts)*2;
[h,p,stats] = chi2gof(x, 'freq', observed, 'expected', expected, 'ctrs', x, 'nparams', length(counts));

end