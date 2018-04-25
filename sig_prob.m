x = 0:0.01:1;

for i=1:100
y = sigmf(x-0.5,[10*i 0]);
plot(x,y)
hold on
end
xlabel('probability');
ylabel('Existence Value');
ylim([-0.05 1.05]);

