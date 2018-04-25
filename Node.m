%File Node.m
%Class for computing the output of a node from its properties.

classdef Node
    
    properties
        number; % Store the node Id
        active;
        % To store if the node is an active part of the final network
        %(only for complex case)
        in_neighbours;%in_neigbours array
        out_neighbours;%in_neigbours array
        
        inputs;%inputs from in_neigbours
        in_weights;%weights connected to in_neighbors
        out_weights;
        out_weights_mask;
        weights_mask;%mask to see if the link is active or not
        bias;% storing bias of the node
        output; % storing the ouput of the node
        N_inputs; %Total number of inputs in the data
        N_outputs;%Total number of outputs in the data.
        ExternalInput; % Input data
        node_count; %total node count
        pd_error_out;
        % computing parial derivate w.r.t to total error (future work)
        pd_out_net;
        %computing partial derivate of node ouput w.r.t net (future work)
        activation_function;
        mode; %discrete or continous mode;
        weights_probability;
        node_probability;
        weights_activation_func_parameter;
        node_activation_func_parameter;
        bias_mask;
        bias_probabilty;
        
        
        
        
        
        
    end
    methods
        
        %Constructor for creating object
        function S= Node
            
            S.number=0;
            S.active=0;
            S.in_neighbours=0;
            S.in_weights=0;
            S.weights_mask=0;
            S.bias=0;
            S.output=0;
            S.N_inputs=1;
        end
        
        
        
        function Node=Evaluate(Node,number,Input_num,G,A)
            %Initaliaze node number
            Node.number=number;
            
            %Initialize mode;
            Node.mode=G.mode;
            %Initaliaze node count
            Node.node_count=G.NumberOfNodes;
            
            %Initaliaze total inputs in the data
            Node.N_inputs=G.N_Inputs;
            
            %Initaliaze total outputs in the data
            Node.N_outputs=G.N_Outputs;
            
            
            Node.weights_activation_func_parameter=A.weights_activation_func_parameter;
            Node.node_activation_func_parameter=A.node_activation_func_parameter;
            
            
            %Initaliaze external data
            Node.ExternalInput=A.Inputs(Input_num,:);
            %Compute in_neighbors from node_mask;
            Node=Node.compute_in_neighbours(A.node_mask);
            
            %Compute out_neighbors from node_mask;
            Node=Node.compute_out_neighbours(A.node_mask);
            
            %set Node inputs
            Node=Node.set_inputs(G.MegaNode);
            
            if(Node.mode==0)
                %set node active status
                Node=Node.set_active_status(A.node_mask);
            else
                Node=Node.set_node_probability(A.node_mask);
            end
            
            %set node bias from weight matrix -w(n,n)
            Node=Node.set_bias(A.weightMatrix);
            
            
            
            %compute in_weights from weight matrix
            Node=Node.set_in_weights(A.weightMatrix);
            
            if(Node.mode==0)
                %set in neighbours weight mask
                Node=Node.set_in_weights_mask(A.weight_mask_Matrix);
                
            else
                %set in weights probability
                Node=Node.set_in_weights_probability(A.weight_mask_Matrix);
                
            end
            
            
            %compute out_weights from weight matrix
            Node=Node.set_out_weights(A.weightMatrix);
            
            %set out neighbours weight mask
            Node=Node.set_out_weights_mask(A.weight_mask_Matrix);
            
            
            %compute output of the node from above data
            if(Node.mode==0)
                Node=Node.compute_output();
            else
                Node=Node.compute_output_probability_mode();
                
            end
            
            
            
        end
        
        function Node=compute_pd_out_net(Node)
            %Future work for integrating backpropagation
            if(Node.number>=Node.node_count-Node.N_outputs+1)
                Node.pd_out_net=1;
            else
                Node.pd_out_net=Node.output*(1-Node.output);
            end
        end
        
        function Node=compute_pd_error_out(Node,MegaNode,pd_etot_out)
            %Future work for integrating backpropagation
            s=0;
            o=Node.out_neighbours;
            offset=Node.node_count-Node.N_outputs;
            if((o(1)==-1)&&(Node.number>offset))
                s=s+pd_etot_out(Node.number-offset);
            else
                for i=1:length(Node.out_neighbours)
                    if(Node.out_weights_mask(i)==1)
                        s=s+MegaNode(o(i)).pd_error_out*MegaNode(o(i)).pd_out_net*Node.out_weights(i);
                    end
                    
                end
                
                if(Node.number>offset)
                    s=s+pd_etot_out(Node.number-offset);
                end
                
                
                
            end
            
            Node.pd_error_out=s;
            
            
            
        end
        
        
        function Node=compute_in_neighbours(Node,node_mask)
            
            %Compute the in neighbours of the node from the node mask
            %1 represents In-neighbour as long as the node number is less
            %than its number
            k=Node.number;
            p=0;
            Node.in_neighbours=-1;
            %Check if the node is an input node.
            if(k<=Node.N_inputs)
                
                %No in neighbours for input node.
                Node.in_neighbours=-1;
            else
                for i=1:k-1
                    if(node_mask(i))
                        p=p+1;
                        Node.in_neighbours(p)=i;
                    end
                    
                end
            end
        end
        
        
        function Node=compute_out_neighbours(Node,node_mask)
            
            %Compute the out neighbours of the node from the node mask
            %1 represents out-neighbour as long as the node number is
            %greater
            %than its number
            k=Node.number;
            p=0;
            Node.out_neighbours=-1;
            %Check if the node is the last node.
            if(k==Node.node_count)
                
                Node.out_neighbours=-1;
            else
                for i=k+1:Node.node_count
                    if(node_mask(i)&&(i>Node.N_inputs))
                        p=p+1;
                        Node.out_neighbours(p)=i;
                    end
                    
                end
            end
        end
        
        
        
        
        
        
        
        function Node=set_inputs(Node,MegaNode)
            %Check if the node is an input node
            if((Node.number<=Node.N_inputs)||(Node.in_neighbours(1)==-1))
                Node.inputs=-1;
            else
                
                % Get outputs of in neighbours and set them as input to the
                % node
                for i=1:length(Node.in_neighbours)
                    Node.inputs(i)=MegaNode(Node.in_neighbours(i)).output;
                end
                
            end
            
        end
        
        
        function Node=set_in_weights(Node,weightMatrix)
            %Check if the node is an input node
            
            if((Node.number<=Node.N_inputs)||(Node.in_neighbours(1)==-1))
                Node.in_weights=-1;
            else
                % Get weights connecting from in neighbours and set in
                % weights matrix
                
                for i=1:length(Node.in_neighbours)
                    Node.in_weights(i)=weightMatrix(Node.in_neighbours(i),Node.number);
                end
                
            end
        end
        
        
        function Node=set_in_weights_mask(Node,weightMatrix)
            %Check if the node is an input node
            
            if((Node.number<=Node.N_inputs)||(Node.in_neighbours(1)==-1))
                Node.weights_mask=-1;
            else
                % Get weights mask connecting from in neighbours and set in
                % weights mask matrix
                
                for i=1:length(Node.in_neighbours)
                    Node.weights_mask(i)=weightMatrix(Node.in_neighbours(i),Node.number);
                end
                
            end
            
            Node.bias_mask=weightMatrix(Node.number,Node.number);
        end
        
        
        
        
        function Node=set_in_weights_probability(Node,weightMatrix)
            %Check if the node is an input node
            
            if((Node.number<=Node.N_inputs)||(Node.in_neighbours(1)==-1))
                Node.weights_probability=-1;
            else
                % Get weights mask connecting from in neighbours and set in
                % weights mask matrix
                
                for i=1:length(Node.in_neighbours)
                    Node.weights_probability(i)=weightMatrix(Node.in_neighbours(i),Node.number);
                end
                
            end
            
            Node.bias_probabilty=weightMatrix(Node.number,Node.number);
            
        end
        
        
        
        
        
        
        function Node=set_out_weights(Node,weightMatrix)
            
            if((Node.number==Node.node_count)||(Node.out_neighbours(1)==-1))
                Node.out_weights=-1;
            else
                % Get weights connecting to out neighbours and set out
                % weights matrix
                
                for i=1:length(Node.out_neighbours)
                    Node.out_weights(i)=weightMatrix(Node.number,Node.out_neighbours(i));
                end
                
            end
        end
        
        
        function Node=set_out_weights_mask(Node,weightMatrix)
            %Check if the node is an input node
            
            if((Node.number==Node.node_count)||(Node.out_neighbours(1)==-1))
                Node.out_weights_mask=-1;
            else
                % Get weights mask connecting to out neighbours and set out
                % weights mask matrix
                
                for i=1:length(Node.out_neighbours)
                    Node.out_weights_mask(i)=weightMatrix(Node.number,Node.out_neighbours(i));
                end
                
            end
        end
        
        
        
        
        
        function Node=set_active_status(Node,node_mask)
            %Set if the node is present in the network or not.
            Node.active=node_mask(Node.number);
        end
        
        function Node=set_node_probability(Node,node_mask)
            %Set if the node is present in the network or not.
            Node.node_probability=node_mask(Node.number);
        end
        
        
        function Node=set_bias(Node,weightMatrix)
            %Set the bias of the node
            Node.bias=weightMatrix(Node.number,Node.number);
        end
        
        
        
        
        
        function Node= compute_output(Node)
            sum=0;
            %Compute the ouput of the node
            %Check if the node is active. If not the output is 0.
            if(Node.active)
                %Check if the node is an input node. If yes get the inputs
                %from external data.
                if((Node.number<=Node.N_inputs))
                    Node.output=Node.ExternalInput(Node.number);
                else
                    for i=1:length(Node.in_neighbours)
                        
                        if(Node.weights_mask(i))
                            sum=sum+Node.in_weights(i)*Node.inputs(i);
                        end
                        
                    end
                    if(Node.bias_mask)
                        sum=sum+Node.bias;
                    end
                    if(Node.number>=Node.node_count-Node.N_outputs+1)
                        %If 'output node' dont apply activation function
                        Node.output=sum;
                    else
                        %apply Sigmoid activation on the net sum.
                        Node.output=sigmf(sum,[1,0]);
                    end
                    
                end
                
            else
                Node.output=0;
                
                
            end
            
        end
        
        
        
        
        
        
        function Node= compute_output_probability_mode(Node)
            sum=0;
            %Compute the ouput of the node
            
            %Check if the node is an input node. If yes get the inputs
            %from external data.
            if((Node.number<=Node.N_inputs))
                Node.output=Node.ExternalInput(Node.number);
            else
                for i=1:length(Node.in_neighbours)
                    
                    
                    sum=sum+Node.in_weights(i)*Node.inputs(i)*sigmf(Node.weights_probability(i)-0.5,[Node.weights_activation_func_parameter,0]);
                    
                    
                end
                
                sum=sum+Node.bias*sigmf(Node.bias_probabilty-0.5,[Node.weights_activation_func_parameter,0]);
                
                if(Node.number>=Node.node_count-Node.N_outputs+1)
                    %If 'output node' dont apply activation function
                    Node.output=sum;
                else
                    %apply Sigmoid activation on the net sum.
                    Node.output=sigmf(sum,[1,0]);
                end
                
            end
            
            Node.output=Node.output*sigmf(Node.node_probability-0.5,[Node.node_activation_func_parameter,0]);
            
            
            
        end
        
    end
    
    
    
    
    
    
    
    
    
    
end
