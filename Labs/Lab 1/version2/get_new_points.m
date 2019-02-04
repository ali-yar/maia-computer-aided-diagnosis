function [Y] = get_new_points(img, X, normals, m, k, meanP, covP)
% get_new_points
% 
% Find the matrix of eigenvectors that are able to reconstruct data at
% 98% accuracy
% 
% Notation reference:
%   N: total images
%   n: total points
%   t: minimum number of eigenvectors to reconstruct 98% of a shape
% 
% Input:
%   img: (HxW) target image from which the profile will be sampled
%   X: (2nx1) coords of points around which the profile will be sampled
%   normals: (nx2) normals of all n points
%   m: (scalar) 
%   k: (scalar) 
%   meanP: (2k+1xn) mean profiles from train data
%   covP: (1xn) covariance of profiles from train data
% Output:
%   Y: (2nx1) new points  

% initialize
Y = zeros(size(X));

% total points
N = size(X,1) / 2;

% length of model sample
modelLen = size(meanP,1);

% index of the center of the model sample
modelCenterIdx = k + 1;

% total positions along the sample for comparison
total_pos = 2*m - size(meanP,1) + 1;

min_dist = 0;

for i = 1:N
    [P, cx, cy] = getProfileSamples(img,[X(i) X(i+N)],normals(i,:),m,1);
    
    % derivative
    P = diff(P);
    % normalize
    P = P / sum(abs(P));
    
    for j = 1:total_pos
        dist = abs(fit(P(j:j+modelLen-1),meanP(:,i),covP{i}));
        if j == 1
            idx = j + modelCenterIdx - 1;
            min_dist = dist;
            Y([i,i+N]) = [cx(idx) cy(idx)];
        elseif dist < min_dist
            idx = j + modelCenterIdx - 1;
            min_dist = dist;
            Y([i,i+N]) = [cx(idx) cy(idx)];
        end
    end
    
end

% figure, imshow(img); hold on; plot( Y(1:56), Y(57:end));

end


% IF MAKING USE OF MAXGRADIENT()
%
% function [Y] = get_new_points(img, X, normals, m, k, meanP, covP)
% % get_new_points
% % 
% % Find the matrix of eigenvectors that are able to reconstruct data at
% % 98% accuracy
% % 
% % Notation reference:
% %   N: total images
% %   n: total points
% %   t: minimum number of eigenvectors to reconstruct 98% of a shape
% % 
% % Input:
% %   img: (HxW) target image from which the profile will be sampled
% %   X: (2nx1) coords of points around which the profile will be sampled
% %   normals: (nx2) normals of all n points
% %   m: (scalar) sample profile size (actually 2*m+1)
% %   k: (scalar) mean profile size (actually 2*k+1)
% %   meanP: (2k+1xn) mean profiles from train data
% %   covP: (1xn) covariance of profiles from train data
% % Output:
% %   Y: (2nx1) new points  
% 
% % initialize
% Y = zeros(size(X));
% 
% % total points
% N = size(X,1) / 2;
% 
% % length of model sample
% modelLen = size(meanP,1);
% 
% % index of the center of the model sample
% modelCenterIdx = k + 1;
% 
% % total positions along the sample for comparison
% total_pos = 2*m - size(meanP,1) + 1;
% 
% min_dist = 0;
% 
% for i = 1:N
%     % get locations of max gradients along the normal of the current point
%     G = maxGradient(img, X([i,i+N]), normals(i,:), k);
%     
%     % plot(G(:,1),G(:,2),'go');
%     
%     for z = 1:size(G,1)
%         [P, cx, cy] = getProfileSamples(img,G(z,:),normals(i,:),k,1);
% 
%         % derivative
%         P = diff(P);
%         % normalize
%         P = P / sum(abs(P));
%         
%         dist = abs(fit(P,meanP(:,i),covP{i}));
%         if z == 1
%             min_dist = dist;
%             Y([i,i+N]) = G(z,:);
%         elseif dist < min_dist
%             min_dist = dist;
%             Y([i,i+N]) = G(z,:);
%         end
% 
%         
%     end
%     
% end
% 
% % figure, imshow(img); hold on; plot( Y(1:56), Y(57:end));
% 
% end
% 
