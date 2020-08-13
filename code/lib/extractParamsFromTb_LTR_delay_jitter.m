function [r, theta, X, Y] = extractParamsFromTb_LTR_delay_jitter(Tb, LTR, delay, jitter)
% Copyright (c) 2020 Yuichi Takeuchi

idx = Tb.LTR == LTR & Tb.delay == delay & Tb.jitter == jitter;

r = Tb.r(idx);
theta = Tb.theta(idx);
X = Tb.X(idx);
Y = Tb.Y(idx);

end

