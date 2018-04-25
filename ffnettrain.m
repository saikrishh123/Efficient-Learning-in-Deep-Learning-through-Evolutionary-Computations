function [net,err]=ffnettrain(inputs,targets,tr)


% Create a Pattern Recognition Network
hiddenLayerSize = [50,50];
net = feedforwardnet(hiddenLayerSize);


net.divideParam.trainRatio =1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;
net.trainParam.epochs = 3000;
%net.trainParam.showWindow = false;


% Train the Network
[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','only');
%[net,tr] = train(net,inputs,targets);
%[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','only');



outputs = net(inputs);

err=mean((outputs-targets).^2);
end
