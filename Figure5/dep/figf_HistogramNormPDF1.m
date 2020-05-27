function [ hs ] = figf_HistogramNormPDF1( data, fignum )
%
% Copyright (C) Yuichi Takeuchi 2019

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
hst = histogram(hax, data, 'Normalization', 'pdf');
hold(hax,'off');
box('off')

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% Building the output handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hst = hst;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

