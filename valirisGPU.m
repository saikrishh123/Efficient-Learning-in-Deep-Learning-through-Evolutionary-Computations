%load ipop
%load gi

for j=1:100
cost=zeros(500,1);
for i=1:500
   cost(i)=gi.computecostIris(ipop(i,:)); 
end
end