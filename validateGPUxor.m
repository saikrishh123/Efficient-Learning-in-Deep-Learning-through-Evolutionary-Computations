%load pop
%load g
for i=1:size(pop,1)
   cost(i)=g.computecost_norm(pop(i,:)); 
end