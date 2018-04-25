load Input
load Target

%funcApproxDatagen;
opts.n=10;
opts.Inputs=Input;
opts.Target=target;

opts.node_complete_enable=1;
opts.weights_complete_enable=0; 

opts.mode=0; %(0 -Discrete ,1-Continous (Probability Mode))
opts.weights_activation_func_parameter=100000;
opts.node_activation_func_parameter=100000;


opts.networkType='custom';
opts.hidden_array=[2];


opts.objective=0; %(0-single objective 1-mulitobjective)
opts.parallel=true; 
opts.population_size=500;
opts.max_gen=50;
%opts.Alg='ga';
opts.Alg='pso';


opts.continue=1;

k=GAWrapper(opts);
