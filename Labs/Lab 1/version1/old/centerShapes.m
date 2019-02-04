function [data] = centerShapes(data, total_points)
%normalizeShapes 

x = data(1:total_points,:);
y = data(total_points+1:end,:);

% figure, plot(X,Y); title("Original");

% center the shape on the origin
centred_x = x - mean(x);
centred_y = y - mean(y);

data = [centred_x; centred_y];

end

