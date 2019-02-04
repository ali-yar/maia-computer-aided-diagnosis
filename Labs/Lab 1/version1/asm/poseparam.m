function X = poseparam(x,y,tx,ty,scale,ang)

npts = 56;
    for i = 1 : npts
        Xx = tx + (scale*cos(ang) - scale*sin(ang))*x;
        Xy = ty + (scale*sin(ang) + scale*cos(ang))*y;
        X= [Xx,Xy];
    end


end