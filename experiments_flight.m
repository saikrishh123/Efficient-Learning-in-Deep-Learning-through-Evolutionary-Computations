
% [dat t r]=xlsread('flight.xlsx');
% [indat,t]=createdat(dat,1,9000);
% 
% flight.inputs=indat;
% flight.targets=t;
% 
% save flight flight


load flight

if(exist('e_flight.mat')==2)
    load e_flight
else
    e_flight=experimenter(flight.inputs,flight.targets,'regression',{'gaSimple','bpTanh','bpLogSig','psoSimple'},20);
end

save e_flight e_flight

e_flight.AlgStructs{1}=e_flight.AlgStructs{1}.runAlg();

 