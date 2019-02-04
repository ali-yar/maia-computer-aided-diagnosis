function [S] = normalizeShapes(S)
% normalizeShapes 

total_points = size(S,1) / 2;

x = S(1:total_points,:);
y = S(total_points+1:end,:);

% figure, plot(X,Y); title("Original");

% center the shape on the origin
centred_x = x - mean(x);
centred_y = y - mean(y);

% figure, plot(centred_x,centred_y); title("Centered on origin");

% normalize to unit length
veclength = vecnorm([centred_x;centred_y]);
norm_x = centred_x ./ veclength ;
norm_y =  centred_y ./ veclength;

% check if the scale leads to 1
sum([norm_x; norm_y].^2);

S = [norm_x; norm_y];

end

