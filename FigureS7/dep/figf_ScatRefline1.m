function [ hs ] = figf_ScatRefline1( xData, yData, coef, R, fignum )
%
%
% Copyright (C) Yuichi Takeuchi 2019

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
hsct = scatter(xData, yData, 10, 'k');
hrl = refline(coef(1), coef(2));
str = ['   {\it r} = ', num2str(R(1,2))];
htxt = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
hold(hax,'off');
hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% building handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hsct = hsct;
hs.hrl = hrl;
hs.htxt = htxt;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

