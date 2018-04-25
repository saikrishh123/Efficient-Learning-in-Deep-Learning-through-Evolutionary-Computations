classdef AlgData
    
    properties
        weights_count;
        node_mask;
        weight_mask;
        weights;
        weightMatrix;
        weight_mask_Matrix;
        out;
        weights_activation_func_parameter;
        node_activation_func_parameter;
        Inputs;
        Target;
        w;
        
        
    end
    methods
        
        function A=AlgData(G,x,Inputs,Target,weights_activation_func_parameter,node_activation_func_parameter)
            
            %Compute the node_mask, weight_mask and weight Matrix from
            %the genome data.
            n=G.NumberOfNodes;
            A.Inputs=Inputs;
            A.Target=Target;
            A.w=G.w;
            if(nargin<5)
                A.weights_activation_func_parameter=100;
                A.node_activation_func_parameter=100;
            else
                A.weights_activation_func_parameter=weights_activation_func_parameter;
                A.node_activation_func_parameter=node_activation_func_parameter;
                
            end
            
            switch G.opts.networkType
                
                case 'custom'
                    A.weights_count=G.randomvariables;
                    A.node_mask=ones(1,G.randomvariables);
                    A.weights=x(1:end);
                    A.weightMatrix=G.FFnet.createWeightMatrix(A.weights);
                    A.weight_mask_Matrix=G.FFnet.weight_mask_matrix;
                    
                    
                otherwise
                    if(G.complex==1)
                        
                        
                        
                        if((G.opts.node_complete_enable==0)&&(G.opts.weights_complete_enable==0))
                            A.weights_count=(n*n-n)/2+n;
                            A.node_mask=x(1:n);
                            A.weight_mask=x(n+1:n+A.weights_count);
                            A.weights=x(n+A.weights_count+1:end);
                            A.weightMatrix=G.createWeightMatrix(A.weights);
                            A.weight_mask_Matrix=G.createWeightMatrix(A.weight_mask);
                        end
                        
                        if((G.opts.node_complete_enable==1)&&(G.opts.weights_complete_enable==0))
                            
                            A.weights_count=(n*n-n)/2+n;
                            A.node_mask=ones(1,n);
                            A.weight_mask=x(1:A.weights_count);
                            A.weights=x(A.weights_count+1:end);
                            A.weightMatrix=G.createWeightMatrix(A.weights);
                            A.weight_mask_Matrix=G.createWeightMatrix(A.weight_mask);
                            
                        end
                        
                        if((G.opts.node_complete_enable==0)&&(G.opts.weights_complete_enable==1))
                            
                            A.weights_count=(n*n-n)/2+n;
                            A.node_mask=x(1:n);
                            A.weight_mask=ones(1,A.weights_count);
                            A.weights=x(n+1:end);
                            A.weightMatrix=G.createWeightMatrix(A.weights);
                            A.weight_mask_Matrix=G.createWeightMatrix(A.weight_mask);
                            
                            
                            
                        end
                        
                        if((G.opts.node_complete_enable==1)&&(G.opts.weights_complete_enable==1))
                            
                            A.weights_count=(n*n-n)/2+n;
                            A.node_mask=ones(1,n);
                            A.weight_mask=ones(1,A.weights_count);
                            A.weights=x(1:end);
                            A.weightMatrix=G.createWeightMatrix(A.weights);
                            A.weight_mask_Matrix=G.createWeightMatrix(A.weight_mask);
                        end
                        
                        
                        
                        
                    else
                        
                        A.node_mask=ones(1,n);
                        A.weight_mask=ones(size(x));
                        A.weights=x;
                        A.weightMatrix=G.createWeightMatrix(A.weights);
                        A.weight_mask_Matrix=G.createWeightMatrix(A.weight_mask);
                        
                        
                    end
            end
        end
        
        
        
        function A= compute_outputs(A,G)
            l=size(A.Inputs);
            m=size(A.Target);
            
            A.out=zeros(l(1),m(2));
            %Compute the ouputs of all the nodes in the network for the
            %given input
            for i=1:l(1)
                for j=1:G.NumberOfNodes
                    G.MegaNode(j)=G.MegaNode(j).Evaluate(j,i,G,A);
                end
                %Take the output of last m(2) nodes as the net output.
                p=0;
                for j=1:m(2)
                    p=p+1;
                    A.out(i,j)=G.MegaNode(end-m(2)+p).output;
                end
            end
            
        end
        
        
        function cost=compute_SE(A,G)
            cost=0;
            m=size(A.Target);
            
            %Compute error as sum of mean squared error between predicted and expected.
            for i=1:length(A.Target)
                for j=1:m(2)
                    cost=cost+(A.out(i,j)-A.Target(i,j))^2;
                end
            end
            
        end
        
        
        function [cost,A]=compute_CE(A,G)
            l=size(A.Inputs);
            m=size(A.Target);
            
            %Compute Predicted Distribution by applying softmax
            %normalization
            for i=1:l(1)
                A.out(i,:)=sfmax(A.out(i,:));
            end
            
            cost=0;
            %Compute error as sum of cross entropy error between predicted and expected.
            for i=1:length(A.Target)
                for j=1:m(2)
                    if(A.out(i,j)==0)
                        cost=cost+-A.Target(i,j)*log2(0.000000001);
                    
                    else
                    cost=cost+-A.Target(i,j)*log2(A.out(i,j));
                    end
                end
            end
        end
        
        
        
        
    end
end





