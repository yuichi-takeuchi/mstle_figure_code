function [ hs ] = figf_HistogramWThreeFits1( data, x, fit1, fit2, fit3, fignum )
%
%
% Copyright (C) Yuichi Takeuchi 2017

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
hst = histogram(hax, data);
hp1 = plot(x, fit1);
hp2 = plot(x, fit2);
hp3 = plot(x, fit3);
hold(hax,'off');
box('off')

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% Building the output handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hst = hst;
hs.hp1 = hp1;
hs.hp2 = hp2;
hs.hp3 = hp3;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

