function [P,D] = projectionMatrix(S)
%PROJECTIONMATRIX
% covariance
covar = cov(S');

[V,D] = eig(covar);

% sort decreasingly
[d, idx] = sort(diag(D), 'descend');
D = D(idx, idx);
V = V(:,idx);

D = sum(D,2); % make diagonal matrix as column vector
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

end

