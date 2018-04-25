load fisheriris.mat;
irispreprocessing;
inputs = meas';
targets = out';

% Create a Pattern Recognition Network
hiddenLayerSize = [10,10];
net = patternnet(hiddenLayerSize);



% Set up Division of Data for Training, Validation, Testing
net.trainFcn='traingd';
%net.trainParam.showWindow = false;
net.divideFcn='divideind';
[trainInd,valInd,testInd] = divideind(150,[1:1,51:52,101:102],[6:50,56:100,106:150],[]);

net.divideParam.trainInd = trainInd;
net.divideParam.valInd = valInd;
net.divideParam.testInd = testInd;
net.trainParam.epochs = 20000;

net.layers{1}.transferFcn = 'logsig'
net.layers{2}.transferFcn = 'logsig'


% Train the Network
%[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','yes');
[net,tr] = train(net,inputs,targets);
%[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','only');



% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% View the Network
%view(net)

%Plots
%Uncomment these lines to enable various plots.
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, plotconfusion(targets,outputs)
 %figure, ploterrhist(errors)