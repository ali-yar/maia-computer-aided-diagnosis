function [dist] = metric(A,B)
% metric 
% 
% Given 2 sets of points, compute the distance between a point from each
% set.

% total points
n = size(A,1) / 2;

% reshape from 2n x 1 to n x 2
A = reshape(A,[n,2]) ./ [800 600];
B = reshape(B,[n,2]) ./ [800 600];

dist =0;
for i = 1:n
    dist = dist + norm(A(i,:) - B(i,:));    
end
  
end