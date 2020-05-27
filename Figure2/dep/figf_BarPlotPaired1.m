function [ hs ] = figf_BarPlotPaired1( srcVecBar, srcMatScat, fignum )
%
%
% Copyright (C) Yuichi Takeuchi 2017

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
hb = bar(hax, [1 2], [srcVecBar(1) 0; 0 srcVecBar(2)], 0.5, 'stacked');
Xp = repmat([1;2],1,size(srcMatScat,2));
Xp = Xp + 0.25*(rand(size(Xp))-0.5);
hp = plot(hax, Xp,srcMatScat, 'k--o');
hold(hax,'off');

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% Building the output handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hb = hb;
hs.hp = hp;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

