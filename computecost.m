
%File-computecost.m
%Serves as Fitness function for computing fitness of a genome.s 
function cost=computecost(x) 

%Training data
Input = [0 1 0 1 0.5;0 0 1 1 0.5]';
target = [0 1 1 0 0 ]';

%Weights are taken from the genes of the population
W=x;

l=size(Input);

%Simulate and get ouput for each input for the given configuration
for i=1:l(1)
 in=Input(i,:);
out(i)=nn(in(1),in(2),W(1),W(2),W(3),W(4),W(5),W(6),W(7),W(8),W(9));
end
out=out';
error=0;

%Compute net mean squared error as a fitness measure for the genome.
for i=1:length(target)
    error=error+(out(i)-target(i))^2;
end
cost=error;
