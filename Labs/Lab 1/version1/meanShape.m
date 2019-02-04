function [meanS, meanS_x, meanS_y] = meanShape(S, normalize)
%MEANSHAPE Summary of this function goes here

N = size(S,1) / 2;

meanS = mean(S, 2);

if normalize == true
    meanS = meanS ./ vecnorm(meanS);
end

meanS_x = meanS(1:N,:);
meanS_y = meanS(N+1:end,:);
    
end

