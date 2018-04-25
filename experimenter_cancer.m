
if(exist('e_cancer.mat')==2)
    load e_cancer
else
    e_cancer=experimenter(cancerInputs',cancerTargets','classification',{'gaSimple','bpTanh','bpLogSig','psoSimple'},20);
end

save e_cancer e_cancer

e_cancer.AlgStructs{1}=e_cancer.AlgStructs{1}.runAlg();

