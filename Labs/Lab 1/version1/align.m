function [S] = align(S)
%ALIGN

total_shapes = size(S,2);
total_points = size(S,1) / 2;

[meanS, meanS_x, meanS_y] = meanShape(S, false);

it = 0;
while it < 5
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
    [meanS, meanS_x, meanS_y] = meanShape(S, true);
    it = it + 1;
end

end

