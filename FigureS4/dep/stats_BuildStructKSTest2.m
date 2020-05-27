function [ destStruct ] = stats_BuildStructKSTest2( srcVec1, srcVec2 )
%
% [ destStruct ] = stats_BuildStructTTest2( srcVec1, srcVec2 )
%   
% Copyright (C) Yuichi Takeuchi 2017
%

[h,p,ks2stat] = kstest2(srcVec1, srcVec2);
destStruct = struct(...
    'h', h,...
    'p', p,...
    'stats', ks2stat...
    );
end

