load fisheriris.mat
irispreprocessing
for n=1:50
save n n
disp('Running:')
disp(n)
indat=[meas(1:n,:);meas(51:50+n,:);meas(101:100+n,:)];
outdat=[out(1:n,:);out(51:50+n,:);out(101:100+n,:)];

opts.n=10;
opts.Inputs=indat;
opts.Target=outdat;

opts.node_complete_enable=1;
opts.weights_complete_enable=1; 

opts.mode=0; %(0 -Discrete ,1-Continous (Probability Mode))
opts.weights_activation_func_parameter=100000;
opts.node_activation_func_parameter=100000;

opts.objective=0; %(0-single objective 1-mulitobjective)
opts.parallel=true; 
opts.population_size=500;
opts.max_gen=200;
%opts.Alg='ga';
opts.Alg='pso';
opts.continue=1;
opts.funcName='computecost';


G=GAWrapper(opts);
[O,a,c]=G.testIris(meas,out,100000,100000);

R_pso_ir_simple(n)=G;
save R_pso_ir_simple R_pso_ir_simple
acc_pso_iris_simple(n)=a;
save acc_pso_iris_simple acc_pso_iris_simple;




end
