classdef AlgStruct
    properties
        Description;%
        TrainScores;%
        TotalScores;
        MeanTrain;%
        MeanTotal;%
        BestTotal;
        StdTrain;%
        StdValidation;%
        StdTotal;%
        AlgCostFunc;%
        ResultsWrapper;%
        BestIndvidual;%
        BestVal;%
        TrainInd;%
        InputData;%
        TargetData;%
        optns;%
        problemType;
        repetitions;%
        net;
        n;
        
        
    end
    
    methods
        function A=AlgStruct(E,num)
            A.Description=E.Algs{num};
            A.TrainInd=E.TrainInd;
            A.InputData=E.Inputdata;
            A.TargetData=E.Targetdata;
            A.problemType=E.problemtype;
            A.n=E.n;
            A.repetitions=E.repetitions;
            
            
            A=A.createOpts();
            %A=A.runAlg();
            
            
            
        end
        
        
        function A=createOpts(A)
            opts.n=A.n;
            if(size(A.InputData,1)<=20000)
                opts.TestInputs=A.InputData;
                opts.TestTargets=A.TargetData;
                
            else
                valInd=randperm(size(A.InputData,1),200);
                opts.TestInputs=A.InputData(valInd,:);
                opts.TestTargets=A.TargetData(valInd,:);
            end
            opts.weights_activation_func_parameter=100000;
            opts.node_activation_func_parameter=100000;
            opts.objective=0; %(0-single objective 1-mulitobjective)
            opts.parallel=true;
            opts.population_size=5000;
            opts.max_gen=500;
            opts.networkType='complete';
            opts.continue=1;
            
            
            
            switch A.Description
                case 'gaSimple'
                    
                    opts.node_complete_enable=1;
                    opts.weights_complete_enable=1;
                    opts.mode=0; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='ga';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                    
                    
                case 'gaComplexDiscrete'
                    opts.node_complete_enable=0;
                    opts.weights_complete_enable=0;
                    opts.mode=0; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='ga';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                case 'gaComplexDiscrete_NodeComplete'
                    
                    
                    opts.node_complete_enable=1;
                    opts.weights_complete_enable=0;
                    opts.mode=0; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='ga';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                case 'gaComplexContinous'
                    
                    
                    opts.node_complete_enable=0;
                    opts.weights_complete_enable=0;
                    opts.mode=1; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='ga';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                case 'gaComplexContinous_NodeComplete'
                    
                    opts.node_complete_enable=0;
                    opts.weights_complete_enable=0;
                    opts.mode=1; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='ga';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                    
                case 'psoSimple'
                    
                    opts.node_complete_enable=1;
                    opts.weights_complete_enable=1;
                    opts.mode=0; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='pso';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                    
                    
                    
                case 'psoComplexContinous'
                    
                    
                    opts.node_complete_enable=0;
                    opts.weights_complete_enable=0;
                    opts.mode=1; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='pso';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                case 'psoComplexContinous_NodeComplete'
                    
                    opts.node_complete_enable=0;
                    opts.weights_complete_enable=0;
                    opts.mode=1; %(0 -Discrete ,1-Continous (Probability Mode))
                    opts.Alg='pso';
                    switch A.problemType
                        case 'regression'
                            opts.funcName='computecost';
                        case 'classification'
                            opts.funcName='computecostIris';
                    end
                    
                    
                    
                case 'bpTanh'
                    
                case 'bpLogsig'
                    
            end
            A.optns=opts;
            
            
        end
        
        function A=runAlg(A,expstartnum,expEndnum)
            indat=A.InputData;
            tardat=A.TargetData;
            save  indat indat
            save  tardat tardat
            if(nargin<2)
               row=1;
               col=1;
            else
                row=expstartnum(1);
               col=expstartnum(2);
           
            end
            
            if(nargin<3)
               rowE=size(A.TrainInd,1);
               colE=size(A.TrainInd,2);
            else
                rowE=expEndnum(1);
               colE=expEndnum(2);
           
            end
            
            
            for i=row:rowE
                for j=col:colE
                    val1=i;
                    val2=j;
                    save val1 val1
                    save val2 val2
                    if(A.Description(1)=='g'||A.Description(1)=='p')
                        A.optns.Inputs=A.InputData(A.TrainInd{i,j},:);
                        A.optns.Target=A.TargetData(A.TrainInd{i,j},:);
                        A.ResultsWrapper{i,j}=GAWrapper(A.optns);
                        save A A;
                        
                    else
                        disp('In Iteration');
                        disp(strcat(num2str(i),'.',num2str(j)));
                        
                        switch A.problemType
                            case 'regression'
                                
                                
                                if(A.Description(3)=='T')
                                    [A.TotalScores(i,j),A.TrainScores(i,j), A.net{i,j}]=ffreg(A.InputData',A.TargetData',A.TrainInd{i,j},'tanh');
                                    save A A;
                                else
                                    [A.TotalScores(i,j),A.TrainScores(i,j), A.net{i,j}]=ffreg(A.InputData',A.TargetData',A.TrainInd{i,j},'logsig');
                                    save A A;
                                    
                                    
                                end
                                
                                
                                
                            case 'classification'
                                
                                
                                if(A.Description(3)=='T')
                                    [A.TotalScores(i,j),A.TrainScores(i,j), A.net{i,j}]=iris_bp(A.InputData',A.TargetData',A.TrainInd{i,j},'tanh');
                                    save A A;
                                else
                                    [A.TotalScores(i,j),A.TrainScores(i,j), A.net{i,j}]=iris_bp(A.InputData',A.TargetData',A.TrainInd{i,j},'logsig');
                                    save A A;
                                    
                                    
                                end
                        end
                    end
                    
                    
                end
            end
        end
        
        
        function A=continue_experiment_ga(A,expnum)
            global StateInfo
            G=A.ResultsWrapper{expnum(1),expnum(2)};
            G.total_gen_count=G.output_pop.generations;
            G.opts.continue=2;
            G=G.runGA();
            G.extraInfo=StateInfo(1:G.output_pop.generations);
            A.ResultsWrapper{expnum(1),expnum(2)}=G;
            
            
        end
        
        
        function A=create_new_experiment_ga(A,expnum,maxgen)
            if(nargin>=3)
                A.optns.max_gen=maxgen;
            end
            A.optns.continue=2;
            i=expnum(1);
            j=expnum(2);
            val1=i;
            val2=j;
            save val1 val1
            save val2 val2
            A.optns.Inputs=A.InputData(A.TrainInd{i,j},:);
            A.optns.Target=A.TargetData(A.TrainInd{i,j},:);
                        
            pop= A.ResultsWrapper{expnum(1),expnum(2)}.population;
            gs=A.ResultsWrapper{expnum(1),expnum(2)}.GenerationStateInfo;
            
            scores= A.ResultsWrapper{expnum(1),expnum(2)}.scores;
            save pop pop
            save scores scores
            
            G=GAWrapper(A.optns);
            G.GenerationStateInfo=[gs,G.GenerationStateInfo];
            A.ResultsWrapper{expnum(1),expnum(2)}=G;  
            
            save A A;
            
            
        end
        
        
        
        
        function A=computeMetrics(A)
            
            g=A.ResultsWrapper;
            for i=1:1
                for j=1:size(g,2)
                    gs=g{i,j}.GenerationStateInfo;
                    for k=1:length(gs)
                        v(k)=gs{k}.valAcc;
                    end
                    best(i,j)=min(v);
                    
                end
            end
            
            A.TotalScores=best;
            for i=1:size(g,2)
                A.MeanTotal(i)=mean(best(:,i));
                A.BestTotal(i)=min(best(:,i));
                
            end
            A.StdTotal=std(A.TotalScores);
            
            
        end
        
        
        function A=computeMetrics_BP(A)
            
            A.MeanTotal=mean(A.TotalScores);
            A.StdTotal=std(A.TotalScores);
        end
        
        
        
        function A=computeMetricsClassification(A)
            
            g=A.ResultsWrapper;
            for i=1:1
                for j=1:size(g,2)
                    gs=g{i,j}.GenerationStateInfo;
                    for k=1:length(gs)
                        v(k)=gs{k}.valAcc;
                    end
                    best(i,j)=max(v);
                    
                end
            end
            
            A.TotalScores=best;
            for i=1:size(g,2)
                A.MeanTotal(i)=mean(best(:,i));
                A.BestTotal(i)=max(best(:,i));
                
            end
            A.StdTotal=std(A.TotalScores);
            
            
        end
        
        
        
        function plot_Results(A)
            
            subplot(1,2,1);
            for i=1:size(A.TrainInd,2)
                SampleLengthVector(i)=size(A.TrainInd{1,i},2);
            end
            
            plot(SampleLengthVector./size(A.TargetData,2),A.MeanTotal);
            switch A.problemType
                case 'regression'
                    ylabel('Mean Square Error');
                    xlabel('Sample Count');
                    title('Mean of Mean Square Errors');
                    
                case  'classification'  
                    ylabel('Accuracy');
                    xlabel('Sample Count (per class)');
                    title('Mean Accuracy');
                    
                    
            end
            
            
            
            subplot(1,2,2);
            plot(SampleLengthVector./size(A.TargetData,2),A.StdTotal);
            
            switch A.problemType
                case 'regression'
                    ylabel('Standard Deviation');
                    xlabel('Sample Count');
                    title('Standard Deviation of MSE');
                    
                case  'classification'
                    ylabel('Standard Deviation');
                    xlabel('Sample Count (per class)');
                    title('Standard Deviation of Accuracy');
                    
                    
            end
            
            
            
        end
        
        
        
        
        
        
    end
    
end