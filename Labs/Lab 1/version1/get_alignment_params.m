function [t_x, t_y, final_scale, final_ang] = get_alignment_params(A,B)
%GET_ALIGNMENT_PARAMS 

final_scale = 1;
final_ang = 0;

for i=1:10

    a = dot(A,B) / vecnorm(A)^2;

    b = 0;
    for j = 1:56
       b = b + (A(j)*B(56+j) - A(56+j)*B(j));
    end
    b = b / vecnorm(A)^2;

    scale = sqrt(a^2 + b^2);
    ang = atan2(b,a);

    A(1 : 56) = scale * A(1 : 56);
    A(57 : end) = scale * A(57 : end);
    
    A(1 : 56) = cos(ang)*A(1 : 56) - sin(ang)*A(57 : end);
    A(57 : end) = sin(ang)*A(1 : 56) + cos(ang)*A(57 : end);
    
%     figure;
%     plot(A(1:56), A(57:end),'-', 'LineWidth',1);
%     hold on;
%     plot(B(1:56), B(57:end),'-', 'LineWidth',1);
    
    final_scale = final_scale * scale;
    final_ang = final_ang + ang;
end

cA = get_centroid(A);
cB = get_centroid(B);

t_x = cB(1) - cA(1);
t_y = cB(2) - cA(2);

A(1:56) = A(1:56) + t_x;
A(57:end) = A(57:end) + t_y;

% 
% figure;
% plot(A(1:56), A(57:end),'-', 'LineWidth',1);
% hold on;
% plot(B(1:56), B(57:end),'-', 'LineWidth',1);
% plot(cA(1), cA(2),'*', 'LineWidth',1);
% plot(cB(1), cB(2),'+', 'LineWidth',1);


end

