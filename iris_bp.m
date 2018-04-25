function [accuracy,train_accuracy,net]=iris_bp(inputs,targets,trainInd,actfunc)
% Create a Pattern Recognition Network
hiddenLayerSize = [10,10];
net = patternnet(hiddenLayerSize);
l=size(inputs,2);
valInd=[l+1:2*l];
inputs=[inputs,inputs];
targets=[targets,targets];



% Set up Division of Data for Training, Validation, Testing

net.trainFcn='traingd';
%net.trainParam.showWindow = false;
net.divideFcn='divideind';
%[trainInd,valInd,testInd] = divideind(150,trainInd,[],[]);

net.divideParam.trainInd = trainInd;
net.divideParam.valInd = valInd;
net.divideParam.testInd = [];
net.trainParam.epochs = 5000;
net.trainParam.max_fail=3000;
if(strcmp(actfunc,'logsig'))
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'logsig';
end



% Train the Network
%[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','yes');
[net,tr] = train(net,inputs,targets);
%[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','only');



% Test the Network
trin=inputs(:,valInd);

trout=targets(:,valInd);


outputs = net(trin);
[values,pred_ind]=max(outputs,[],1);
[~,actual_ind]=max(trout,[],1);
accuracy=sum(pred_ind==actual_ind)/size(trin,2);



%Train Accuracy;

trin=inputs(:,trainInd);
trout=targets(:,trainInd);


outputs = net(trin);
[values,pred_ind]=max(outputs,[],1);
[~,actual_ind]=max(trout,[],1);
train_accuracy=sum(pred_ind==actual_ind)/size(trin,2);






end