classdef Network
    properties
        N_Inputs;
        N_Outputs;
        Hidden_Array;
        NumberOfNodes;
        L_Matrix;
        weight_mask_matrix;
        graph;
        
    end
    methods
        function N=Network(nin,ha,nout)
            N.N_Inputs=nin;
            N.N_Outputs=nout;
            N.Hidden_Array=ha;
            N=N.compute_total_nodes();
            N=N.compute_H_matrix();
            N=N.compute_weight_mask_matrix();
            N=N.plot_graph();
            
        end
        
        function N=compute_total_nodes(N)
            N.NumberOfNodes=N.N_Inputs+N.N_Outputs+sum(N.Hidden_Array);
            
        end
        
        
        function N=compute_H_matrix(N)
            a=[N.N_Inputs N.Hidden_Array N.N_Outputs];
            p=0;
            b=0;
            for i=1:length(a);
                clear b;
                for j=1:a(i)
                    p=p+1;
                    b(j)=p;
                end
                m{i}=b;
            end
            N.L_Matrix=m;
        end
        
        function N=compute_weight_mask_matrix(N)
            
            w=zeros(N.NumberOfNodes,N.NumberOfNodes);
            for i=1:N.NumberOfNodes
                for j=1:N.NumberOfNodes
                    
                    
                    if((i==j)||N.feedforward_feasible(i,j))
                        w(i,j)=1;
                    end
                end
                
            end
            N.weight_mask_matrix=w;
            
            
        end
        
        
        function f=feedforward_feasible(N,i,j)
            l1=0;
            l2=0;
            f=0;
            for k=1:length(N.L_Matrix)
                if(ismember(i,N.L_Matrix{k}))
                    l1=k;
                end
                
                 if(ismember(j,N.L_Matrix{k}))
                    l2=k;
                end
                
            end
            
            if(l2-l1==1)
                f=1;
            end
            
        end
        
        function N=plot_graph(N)
             n=N.NumberOfNodes;
             p=0;
            %Create Directed Edge list with weights from node mask
            %weight mask data
            for i=1:n
             
                    for j=i:n
                       
                            if(N.weight_mask_matrix(i,j)==1)
                                p=p+1;
                                s(p)=i;
                                t(p)=j;
                                wts(p)=1;
                            end
                        
                    end
                
            end
            
            %Create directed Graph
            N.graph=digraph(s,t,wts);
            %plot the graph
            plot(N.graph,'EdgeLabel',N.graph.Edges.Weight);
            
        end
        
        function w=createWeightMatrix(N,x)
            w=zeros(N.NumberOfNodes,N.NumberOfNodes);
            e=N.graph.Edges.EndNodes;
            p=0;
            for i=1:size(e,1)
                p=p+1;
                w(e(i,1),e(i,2))=x(p);
            end
            
        end
        
        
    end
end




