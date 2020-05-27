function [ destStruct ] = stats_BuildStructRankSum( srcVec1, srcVec2 )
%
% [ destStruct ] = stats_BuildStructRankSum( srcVec1, srcVec2 )
%   
% Copyright (C) Yuichi Takeuchi 2017
%

[p,h,stats] = ranksum( srcVec1, srcVec2 );
destStruct = struct(...
    'h', h,...
    'p', p,...
    'stats', stats...
    );

end

