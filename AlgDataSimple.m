classdef AlgDataSimple
    
    properties
        weightMatrix;
        out;
        Inputs;
        Target;
        
        
    end
    methods
        
        function A=AlgDataSimple(G,x,Inputs,Target)
            
            %Compute the node_mask, weight_mask and weight Matrix from
            %the genome data.
            A.Inputs=Inputs;
            A.Target=Target;
            A.weightMatrix=G.createWeightMatrix(x);
            
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
%             cost=0;
%             m=size(A.Target);
%             
            %             %Compute error as sum of mean squared error between predicted and expected.
            %             for i=1:length(A.Target)
            %                 for j=1:m(2)
            %                     cost=cost+(A.out(i,j)-A.Target(i,j))^2;
            %                 end
            %             end
            
            cost=sum(sum((A.out-A.Target).^2));
            
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





