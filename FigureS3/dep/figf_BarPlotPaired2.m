function [ hs ] = figf_BarPlotPaired2( srcVecBar, srcMatScat1, srcMatScat2, colorMat, fignum )
%
% Copyright (C) Yuichi Takeuchi 2019

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
hb = bar(hax, [1 2], [srcVecBar(1) 0; 0 srcVecBar(2)], 0.5, 'stacked');
Xp1 = repmat([1;2],1,size(srcMatScat1,2));
Xp1 = Xp1 + 0.25*(rand(size(Xp1))-0.5);
hsct1 = plot(hax, Xp1, srcMatScat1, '--o', 'Color', colorMat(1,:));
Xp2 = repmat([1;2],1,size(srcMatScat2,2));
Xp2 = Xp2 + 0.25*(rand(size(Xp2))-0.5);
hsct2 = plot(hax, Xp2, srcMatScat2, '--o', 'Color', colorMat(2,:));
hold(hax,'off');

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% Building the output handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hb = hb;
hs.hsct1 = hsct1;
hs.hsct2 = hsct2;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

