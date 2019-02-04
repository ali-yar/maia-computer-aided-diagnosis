close all, clear, clc;

filename = 'shapes.txt' ;
shapes = importdata (filename, ' ', 0);

% total samples
total_shapes = size(shapes,2);
total_points = size(shapes,1) / 2;

shapes = centerShapes(shapes, total_points);
A = shapes;

% figure, plot(shapes(1:total_points,:),shapes(total_points+1:end,:)); title("Centered shapes");

% take first shape as initial mean shape
meanX = A(:,1); 

% normalize mean shape to unit length
meanX = meanX ./ vecnorm(meanX);

meanX_x = meanX(1:56,:);
meanX_y = meanX(57:end,:);

% figure, plot(meanX_x, meanX_y); title("Mean shape");

% Alignment
it = 0;
while it < 5
    for i=1:total_shapes
       X = A(:,i);
       X_x = X(1:total_points);
       X_y = X(total_points+1:end);
       
       a = dot(X,meanX) / vecnorm(X)^2;
       
       b = 0;
       for j=1:total_points
           b = b + (X_x(j)*meanX_y(j) - X_y(j)*meanX_x(j));
       end
       b = b / vecnorm(X)^2;
       
       scale = sqrt(a^2 + b^2);
       ang = atan2(b,a);
       
       e = mean(X_x);
       f = mean(X_y);
       X_x = X_x - e;
       X_y = X_y - f;
       
       X_x = scale * (cos(ang)*X_x + sin(ang)*X_y) + meanX_x;
       X_y = scale * (-sin(ang)*X_x + cos(ang)*X_y) + meanX_y;
       A(:,i) = [X_x; X_y];
    end
    meanX = mean(A, 2);
    meanX = meanX ./ vecnorm(meanX);
    it = it + 1;
end

X = A(1:total_points,:);
Y = A(total_points+1:end,:);

figure, plot(X,Y);

covar = cov(A);
[V,D] = eig(covar);
