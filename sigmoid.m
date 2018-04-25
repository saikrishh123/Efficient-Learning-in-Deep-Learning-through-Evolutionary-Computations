x = -10:0.1:10;

for i=0:10
y = sigmf(x-0.5,[i 0]);
plot(x,y)
hold on
xlabel('sigmf')
ylim([-0.05 1.05])

end