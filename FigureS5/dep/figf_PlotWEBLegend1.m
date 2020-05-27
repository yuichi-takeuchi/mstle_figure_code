function [ hs ] = figf_PlotWEBLegend1( srcMatX, srcMatY, srcMatEB, CLeg, fignum )
%
%
% Copyright (C) Yuichi Takeuchi 2017

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
for i = 1:size(srcMatY,2)
%     h.hp(i) = plot(h.haxes, srcMatX, srcMatY(:,i), 'k-o');
    heb(i) = errorbar(hax, srcMatX, srcMatY(:,i), srcMatEB(:,i), 'k-o');
end
hold(hax,'off');
hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');
hlgnd = legend(CLeg, 'Box', 'Off');

% building handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.heb = heb;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;
hs.hlgnd = hlgnd;

end

