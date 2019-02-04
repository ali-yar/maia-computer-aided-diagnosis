function [X] = image_to_model(X, t_x, t_y, scale, ang)
%IMAGE_TO_MODEL

X(1 : 56) = X(1 : 56) - t_x;
X(57 : end) = X(57 : end) - t_y;

X = X / scale;

X(1 : 56) =  cos(ang)*X(1 : 56) + X(57 : end) * sin(ang);
X(57 : end) =  -sin(ang)*X(1 : 56) + X(57 : end) * cos(ang);

end

