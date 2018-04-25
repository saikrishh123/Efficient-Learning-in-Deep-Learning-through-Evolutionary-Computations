
%File-runga.m
%Wrapper for setting options and running genetic algorithm. 

% Determine the Lower and Upper bounds. Note ncessary. Speeds up
% computations.
lb=[-5 -5 -5 -5 -5 -5 -5 -5 -5];
ub=[5 5 5 5 5 5 5 5 5];

%Set Options for the genetic algorithm.  
opts = gaoptimset('PopulationSize', 1000, ...
    'EliteCount', 10, ...
    'PlotFcn', {@gaplotbestf,@gaplotstopping},...
    'Generations',100);


rng(0, 'twister');

% Run genetic algorithm for the fitness function @'computecost'.
[xbest, fbest, exitflag] = ga(@computecost, 9, [], [], [], [], ...
    lb, ub, [], [], opts);

% Output xbest and fbest

disp('Best Fitness:')
disp(fbest)
disp('Output of the best genome')
disp(bp(Input,target,xbest))

