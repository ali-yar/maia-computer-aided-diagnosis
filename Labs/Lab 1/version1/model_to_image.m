function [X] = model_to_image(X, t_x, t_y, scale, ang)
%MODEL_TO_IMAGE

N = size(X,1)/2;
% 
% X_x = X(1:N);
% X_y = X(N+1:end);
% 
% % mean_x = mean(X_x);
% % mean_y = mean(X_y);
% % X_x = X_x - mean_x;
% % X_y = X_y - mean_y;
% 
% X_x = t_x + scale * (cos(ang) * X_x - sin(ang) * X_y);
% X_y = t_y + scale * (sin(ang) * X_x + cos(ang) * X_y);
% 
% X = [X_x; X_y];

X(1 : 56) =  cos(ang)*X(1 : 56) - X(57 : end) * sin(ang);
X(57 : end) =  sin(ang)*X(1 : 56) + X(57 : end) * cos(ang);

X = X * scale;
X(1 : 56) = X(1 : 56) + t_x;
X(57 : end) = X(57 : end) + t_y;


end






% X_x = t_x + (X_x * scale * cos(ang)  - X_y * scale * sin(ang));
% X_y = t_y + (X_x * scale * sin(ang) + X_y * scale * sin(ang));
% 
% X = [X_x; X_y];
