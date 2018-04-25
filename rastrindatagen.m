l=size(a)
for i=1:l(1)
    
    %p(i)=rastrin(a(i,:))
end
% x=a(:,1);
% y=a(:,2);
% surf(x,y,p)


[X,Y] = meshgrid(0:0.5:10,0:0.5:10);
%[Z,rastin,rastout] = rastrin(X,Y);
name='rastrin'
[Z,rastin,rastout] = feval(str2func(name),X,Y);

surf(X,Y,Z)