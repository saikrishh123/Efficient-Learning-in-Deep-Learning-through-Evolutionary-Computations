function dataObj=NormCompletedata(dataObj)
Inputs=dataObj.Inputs;
Targets=dataObj.Targets;

for i=1:size(Inputs,2)
    Inputs(:,i)=normalize(Inputs(:,i));
    
       
end


for i=1:size(Targets,2)
    Targets(:,i)=normalize(Targets(:,i));
    
       
end

dataObj.Inputs=Inputs;
dataObj.Targets=Targets;

end