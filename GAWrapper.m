%File GAWrapper.m
%Warapper Class to create, simulate , analyze and visualize the network.
classdef GAWrapper
    properties
        NumberOfNodes; %Max Nodes in the network
        MegaNode; % For storing all the Node object. Useful for computing network wide functions
        Inputs;%Input Data
        Target;% Target Data
        LowerBound;%Suitable Lower Bound for our weights
        UpperBound;%Suitable Upper Bound for our weights
        xbest;% For Storing our best configuraion
        fbest;% for storing best value
        exitflag;% check if everything went right
        randomvariables; % NUmber of random variables required for given number of nodes in a complex network
        w_count; % count of number of possible directed weights directed from lower to higher
        complex; % type of network (simple=0, complex=1)
        graph;% storing the graph of best genome.
        TestInput;
        TestTarget;
        costfunc;
        bp_learning_rate;
        inpop;
        output_pop;
        population;
        scores;
        memory;
        N_Inputs;
        N_Outputs;
        mode;
        fval;
        opts;
        n_var;
        IC;
        FFnet;
        GenerationStateInfo;
        w;
        resume;
        extraInfo;
        total_gen_count;
        GpuHandle;
        costMatrix;
        testGpuHandle;
    end
    methods
        
        
        function G=GAWrapper(opts)
            % Intialize configuration and data
            G.opts=opts;
            G.NumberOfNodes=opts.n;
            %G.inpop=inpop;
            G.bp_learning_rate=0.1;
            G.mode=opts.mode;
            
            
            
            G.Inputs=opts.Inputs;
            G.Target=opts.Target;
            
            G.TestInput=opts.TestInputs;
            G.TestTarget=opts.TestTargets;
            
            
            l=size(G.Inputs);
            m=size(G.Target);
            G.N_Inputs=l(2);
            G.N_Outputs=m(2);
            
            switch opts.networkType
                
                case 'custom'
                    G.FFnet=Network(G.N_Inputs,opts.hidden_array,G.N_Outputs);
                    G.NumberOfNodes=G.FFnet.NumberOfNodes;
                    %Create MegaNode
                    MegaNode(G.NumberOfNodes)=Node;
                    G.MegaNode=MegaNode;
                    
                    
                otherwise
                    fast=1;
                    if(fast)
                        MegaNode(G.NumberOfNodes)=NodeSimple;
                        
                    else
                        
                        MegaNode(G.NumberOfNodes)=Node;
                    end
                    G.MegaNode=MegaNode;
                    
                    if(opts.node_complete_enable==0||opts.weights_complete_enable==0)
                        %Set type of network.
                        G.complex=1;
                    else
                        G.complex=0;
                    end
            end
            
            %end
            %Count number of variables for complex network
            G=G.compute_randomvariables_count();
            G=G.computeBounds();
            global StateInfo;
            
            switch opts.Alg
                
                case 'ga'
                    %Run genetic Algorithm
                    if(opts.objective)
                        G=G.runGAmultiobj();
                        
                    else
                        G=G.runGA();
                        G.GenerationStateInfo=StateInfo(1:G.output_pop.generations);
                        
                    end
                    
                case 'pso'
                    iteration=0;
                    latestSwarm=0;
                    
                    save latestSwarm latestSwarm;
                    save iteration iteration;
                    G=G.runPSO();
                    load iteration;
                    
                    G.GenerationStateInfo=StateInfo(1:iteration+1);
                    load latestSwarm.mat
                    G.output_pop=latestSwarm;
                    
                otherwise
                    warning('Expected one of the algs');
                    
            end
            
            
            
            
            
            %             figure;
            %             if(G.complex==0)
            %                 G=G.plotbestGraphSimple();
            %             else
            %                 %G=G.plotbestGraphComplex();
            %             end
            %
            
            
            
            
        end
        
        
        function G=plotbestGraphComplex(G)
            x=G.xbest;
            p=0;
            n=G.NumberOfNodes;
            weights_count=(n*n-n)/2+n;
            node_mask=x(1:n);
            weights_mask=x(n+1:n+weights_count);
            weights=x(n+weights_count+1:end);
            weightMatrix=G.createWeightMatrix(weights);
            weight_mask_Matrix=G.createWeightMatrix(weights_mask);
            
            %Create Directed Edge list with weights from node mask
            %weight mask data
            for i=1:n
                if(node_mask(i)==1)
                    for j=i:n
                        if(node_mask(i)==1)
                            if(weight_mask_Matrix(i,j)==1)
                                p=p+1;
                                s(p)=i;
                                t(p)=j;
                                wts(p)=weightMatrix(i,j);
                            end
                        end
                    end
                end
            end
            
            %Create directed Graph
            G.graph=digraph(s,t,wts);
            %plot the graph
            plot(G.graph,'EdgeLabel',G.graph.Edges.Weight);
            
            
            
            
            
        end
        
        function [indat,t]=createdat(dat,start,End)
            l=size(dat);
            
            for i=1:l(2)
                a(:,i)=normalize(dat(:,i));
                
            end
            
            indat=a(start:End,1:end-1);
            t=a(start:End,end);
            
        end
        
        
        
        
        function G=createdata(G,fname,EndTrain)
            [dat,txt,r]=xlsread(fname);
            [G.Inputs,G.Target]=createdat(dat,1,EndTrain);
            l=size(dat);
            [G.TestInput,G.TestTarget]=createdat(dat,1,l(1));
            
            
        end
        
        function G=computememoryRequirements(G)
            if(G.complex==1)
                l=size(G.graph.Edges);
                G.memory=l(1);
                
                
            else
                n=G.NumberOfNodes;
                G.memory=(n*n-n)/2+n;
            end
        end
        
        
        
        function G=plotbestGraphSimple(G)
            %Create and plot the graph for best network.
            x=G.xbest;
            weightMatrix=G.createWeightMatrix(x);
            n=G.NumberOfNodes;
            p=0;
            %Create Directed Edge list with weights from weight Matrix
            
            for i=1:n
                for j=i:n
                    p=p+1;
                    s(p)=i;
                    t(p)=j;
                    weights(p)=weightMatrix(i,j);
                end
            end
            G.graph=digraph(s,t,weights);
            plot(G.graph,'EdgeLabel',G.graph.Edges.Weight)
            
        end
        
        function G=computeBounds(G)
            %Set the lower and upper bounds
            
            switch G.opts.networkType
                
                case 'custom'
                    G.LowerBound=ones(1,G.randomvariables)*-5;
                    G.UpperBound=ones(1,G.randomvariables)*5;
                    
                    
                otherwise
                    
                    
                    if(G.complex==1)
                        n=G.NumberOfNodes;
                        weights_count=(n*n-n)/2+n;
                        LB=zeros(1,G.randomvariables);
                        UB=ones(1,G.randomvariables);
                        
                        
                        if((G.opts.node_complete_enable==0)&&(G.opts.weights_complete_enable==0))
                            LB(n+weights_count+1:end)=-5;
                            UB(n+weights_count+1:end)=5;
                            
                        end
                        
                        if((G.opts.node_complete_enable==1)&&(G.opts.weights_complete_enable==0))
                            LB(weights_count+1:end)=-5;
                            UB(weights_count+1:end)=5;
                            
                        end
                        
                        if((G.opts.node_complete_enable==0)&&(G.opts.weights_complete_enable==1))
                            LB(n+1:end)=-5;
                            UB(n+1:end)=5;
                        end
                        
                        if((G.opts.node_complete_enable==1)&&(G.opts.weights_complete_enable==1))
                            LB(1:end)=-5;
                            UB(1:end)=5;
                            
                        end
                        
                        
                        
                        LB(n+weights_count+1:end)=-5;
                        UB(n+weights_count+1:end)=5;
                        G.LowerBound=LB;
                        G.UpperBound=UB;
                        G.w_count=weights_count;
                        
                    else
                        
                        
                        n=G.NumberOfNodes;
                        weights_count=(n*n-n)/2+n;
                        LB=zeros(1,weights_count);
                        UB=ones(1,weights_count);
                        LB(1:end)=-5;
                        UB(1:end)=5;
                        G.LowerBound=LB;
                        G.UpperBound=UB;
                        G.w_count=weights_count;
                        
                        
                    end
                    
            end
            
            
        end
        
        function G=compute_randomvariables_count(G)
            
            switch G.opts.networkType
                
                case 'custom'
                    G.randomvariables=size(G.FFnet.graph.Edges.EndNodes,1);
                    G.IC=[];
                    
                    
                otherwise
                    % Compute total variables count for a given value of n. (Complex case)
                    n=G.NumberOfNodes;
                    weights_count=(n*n-n)/2+n;
                    nodes_mask_count=n;
                    weights_mask_count=weights_count;
                    
                    if((G.opts.node_complete_enable==0)&&(G.opts.weights_complete_enable==0))
                        G.randomvariables=weights_count+nodes_mask_count+weights_mask_count;
                        G.IC=[1:nodes_mask_count+weights_mask_count];
                    end
                    
                    if((G.opts.node_complete_enable==1)&&(G.opts.weights_complete_enable==0))
                        G.randomvariables=weights_count+weights_mask_count;
                        G.IC=[1:weights_mask_count];
                    end
                    
                    if((G.opts.node_complete_enable==0)&&(G.opts.weights_complete_enable==1))
                        G.randomvariables=weights_count+nodes_mask_count;
                        G.IC=[1:nodes_mask_count];
                        
                    end
                    
                    if((G.opts.node_complete_enable==1)&&(G.opts.weights_complete_enable==1))
                        G.randomvariables=weights_count;
                        G.IC=[];
                        
                    end
                    
            end
        end
        
        function w=createWeightMatrix(G,weights)
            n=G.NumberOfNodes;
            w=zeros(n,n);
            p=0;
            for i=1:n
                for j=i:n
                    p=p+1;
                    w(i,j)=weights(p);
                end
            end
            
        end
        
        function G=createLookup(G)
            weights=[1:G.randomvariables];
              n=G.NumberOfNodes;
            w=zeros(n,n);
            p=0;
            for i=1:n
                for j=i:n
                    p=p+1;
                    w(i,j)=weights(p);
                end
            end
            G.w=w;
            end
        
        
        
        function G=runGAmultiobj(G)
            
            
            optns = optimoptions(@gamultiobj, ...
                'PopulationSize', 500, ...
                'MaxGenerations', 50, ...
                'FunctionTolerance', 1e-8, ...
                'PlotFcn', {@gaplotpareto,@gaplotscorediversity});
            
            
            %Intialize random seed for reproducability
            rng(0, 'twister');
            
            n=G.NumberOfNodes;
            
            func=@G.computecostMO;
            
            G=compute_vars_integerconstraints(G);
            
            
            [G.xbest,G.fval,G.exitflag,G.output_pop,G.population,G.scores] = gamultiobj(func, G.n_var, [], [], [], [], ...
                G.LowerBound, G.UpperBound, [],optns);
            
        end
        
        
        function G= compute_vars_integerconstraints(G)
            n=G.NumberOfNodes;
            
            switch G.opts.networkType
                
                case 'custom'
                    G.n_var=G.randomvariables;
                otherwise
                    
                    if(G.complex==1)
                        
                        if(G.mode==0)
                            %Presence or Absence of links and nodes (Discrete Problem)
                            G.n_var=G.randomvariables;
                            G.IC=[1:n+(n*n-n)/2+n];
                            %func=@G.computecost;
                        else
                            %Continous Links
                            G.n_var=G.randomvariables;
                            G.IC=[ ];
                            %func=@G.computecost;
                            
                        end
                        
                    else
                        %All links are present
                        G.n_var=G.w_count;
                        G.IC=[];
                        %func=@G.computecostSimple;
                    end
            end
            
        end
        
        
        function G=runGA(G)
            
            %             %Set Options for the genetic algorithm.
            %             optns = optimoptions(@ga, ...
            %                 'PopulationSize',G.opts.population_size, ...
            %                 'MaxGenerations', G.opts.max_gen, ...
            %                 'FunctionTolerance', 1e-10, ...
            %                 'PlotFcn', {@gaplotbestf,@gaplotstopping},...
            %                 'OutputFcns',{@gaoutfnc},...
            %                 'CrossoverFraction',0.8,...
            %                 'UseParallel',G.opts.parallel);
            
             if(G.opts.continue==2)
                 load pop
                 load scores
                 
                 optns = gaoptimset('PopulationSize',G.opts.population_size, ...
                'Generations', G.opts.max_gen, ...
                'PlotFcn', {@gaplotbestf,@gaplotstopping},...
                'OutputFcns',{@gaoutfnc},...
                'CrossoverFraction',0.8,...
                'InitialPopulation',pop,...
                'InitialScores',scores,...
                'Vectorized','on');
            
            
             else
                 
            optns = gaoptimset('PopulationSize',G.opts.population_size, ...
                'Generations', G.opts.max_gen, ...
                'PlotFcn', {@gaplotbestf,@gaplotstopping},...
                'OutputFcns',{@gaoutfnc},...
                'CrossoverFraction',0.8,...
                'UseParallel',true);
             end
            
            
            
            
            %Intialize random seed for reproducability
            rng(0, 'twister');
            
            n=G.NumberOfNodes;
            G=G.createLookup;
            G=G.compute_vars_integerconstraints();
            
            
            switch G.opts.funcName
                case 'computecostIris'
                    G.costMatrix=gpuArray(zeros(G.opts.population_size,1,'single'));

                    %G.GpuHandle=createconfig(G.NumberOfNodes,G.n_var,G.opts.population_size,size(G.Inputs,1),size(G.Inputs,2),size(G.Target,2),'classification');
                    
                    
                    func=@G.computecostIris;
                    
                otherwise
                    G.costMatrix=gpuArray(zeros(G.opts.population_size,1,'single'));

                    G.GpuHandle=createconfig(G.NumberOfNodes,G.n_var,G.opts.population_size,size(G.Inputs,1),size(G.Inputs,2),size(G.Target,2),'regression');
                    
                    func=@G.computecost;
                    
                    
            end
            save G G
            
            
            % Run genetic algorithm for the fitness function @'computecost'.
            [G.xbest, G.fbest, G.exitflag,G.output_pop,G.population,G.scores] = ga(func, G.n_var, [], [], [], [], ...
                G.LowerBound, G.UpperBound, [], G.IC, optns);
            
        end
        
        
        
        
        
        function G=runPSO(G)
            
            %             %Set Options for the genetic algorithm.
            %             optns = optimoptions(@ga, ...
            %                 'PopulationSize',G.opts.population_size, ...
            %                 'MaxGenerations', G.opts.max_gen, ...
            %                 'FunctionTolerance', 1e-10, ...
            %                 'PlotFcn', {@gaplotbestf,@gaplotstopping},...
            %                 'OutputFcns',{@gaoutfnc},...
            %                 'CrossoverFraction',0.8,...
            %                 'UseParallel',G.opts.parallel);
            %
            
            options = optimoptions('particleswarm','SwarmSize',G.opts.population_size,...
                'UseParalle',G.opts.parallel,...
                'Plotfcn',{@pswplotbestf},...
                'MaxIterations',G.opts.max_gen,...
                'OutputFcns',{@psooutfunc});
            
            
            
            %Intialize random seed for reproducability
            rng(0, 'twister');
            
            n=G.NumberOfNodes;
            G=G.createLookup;
            
            switch G.opts.funcName
                case 'computecostIris'
                    func=@G.computecostIris;
                otherwise
                    func=@G.computecost;
                    
                    
            end
            
            G=G.compute_vars_integerconstraints();
            G=G.createLookup;
            save G G;
            
            [G.xbest,G.fval,G.exitflag] = particleswarm(func,G.n_var,G.LowerBound,G.UpperBound,options);
            
            
            
            %             % Run genetic algorithm for the fitness function @'computecost'.
            %             [G.xbest, G.fbest, G.exitflag,G.output_pop,G.population,G.scores] = ga(func, G.n_var, [], [], [], [], ...
            %                 G.LowerBound, G.UpperBound, [], G.IC, optns);
            %
        end
        
        
        
        function cost=computecost(G,x)
            %A=AlgData(G,x,G.Inputs,G.Target,G.opts.weights_activation_func_parameter,G.opts.node_activation_func_parameter);
            A=AlgDataSimple(G,x,G.Inputs,G.Target);
            
            A= A.compute_outputs(G);
            cost=A.compute_SE(G);
        end
        
        
        function cost=computecost_gpu(G,x)
            
            cost=feval(G.GpuHandle,G.costMatrix, x',G.Inputs',G.Target');
            cost=gather(cost');
            
%             A=AlgDataSimple(G,x,G.Inputs,G.Target);
%             
%             A= A.compute_outputs(G);
%             cost2=A.compute_SE(G);
%             
%             disp(sum(cost-cost2).^2);
%             pause(5);
        end
            
         function cost=computecostIris_gpu(G,x)
            tic
            
            cost=feval(G.GpuHandle,G.costMatrix, x',G.Inputs',G.Target');
            cost=gather(cost');
            
            toc
        end
        
        
        
          
        
        function cost=computecostMO(G,x)
            
            A=AlgData(G,x,G.Inputs,G.Target,G.opts.weights_activation_func_parameter,G.opts.node_activation_func_parameter);
            A= A.compute_outputs(G);
            cost(1)=A.compute_SE(G);
            cost(2)=sum(sum(A.weight_mask_Matrix));
            
        end
        
        
        
        
        
        function mse=testComplex(G,testin,testout,weights_activation_func_parameter,node_activation_func_parameter)
            %Compute mean squared error on a test data for complex case.
            x=G.xbest;
            %             if(nargin<4)
            %                 A=AlgData(G,x,testin,testout);
            %             else
            %                 A=AlgData(G,x,testin,testout,weights_activation_func_parameter,node_activation_func_parameter);
            %             end
            %
            
            A=AlgDataSimple(G,x,testin,testout);
            
            
            A= A.compute_outputs(G);
            cost=A.compute_SE(G);
            mse=cost;
            %mse=cost/l(1);
            
        end
        
        
        
        
        function cost=computecostIris(G,x)
            
            %A=AlgData(G,x,G.Inputs,G.Target,G.opts.weights_activation_func_parameter,G.opts.node_activation_func_parameter);
            A=AlgDataSimple(G,x,G.Inputs,G.Target);
            
            A= A.compute_outputs(G);
            cost=A.compute_CE(G);
        end
        
        
        
        
        
        function [Outputs,accuracy,cost]=testIris(G,testin,testout,weights_activation_func_parameter,node_activation_func_parameter)
            
            %Compute mean squared error on a test data for complex case.
            x=G.xbest;
            if(nargin<4)
                A=AlgData(G,x,testin,testout);
            else
                A=AlgData(G,x,testin,testout,weights_activation_func_parameter,node_activation_func_parameter);
            end
            A= A.compute_outputs(G);
            [cost,A]=A.compute_CE(G);
            
            Outputs=A.out;
            
            l=size(A.Inputs);
            m=size(A.Target);
            
            for i=1:l(1)
                [v,pix(i)]=max(A.out(i,:));
                [v,tix(i)]=max(testout(i,:));
            end
            accuracy=0;
            
            for i=1:l(1)
                if(pix(i)==tix(i))
                    accuracy=accuracy+1;
                end
            end
            accuracy=accuracy/l(1);
            
        end
        
        function cost=computecostIrisComplex(G,x)
            
            
            %Compute the node_mask, weight_mask and weight Matrix from
            %the genome data.
            n=G.NumberOfNodes;
            weights_count=(n*n-n)/2+n;
            node_mask=x(1:n);
            weights_mask=x(n+1:n+weights_count);
            weights=x(n+weights_count+1:end);
            weightMatrix=G.createWeightMatrix(weights);
            weight_mask_Matrix=G.createWeightMatrix(weights_mask);
            
            
            
            
            l=size(G.Inputs);
            m=size(G.Target);
            
            out=zeros(l(1),m(2));
            %Compute the ouputs of all the nodes in the network for the
            %given input
            for i=1:l(1)
                for j=1:n
                    G.MegaNode(j)=G.MegaNode(j).Evaluate(j,node_mask,G.MegaNode,weightMatrix,weight_mask_Matrix,l(2),m(2),G.Inputs(i,:),n);
                end
                %Take the output of last m(2) nodes as the net output.
                p=0;
                for j=1:m(2)
                    p=p+1;
                    out(i,j)=G.MegaNode(end-m(2)+p).output;
                end
            end
            
            %Compute Predicted Distribution by applying softmax
            %normalization
            for i=1:l(1)
                out(i,:)=sfmax(out(i,:));
            end
            
            cost=0;
            %Compute error as sum of cross entropy error between predicted and expected.
            for i=1:length(G.Target)
                for j=1:m(2)
                    cost=cost+-G.Target(i,j)*log2(out(i,j));
                end
            end
        end
        
        
        
        function [Outputs,accuracy,cost]=testIrisComplex(G,testin,testout)
            
            %Get weight matrix from genome data
            accuracy=0;
            x=G.xbest;
            
            %Compute the node_mask, weight_mask and weight Matrix from
            %the genome data.
            n=G.NumberOfNodes;
            weights_count=(n*n-n)/2+n;
            node_mask=x(1:n);
            weights_mask=x(n+1:n+weights_count);
            weights=x(n+weights_count+1:end);
            weightMatrix=G.createWeightMatrix(weights);
            weight_mask_Matrix=G.createWeightMatrix(weights_mask);
            
            
            
            l=size(testin);
            m=size(testout);
            
            out=zeros(l(1),m(2));
            %Compute the ouputs of all the nodes in the network for the
            %given input
            for i=1:l(1)
                for j=1:n
                    G.MegaNode(j)=G.MegaNode(j).Evaluate(j,node_mask,G.MegaNode,weightMatrix,weight_mask_Matrix,l(2),m(2),testin(i,:),n);
                end
                %Take the output of last m(2) nodes as the net output.
                p=0;
                for j=1:m(2)
                    p=p+1;
                    out(i,j)=G.MegaNode(end-m(2)+p).output;
                end
            end
            
            %Compute Predicted Distribution by applying softmax
            %normalization
            for i=1:l(1)
                out(i,:)=sfmax(out(i,:));
            end
            
            cost=0;
            %Compute error as sum of cross entropy error between predicted and expected.
            for i=1:length(testout)
                for j=1:m(2)
                    cost=cost+-testout(i,j)*log2(out(i,j));
                end
            end
            Outputs=out;
            
            for i=1:l(1)
                [v,pix(i)]=max(out(i,:));
                [v,tix(i)]=max(testout(i,:));
            end
            
            for i=1:l(1)
                if(pix(i)==tix(i))
                    accuracy=accuracy+1;
                end
            end
            accuracy=accuracy/l(1);
            
        end
        
        
        function cost=computecostSimple_with_BP(G,x)
            
            %Get weight matrix from genome data
            n=G.NumberOfNodes;
            node_mask=ones(1,n);
            weights_mask=ones(size(x));
            weights=x;
            weightMatrix=G.createWeightMatrix(weights);
            weight_mask_Matrix=G.createWeightMatrix(weights_mask);
            
            l=size(G.Inputs);
            m=size(G.Target);
            
            out=zeros(l(1),m(2));
            %Compute the ouputs of all the nodes in the network for the
            %given input
            for i=1:l(1)
                for j=1:n
                    G.MegaNode(j)=G.MegaNode(j).Evaluate(j,node_mask,G.MegaNode,weightMatrix,weight_mask_Matrix,l(2),m(2),G.Inputs(i,:),n);
                end
                %Take the output of last m(2) nodes as the net output.
                p=0;
                for j=1:m(2)
                    p=p+1;
                    out(i,j)=G.MegaNode(end-m(2)+p).output;
                end
            end
            
            
            %out=out';
            out= performBP(G,10,out,node_mask,weightMatrix,weight_mask_Matrix);
            cost=0;
            %Compute error as sum of mean squared error between predicted and expected.
            for i=1:length(G.Target)
                for j=1:m(2)
                    cost=cost+(out(i,j)-G.Target(i,j))^2;
                end
            end
            
            
            
        end
        
        function out= performBP(G,n_iter,out,node_mask,weightMatrix,weight_mask_Matrix)
            for i=1:n_iter
                peo=G.compute_pd_error_out(out,G.Target);
                G=compute_bp_errors(G,peo);
                weightMatrix=update_weights(G,weightMatrix,weight_mask_Matrix);
                out=evaluate(G,node_mask,weightMatrix,weight_mask_Matrix);
            end
            
        end
        
        function G=compute_bp_errors(G,peo)
            n=G.NumberOfNodes;
            for i=n:-1:1
                G.MegaNode(i)=G.MegaNode(i).compute_pd_out_net();
                G.MegaNode(i)=G.MegaNode(i).compute_pd_error_out(G.MegaNode,peo);
            end
        end
        
        
        function  weightMatrix=update_weights(G,weightMatrix,weight_mask_Matrix)
            
            for i=1:G.NumberOfNodes
                for j=i:G.NumberOfNodes
                    if(weight_mask_Matrix(i,j)==1)
                        
                        if(i==j)
                            weightMatrix(i,j)=weightMatrix(i,j)-G.bp_learning_rate*G.MegaNode(j).pd_out_net*G.MegaNode(j).pd_error_out;
                            
                        else
                            
                            weightMatrix(i,j)=weightMatrix(i,j)-G.bp_learning_rate*G.MegaNode(i).output*G.MegaNode(j).pd_out_net*G.MegaNode(j).pd_error_out;
                        end
                        
                    end
                end
            end
            
        end
        
        function out=evaluate(G,node_mask,weightMatrix,weight_mask_Matrix)
            l=size(G.Inputs);
            m=size(G.Target);
            
            out=zeros(l(1),m(2));
            %Compute the ouputs of all the nodes in the network for the
            %given input
            n=G.NumberOfNodes;
            for i=1:l(1)
                for j=1:n
                    G.MegaNode(j)=G.MegaNode(j).Evaluate(j,node_mask,G.MegaNode,weightMatrix,weight_mask_Matrix,l(2),m(2),G.Inputs(i,:),n);
                end
                %Take the output of last m(2) nodes as the net output.
                p=0;
                for j=1:m(2)
                    p=p+1;
                    out(i,j)=G.MegaNode(end-m(2)+p).output;
                end
            end
            
            
        end
        
        
        
        function peo=compute_pd_error_out(G,out,target)
            m=size(target);
            peo=zeros(1,m(2));
            for i=1:m(2)
                for j=1:m(1)
                    peo(i)=peo(i)+out(j,i)-target(j,i);
                end
            end
            
        end
        
        
        function plotConfusionMatrix(G,out,target)
            
            figure, plotconfusion(target,out)
        end
        
        
        
        
        
        
        
        
    end
end
