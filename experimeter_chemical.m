
% [dat t r]=xlsread('chem.xlsx');
% [indat,t]=createdat(dat,1,9000);
% 
% chem.inputs=indat;
% chem.targets=t;
% 
% save chem chem


load chem

if(exist('e_chem.mat')==2)
    load e_chem
else
    e_chem=experimenter(chem.Inputs,chem.Targets,'regression',{'gaSimple','bpTanh','bpLogSig','psoSimple','Neat'},20);
end

save e_chem e_chem

%e_chem.AlgStructs{1}=e_chem.AlgStructs{1}.runAlg();

 