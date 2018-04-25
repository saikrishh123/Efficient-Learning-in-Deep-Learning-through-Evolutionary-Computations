load fisheriris.mat
irispreprocessing

if(exist('e_iris.mat')==2)
    load e_iris
else
    e_iris=experimenter(meas,out,'classification',{'gaSimple','bpTanh','bpLogSig','psoSimple'});
end

e_iris.AlgStructs{1}=e_iris.AlgStructs{1}.runAlg();

save e_iris e_iris