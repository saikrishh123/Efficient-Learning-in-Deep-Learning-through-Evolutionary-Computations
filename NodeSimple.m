%File Node.m
%Class for computing the output of a node from its properties.

classdef NodeSimple
    
    properties
        output; % storing the ouput of the node
        ExternalInput; % Input data
        node_count; %total node count
           
    end
    methods
        
        %Constructor for creating object
        function S= NodeSimple
            S.output=0;
        end
        
        
        
        function Node=Evaluate(Node,number,Input_num,G,A)
            
            
            
            
            
            %Initaliaze external data
            Node.ExternalInput=A.Inputs(Input_num,:);
            
            
            %compute output of the node from above data
            Node=Node.compute_output(A.weightMatrix,G,number);
            
            
            
        end
        
        
        
   
        function Node= compute_output(Node,weightMatrix,G,number)
            sum=0;
            if((number<=G.N_Inputs))
                Node.output=Node.ExternalInput(number);
            else
                for i=1:number-1
                    
                    sum=sum+weightMatrix(i,number)*G.MegaNode(i).output;
                    
                end
                sum=sum+weightMatrix(number,number);
                if(number>=G.NumberOfNodes-G.N_Outputs+1)
                    %If 'output node' dont apply activation function
                    Node.output=sum;
                else
                    %apply Sigmoid activation on the net sum.
                    Node.output=sigmf(sum,[1,0]);
                end
                
            end
            
            
            
        end
        
        
        
        
    end
end
