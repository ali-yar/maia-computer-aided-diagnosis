function [val] = fit(S,meanS,covS)
%FIT

% ignore warnings
warning('off','MATLAB:nearlySingularMatrix');

% Mahalanobis distance of a sample from the model mean
val = (S - meanS)' * inv(covS) * (S - meanS);

end

