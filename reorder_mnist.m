load M50.mat
Inputs=M50.Inputs;
out=M50.Outputs;


for i=1:size(out,1)
            

[v,pix(i)]=max(out(i,:));

end

[v,idx]=sort(pix);

min=Inputs(idx,:);
mout=out(idx,:);

    
M50.Inputs=min;
M50.Outputs=mout;

save M50 M50                   

