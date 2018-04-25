
function [out,datin,datout]=complexdine2d(x,y)
l=size(x);
p=0;
for i=1:l(1)
    for j=1:l(2)
        p=p+1;
        out(i,j)=computecs2d([x(i,j),y(i,j)]);
        datin(p,:)=[x(i,j),y(i,j)];
        datout(p,:)=[out(i,j)];
        
        
    end
end
end

function out=computecs2d(x)
out=(sin(5*x(1)*(3*x(2)+1))+1)/2;

end