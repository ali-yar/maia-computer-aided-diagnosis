function [X] = image_to_model(X, t_x, t_y, scale, ang)
%IMAGE_TO_MODEL

X(1 : 56) = X(1 : 56) - t_x;
X(57 : end) = X(57 : end) - t_y;

X = X / scale;

X(1 : 56) =  cos(ang)*X(1 : 56) + X(57 : end) * sin(ang);
X(57 : end) =  -sin(ang)*X(1 : 56) + X(57 : end) * cos(ang);


end


% 
% function [X] = image_to_model(X, tx, ty, scale, ang)
% %IMAGE_TO_MODEL
% 
% N = size(X,1)/2;
% x = X(1:N);
% y = X(N+1:end);
% scale = 1/ scale;
% Xx = -tx + (x*scale*cos(ang) + y*scale*sin(ang));
% Xy = -ty + (-x*scale*sin(ang) + y*scale*cos(ang));
% X= [Xx;Xy];
% 
% end