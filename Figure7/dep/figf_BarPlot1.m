function [ hs ] = figf_BarPlot1( srcX, srcY, fignum )
%
% Copyright (C) Yuichi Takeuchi 2019

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
hb = bar(srcX, srcY);
hold(hax,'off');

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');
hlgnd = legend('');

% Building the output handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hb = hb;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;
hs.hlgnd = hlgnd;
end

