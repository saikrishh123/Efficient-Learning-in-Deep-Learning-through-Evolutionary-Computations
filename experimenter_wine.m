
if(exist('e_wine.mat')==2)
    load e_wine
else
    e_wine=experimenter(wineInputs',wineTargets','classification',{'gaSimple','bpTanh','bpLogSig','psoSimple'},20,[1,2,3,4,5,10,20,40]);
end

save e_wine e_wine

e_wine.AlgStructs{1}=e_wine.AlgStructs{1}.runAlg();

    