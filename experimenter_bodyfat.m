

load bodyfat

if(exist('e_bodyfat.mat')==2)
    load e_bodyfat
else
    e_bodyfat=experimenter(bodyfat.Inputs,bodyfat.Targets,'regression',{'gaSimple','bpTanh','bpLogSig','psoSimple','Neat'},20);
end

save e_bodyfat e_bodyfat

%e_bodyfat.AlgStructs{1}=e_bodyfat.AlgStructs{1}.runAlg();

 