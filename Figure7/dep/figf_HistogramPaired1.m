function [ hs ] = figf_HistogramPaired1( data1, data2, fignum )
%
%
% Copyright (C) Yuichi Takeuchi 2017

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
h1 = histogram(hax, data1);
h2 = histogram(hax, data2);
hold(hax,'off');
box('off')

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% Building the output handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.h1 = h1;
hs.h2 = h2;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

