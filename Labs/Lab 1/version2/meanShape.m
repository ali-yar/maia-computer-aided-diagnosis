function [meanS, meanS_x, meanS_y] = meanShape(S, normalize)
% meanShape
% 
% Notation reference:
%   n: total landmark points
%   N: total shapes
% 
% Input:
%   S: (2nxN) shapes
%   normalize: (bool) unit scale the mean shape
% 
% Output:
%   meanS: (2nx1) mean shape
%   meanS_x: (2nx1) x-coordinates of mean shape
%   meanS_y: (2nx1) y-coordinates of mean shape

N = size(S,1) / 2;

meanS = mean(S, 2);

if normalize == true
    meanS = meanS ./ vecnorm(meanS);
end

meanS_x = meanS(1:N,:);
meanS_y = meanS(N+1:end,:);
    
end

