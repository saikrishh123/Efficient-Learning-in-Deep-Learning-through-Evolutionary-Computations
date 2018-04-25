function [Indices,pix]= generateIndices(Inputs,out,N)


for i=1:size(out,1)
            

[v,pix(i)]=max(out(i,:));

end

n=length(unique(pix));
p=0;

for i=1:n
   v=find(pix==i);
   r=randperm(length(v),N);
   p=p+1;
   Indices(p,:)=v(r);
   
    
end


Indices=Indices(:);
end