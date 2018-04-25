l=size(species);
m=length(unique(species));
s=unique(species);
out=zeros(l(1),m);
for i=1:l(1)
   for j= 1:m
       if(strcmp(s(j),species{i}))
           out(i,j)=1;
       end
   end
end

n=50;

indat=[meas(1:n,:);meas(51:50+n,:);meas(101:100+n,:)];
outdat=[out(1:n,:);out(51:50+n,:);out(101:100+n,:)];
% for i=1:30
% [v,tix(i)]=max(outdat(i,:));
% end
% 
% testindat=[meas(11:20,:);meas(61:70,:);meas(111:120,:)];
% testoutdat=[out(11:20,:);out(61:70,:);out(111:120,:)];
% 
% 
% for i=1:l(1)
% [v,iris_out(i)]=max(out(i,:));
% end
% 
