load M20.mat


if(exist('e_mnist_20.mat')==2)
    load e_mnist_20
else
    e_mnist_20=experimenter(M20.Inputs,M20.Outputs,'classification',{'gaSimple','bpTanh','bpLogSig','psoSimple'},50,[1,2,5,10]);
end
save e_mnist_20 e_mnist_20
%e_mnist_20.AlgStructs{1}=e_mnist_20.AlgStructs{1}.runAlg();

