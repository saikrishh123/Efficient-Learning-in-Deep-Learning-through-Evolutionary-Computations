p=0;
for i=1:5
    for j=i:5
        p=p+1
        weights(p)=w(i,j);
    end
    
end

s=[1 2 3]
t=[1 1 1]
weights=[0.1,0.5,0.4]
Gr=digraph(s,t,weights)