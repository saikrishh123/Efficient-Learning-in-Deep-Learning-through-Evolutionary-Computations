function R=perform_opt(net)

load G;
save net net
%Set Options for the genetic algorithm.
optns = optimoptions(@ga, ...
    'PopulationSize',100, ...
    'MaxGenerations', 20, ...
    'FunctionTolerance', 1e-10, ...
    'CrossoverFraction',0.8,...
     'UseParallel',true);


%Intialize random seed for reproducability
rng(0, 'twister');

func=@netsim;


% Run genetic algorithm for the fitness function @'computecost'.
[R.xbest, R.fbest, R.exitflag,R.output_pop,R.population,R.scores] = ga(func, G.n_var, [], [], [], [], ...
    G.LowerBound, G.UpperBound, [], G.IC, optns);

end

function cost=netsim(x)
load net
cost=abs(net(x'));
end

