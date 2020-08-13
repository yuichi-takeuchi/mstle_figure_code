function [r, theta, X, Y] = extractParamsFromTb_LTR_jitter(Tb, LTR, jitter)
% Copyright (c) 2020 Yuichi Takeuchi

idx = Tb.LTR == LTR & Tb.jitter == jitter;

r = Tb.r(idx);
theta = Tb.theta(idx);
X = Tb.X(idx);
Y = Tb.Y(idx);

end

