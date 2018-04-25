load M50.mat


if(exist('e_mnist.mat')==2)
    load e_mnist
else
    e_mnist=experimenter(M50.Inputs,M50.Outputs,'classification',{'gaSimple','bpTanh','bpLogSig','psoSimple'},100,[1,2,5,10]);
end
save e_mnist e_mnist
e_mnist.AlgStructs{1}=e_mnist.AlgStructs{1}.runAlg();

