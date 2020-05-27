function [ hs ] = figf_Plot1( srcMatX, srcMatY, fignum )
%
%
% Copyright (C) Yuichi Takeuchi 2019

hfig = figure(fignum);
hax = axes; % subplot
hold(hax,'on');
for i = 1:size(srcMatY,1)
    hp(i) = plot(hax, srcMatX, srcMatY(i,:),'-o');
end
hold(hax,'off');
box('off')
hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% building handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.hp = hp;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.htitle = htitle;

end

