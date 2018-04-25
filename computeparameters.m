function cost=computeparameters(x) 
Input = [0 1 0 1 0.5;0 0 1 1 0.5]';

target = [0 1 1 0 0 ]';
W=x;
l=size(Input);
for i=1:l(1)
 in=Input(i,:);
out(i)=nn(in(1),in(2),W(1),W(2),W(3),W(4),W(5),W(6),W(7),W(8),W(9));
end
out=out';
out=out-target;
error=0;
for i=1:length(target)
    error=error+(out(i)-target(i))^2;
end
cost=abs(out)
