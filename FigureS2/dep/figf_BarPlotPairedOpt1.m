function [ hs ] = figf_BarPlotPairedOpt1( srcVecBar, srcMatScat, fignum )
%
% [ Mean, Std, Sem, Prctile ] = stats_Summary1( srcMat )
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

hax = gca;
yl = get(hax, 'YLim');
hptch = patch([1.6 2.4 2.4 1.6],[yl(1) yl(1) yl(2) yl(2)],'b');
set(hptch,'FaceAlpha',0.2,'edgecolor','none');

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
hs.hptch = hptch;

end

