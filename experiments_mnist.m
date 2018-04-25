load M10.mat


if(exist('e_mnist.mat')==2)
    load e_mnist
else
    e_mnist=experimenter(M10.Inputs,M10.Outputs,'classification',{'gaSimple','bpTanh','bpLogSig','psoSimple'},50,[1,2,5,10]);
end
save e_mnist e_mnist
e_mnist.AlgStructs{1}=e_mnist.AlgStructs{1}.runAlg();

