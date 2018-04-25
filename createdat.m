function [indat,t]=createdat(dat,start,End)
l=size(dat);

for i=1:l(2)
    a(:,i)=normalize(dat(:,i));
    
end

indat=a(start:End,1:end-1);
t=a(start:End,end);

end
