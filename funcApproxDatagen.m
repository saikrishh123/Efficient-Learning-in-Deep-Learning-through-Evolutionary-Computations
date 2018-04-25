[X,Y] = meshgrid(-1:0.05:1,-1:0.05:1);
[Z,csin,csout] = complexdine2d(X,Y);
surf(X,Y,Z)
