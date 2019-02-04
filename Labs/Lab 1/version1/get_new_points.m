function [Y] = get_new_points(img, X, normals, search_range)
% initialize
Y = zeros(size(X));

% total points
N = size(X,1) / 2;

for i = 1:N
    x_start = X(i) + search_range * normals(i,1);
    x_end = X(i) - search_range * normals(i,1);

    y_start = X(i+N) + search_range * normals(i,2);
    y_end = X(i+N) - search_range * normals(i,2);

    x = double(int16([x_start x_end]));
    y = double(int16([y_start y_end]));

    % intensities along the line formed by 2 endpoints
    [cx, cy, c] = improfile(img,x,y,search_range*2+1);
%     plot(cx,cy);
    % index of max intensity
    [m, idx] = max(c);
    
    Y([i i+N]) = [round(cx(idx)) round(cy(idx))];
    
    if max(c) <1
        Y([i i+N]) = [X(i) X(i+N)];
    end
    
    if abs(img(i+N, i) - max(c)) < 1
        Y([i i+N]) = [X(i) X(i+N)];
    end
    
    for j=1:i-1
        if Y([i i+N]) == Y([j j+N])
            [tmp, iidx] = sort(c,'descend');
            Y([i i+N]) = [round(cx(iidx(2))) round(cy(iidx(2)))];
            break;
        end
    end
end

end
