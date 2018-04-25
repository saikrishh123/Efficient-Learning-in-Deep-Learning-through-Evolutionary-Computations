function cost=computecostIris(G,x)
                
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
                
                 %Compute Predicted Distribution by applying softmax
                 %normalization
                out=sfmax(out);
               
                cost=0;
                %Compute error as sum of cross entropy error between predicted and expected.
                for i=1:length(G.Target)
                    for j=1:m(2)
                    cost=cost+-G.Target(i,j)*log2(out(i,j));
                    end
                end
            end
            