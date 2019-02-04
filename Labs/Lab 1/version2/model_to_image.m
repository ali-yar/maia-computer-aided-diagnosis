function [X] = model_to_image(X, t_x, t_y, scale, ang)
%MODEL_TO_IMAGE

N = size(X,1)/2;
x = X(1:N);
y = X(N+1:end);

Xx = t_x + (x*scale*cos(ang) - y*scale*sin(ang));
Xy = t_y + (x*scale*sin(ang) + y*scale*cos(ang));
X= [Xx;Xy];


end
