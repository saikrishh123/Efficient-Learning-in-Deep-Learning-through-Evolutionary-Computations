
x = [0 1 0 1 0.5;0 0 1 1 0.5];

t = [0 1 1 0 0 ];
plot(x,t,'o')

net = feedforwardnet(1);
net = configure(net,x,t);
y1 = net(x)
plot(x,t,'o',x,y1,'x')

net = train(net,x,t);
y2 = net(x)
plot(x,t,'o',x,y1,'x',x,y2,'*')
