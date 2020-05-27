function [ destStruct ] = stats_BuildStructSignRank( srcVec1, srcVec2 )
%
% [ destStruct ] = stats_BuildStructSignRank( srcVec1, srcVec2 )
%   
% Copyright (C) Yuichi Takeuchi 2017
%

[p,h,stats] = signrank( srcVec1, srcVec2 );
destStruct = struct(...
    'h', h,...
    'p', p,...
    'stats', stats...
    );

end

