
%File nn.m
%Simulates the custom neural network for a given weight configuration.
function out=nn(x0,x1,w20,w21,w30,w31,W2,W3,w42,w43,W4)

%Compute Output of node 2 from inputs
out2=sigmf(x0*w20+x1*w21+W2,[1,0]);

%Compute Output of node 3 from inputs
out3=sigmf(x0*w30+x1*w31+W3,[1,0]);

%Compute Output of network from ouputs of hidden layer
out=out2*w42+out3*w43+W4;


end





