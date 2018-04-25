
load Input
load Target

if(exist('e_xor.mat')==2)
    load e_xor
else
    e_xor=experimenter(Input,target,'regression',{'gaSimple','bpTanh','bpLogSig','psoSimple','gaComplexDiscrete','gaComplexDiscrete_NodeComplete','gaComplexContinous','gaComplexContinous_NodeComplete','psoComplexContinous','psoComplexContinous_NodeComplete'},5,[5]);
end

save e_xor e_xor

for i=1:size(e_xor.Algs,2)
e_xor.AlgStructs{i}=e_xor.AlgStructs{i}.runAlg();
end

 