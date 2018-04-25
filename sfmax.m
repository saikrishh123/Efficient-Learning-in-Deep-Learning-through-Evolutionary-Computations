function out=sfmax(x)
n=0;
out=zeros(size(x));
for i=1:length(x)
   n=n+exp(x(i)); 
end

for i=1:length(x)
   out(i)=exp(x(i))/n; 
end

end


% function out=sfmax(x)
% n=0;
% out=zeros(size(x));
% xn=x-max(x);
% for i=1:length(xn)
%    n=n+exp(xn(i)); 
% end
% 
% lsm=xn-log2(n);
% 
% %out=exp(lsm);
% out=2.^(lsm);
% 
% 
% %disp(sum(out))
% 
% end