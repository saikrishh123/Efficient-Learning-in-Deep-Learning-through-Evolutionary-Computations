load digittrain_dataset.mat

% clf
% for i = 1:20
%     subplot(4,5,i);
%     imshow(xTrainImages{i});
% end

rng('default')

hiddenSize1 = 10;

autoenc10 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',1000, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);