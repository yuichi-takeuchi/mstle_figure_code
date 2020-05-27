function [ interleaved ] = interleave( vector1, vector2 )
%
% Copyright (c) Yuichi Takeuchi

vector1 = vector1(:).';
vector2 = vector2(:).';
interleaved = [vector1;vector2];
interleaved = interleaved(:);

end

