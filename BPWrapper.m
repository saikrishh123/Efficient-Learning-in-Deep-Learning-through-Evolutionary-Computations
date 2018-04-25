%File BPWrapper.m
%Warapper Class to create, simulate , analyze and visualize backpropagation on the DAG network.
classdef BPWrapper
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
        
    end
    methods
        
        function G=BPWrapper(n,Inputs,Target,complex)
            % Intialize configuration and data
            
            G.NumberOfNodes=n;
            G.bp_learning_rate=0.1;
            
            %Create MegaNode
            MegaNode(n)=Node;
            G.MegaNode=MegaNode;
            
            G.Inputs=Inputs;
            G.Target=Target;
            %Set type of network.
            G.complex=complex;
            
            %end
            %Count number of variables for complex network
            G=G.compute_randomvariables_count();
            G=G.computeBounds();
            %Run genetic Algorithm
            x=rand(1,n*(n+1)/2);
            G=G.runBP(x);
            figure;
            if(complex==0)
                G=G.plotbestGraphSimple();
            else
                G=G.plotbestGraphComplex();
            end
            
            
           
            
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
            
            if(G.complex==1)
                n=G.NumberOfNodes;
                weights_count=(n*n-n)/2+n;
                LB=zeros(1,G.randomvariables);
                UB=ones(1,G.randomvariables);
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
        
        function G=compute_randomvariables_count(G)
            
            % Compute total variables count for a given value of n.
            n=G.NumberOfNodes;
            weights_count=(n*n-n)/2+n;
            nodes_mask_count=n;
            weights_mask_count=weights_count;
            
            G.randomvariables=weights_count+nodes_mask_count+weights_mask_count;
            
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
        
        
        function G=runBP(G,x)
            
            
            
            %Intialize random seed for reproducability
            rng(0, 'twister');
            
            n=G.NumberOfNodes;
            
            
            %func=@G.computecostSimple;
            if(G.complex==1)
                n_var=G.randomvariables;
                IC=[1:n+(n*n-n)/2+n];
                %func=@G.computecost;
                
            else
                n_var=G.w_count;
                IC=[];
                %func=@G.computecostSimple;
            end
            
            
                cost = computecostSimple_with_BP(G,x);
                
            
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
            niter=100
            l=size(x);
            [G.xbest,out]=perform_BP(G,x,niter,l(1));
            cost=0;
            %Compute error as sum of mean squared error between predicted and expected.
            for i=1:length(G.Target)
                for j=1:m(2)
                    cost=cost+(out(i,j)-G.Target(i,j))^2;
                end
            end
            
            
            
        end
        
        %         function out= performBP(G,n_iter,out,node_mask,weightMatrix,weight_mask_Matrix)
        %             for i=1:n_iter
        %             peo=G.compute_pd_error_out(out,G.Target);%BP
        %             G=compute_bp_errors(G,peo);%BP
        %             weightMatrix=update_weights(G,weightMatrix,weight_mask_Matrix);%BP
        %             out=evaluate(G,node_mask,weightMatrix,weight_mask_Matrix);%FP
        %             end
        %
        %         end
        %
        %         %Backward Pass
        %         function peo=compute_pd_error_out(G,out,target)
        %             m=size(target);
        %             peo=zeros(1,m(2));
        %             for i=1:m(2)
        %                 for j=1:m(1)
        %                 peo(i)=peo(i)+out(j,i)-target(j,i);
        %                 end
        %             end
        %
        %             end
        %
        %
        %         function G=compute_bp_errors(G,peo)
        %             n=G.NumberOfNodes;
        %             for i=n:-1:1
        %                 G.MegaNode(i)=G.MegaNode(i).compute_pd_out_net();
        %                 G.MegaNode(i)=G.MegaNode(i).compute_pd_error_out(G.MegaNode,peo);
        %             end
        %         end
        %
        %
        %         function  weightMatrix=update_weights(G,weightMatrix,weight_mask_Matrix)
        %
        %             for i=1:G.NumberOfNodes
        %                 for j=i:G.NumberOfNodes
        %                     if(weight_mask_Matrix(i,j)==1)
        %
        %                         if(i==j)
        %                             weightMatrix(i,j)=weightMatrix(i,j)-G.bp_learning_rate*G.MegaNode(j).pd_out_net*G.MegaNode(j).pd_error_out;
        %
        %                         else
        %
        %                             weightMatrix(i,j)=weightMatrix(i,j)-G.bp_learning_rate*G.MegaNode(i).output*G.MegaNode(j).pd_out_net*G.MegaNode(j).pd_error_out;
        %                         end
        %
        %                     end
        %                 end
        %             end
        %
        %         end
        %
        %
        %         %Forward Pass
        %         function out=evaluate(G,node_mask,weightMatrix,weight_mask_Matrix)
        %             l=size(G.Inputs);
        %             m=size(G.Target);
        %
        %             out=zeros(l(1),m(2));
        %             %Compute the ouputs of all the nodes in the network for the
        %             %given input
        %             n=G.NumberOfNodes;
        %             for i=1:l(1)
        %                 for j=1:n
        %                     G.MegaNode(j)=G.MegaNode(j).Evaluate(j,node_mask,G.MegaNode,weightMatrix,weight_mask_Matrix,l(2),m(2),G.Inputs(i,:),n);
        %                 end
        %                 %Take the output of last m(2) nodes as the net output.
        %                 p=0;
        %                 for j=1:m(2)
        %                     p=p+1;
        %                     out(i,j)=G.MegaNode(end-m(2)+p).output;
        %                 end
        %             end
        %
        %
        %         end
        %
        %
        
        
        
        
        
        
        function Kids=BackProp(G,Kids,niter,GenomeLength)
            
            l=size(Kids);
            for i=1:l(1)
                Kids(i,:)=perform_BP(G,Kids(i,:),niter,GenomeLength);
            end
            
        end
        
        function [Genome_new,out]=perform_BP(G,x,niter,GenomeLength)
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
            for k=1:niter
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
                    
                    [weightMatrix,weight_mask_Matrix,out]= performBP(G,1,out(i,:),node_mask,weightMatrix,weight_mask_Matrix,i);
                    
                end
            end
            
            
            %out=out';
            Genome_new=constructGenome(G,weightMatrix,weight_mask_Matrix,GenomeLength);
            
            
        end
        
        function Genome_new=constructGenome(G,weightMatrix,weight_mask_Matrix,GenomeLength)
            
            n=G.NumberOfNodes;
            Genome_new=zeros(1,GenomeLength);
            w=weightMatrix;
            p=0;
            for i=1:n
                for j=i:n
                    p=p+1;
                    Genome_new(p)=w(i,j);
                end
            end
            
        end
        
        
        
        
        function [weightMatrix,weight_mask_Matrix,out]= performBP(G,n_iter,out,node_mask,weightMatrix,weight_mask_Matrix,I)
            for i=1:n_iter
                peo=compute_pd_error_out(G,out,G.Target(I,:));
                disp(peo)
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
        
        
        
        
        
        
        
    end
end
