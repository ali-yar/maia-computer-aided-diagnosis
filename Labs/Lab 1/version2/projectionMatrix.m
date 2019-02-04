function [P,D] = projectionMatrix(S)
% projectionMatrix
% 
% Find the matrix of eigenvectors that are able to reconstruct data at
% 98% accuracy
% 
% Notation reference:
%   N: total images
%   n: total landmark points
%   t: minimum number of eigenvectors to reconstruct 98% of a shape
% 
% Input:
%   S: (2nxN) landmarks coordinates (rows) for each shape (cols)
% 
% Output:
%   P: (2nxt) matrix of t eigenvectors 
%   D: (tx1) eigenvalues corresponding to the t eigenvectors

% covariance
covar = cov(S');

% eigenvectors and eigenvalues
[V,D] = eig(covar);

% sort decreasingly
[D, idx] = sort(diag(D), 'descend');
V = V(:,idx);
% V = fliplr(V);

total_variance = sum(D);

% find the t eigenvalues that constitute 98% of the total variance
max_val = total_variance * 0.98;
s = 0;
for t = 1:numel(D)
    s = s + D(t);
    if s >= max_val
        break;
    end
end

P = V(:,1:t);
D = D(1:t);
end

