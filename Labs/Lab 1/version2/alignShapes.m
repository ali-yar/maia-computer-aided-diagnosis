function [S] = alignShapes(S)
% alignShapes
% 
% Notation reference:
%   n: total landmark points
%   N: total shapes
% 
% Input:
%   S: (2nxN) landmarks coordinates (rows) for each shape (cols)
% 
% Output:
%   S: (2nxN) the original S after alignement

total_shapes = size(S,2);
total_points = size(S,1) / 2;

% center and (unit) scale the shapes
S = normalizeShapes(S);

% figure, plot(shapes(1:total_points,:),shapes(total_points+1:end,:));title("Normalized shapes");

[meanS, meanS_x, meanS_y] = meanShape(S, false);

while true
    old_meanS = meanS;
    for i = 1:total_shapes
       X = S(:,i);
       X_x = X(1:total_points);
       X_y = X(total_points+1:end);
       
       a = dot(X,meanS) / vecnorm(X)^2;
       
       b = 0;
       for j = 1:total_points
           b = b + (X_x(j)*meanS_y(j) - X_y(j)*meanS_x(j));
       end
       b = b / vecnorm(X)^2;
       
       scale = sqrt(a^2 + b^2);
       ang = atan2(b,a);

       X_x = scale * (cos(ang)*X_x - sin(ang)*X_y);
       X_y = scale * (sin(ang)*X_x + cos(ang)*X_y);
     
       S(:,i) = [X_x; X_y];
    end
    % compute the new mean shape
    [meanS, meanS_x, meanS_y] = meanShape(S, true);
    
    if abs(meanS - old_meanS) < eps
        break;
    end
end

end





