function [out,datin,datout]=rastrin(x,y)
l=size(x);
p=0;
for i=1:l(1)
    for j=1:l(2)
        p=p+1;
        out(i,j)=computerast([x(i,j),y(i,j)]);
        datin(p,:)=[x(i,j),y(i,j)];
        datout(p,:)=[out(i,j)];
        
        
    end
end
end

function out=computerast(x)
out=20+x(1)^2+x(2)^2-10*(cos(2*pi*x(1))+cos(2*pi*x(2)));

end