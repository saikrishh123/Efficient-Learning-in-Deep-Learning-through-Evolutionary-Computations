function t=generateXlSummary(e,fname)

l=size(e.Algs,1);
e=e.display_Results;
m=e.MeanTotal';
s=e.StdTotal';

for i=1:size(m,1)
    for j=1:size(m,2)
        t{i,j}=strcat(num2str(m(i,j)),'+/-',num2str(s(i,j)));
        
    end
        
end

name=e.Algs;
t=[name;t];

xlswrite(fname,t);
end