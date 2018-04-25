classdef experimenter
    properties
        Inputdata;
        Targetdata;
        TrainInd;
        Algs;
        problemtype;
        SampleLengthVector;
        repetitions;
        AlgStructs;
        n;
        MeanTotal;
        StdTotal;
    end
    
    methods
        function E=experimenter(Inputdata,Targetdata,problemtype,Algs,n,SampleLengthVector)
            E.Inputdata=Inputdata;
            E.Targetdata=Targetdata;
            E.problemtype=problemtype;
            
            if(nargin<5)
                
                E.n=10;
            else
                E.n=n;
                
            end
            
            
            if(nargin<6)
                
                E.SampleLengthVector=[3,6,9,12,15,30,60,120,150];
            else
                E.SampleLengthVector=SampleLengthVector;
                
            end
            E.repetitions=10;
            E.Algs=Algs;
            E=E.generateIndices();
            E=E.createAlgStructs();
        end
        
        
        function E=generateIndices(E)
            for k=1:E.repetitions
                
                switch E.problemtype
                    
                    case 'regression'
                        Q=size(E.Inputdata,1);
                        for i=1:length(E.SampleLengthVector)
                            idx=randperm(Q, E.SampleLengthVector(i));
                            E.TrainInd{k,i}=idx(1:E.SampleLengthVector(i));
                            
                        end
                        
                    case 'classification'
                        
                        
                        Q=size(E.Inputdata,1);
                        %                         for i=1:length(E.SampleLengthVector)
                        %
                        %                             for j=1:3
                        %                                 idx=randperm(floor(Q/3), floor(E.SampleLengthVector(i)/3));
                        %                                 tr{j}=idx(1:E.SampleLengthVector(i)/3);
                        %
                        %                             end
                        %
                        %                             E.TrainInd{k,i}=[tr{1},50+tr{2},100+tr{3}];
                        %
                        %                         end
                        
                        
                        for i=1:length(E.SampleLengthVector)
                            
                            
                            idx= generateIndices(E.Inputdata,E.Targetdata,E.SampleLengthVector(i));
                            
                            
                            E.TrainInd{k,i}=idx;
                            
                        end
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    otherwise
                        warning('Currently supports regression and classifcation only');
                end
                
            end
        end
        
        function E= createAlgStructs(E)
            for i=1:length(E.Algs)
                E.AlgStructs{i}=AlgStruct(E,i);
            end
            
        end
        
        function E=addAlgStruct(E,description,totscores)
            
            l=size(E.Algs,2);
            E.Algs{l+1}=description;
            E.AlgStructs{l+1}=AlgStruct(E,l+1);
            if(nargin>=3)
                E.AlgStructs{l+1}.TotalScores=totscores;
                E.AlgStructs{l+1}=E.AlgStructs{l+1}.computeMetrics_BP;
                
            end
            
        end
        
        
        function E=display_Results(E)
            
            for i=1:size(E.Algs,2)
                m=E.AlgStructs{i}.MeanTotal;
                if(isempty(m))
                    E.MeanTotal(i,:)=zeros(1,4);
                    E.StdTotal(i,:)=zeros(1,4);
                
                
                else
                    
                E.MeanTotal(i,:)=E.AlgStructs{i}.MeanTotal;
                E.StdTotal(i,:)=E.AlgStructs{i}.StdTotal;
                
                end
                
                
            end
            
            ax1=subplot(2,1,1);
            plot(E.SampleLengthVector./size(E.Targetdata,2), E.MeanTotal');
            switch E.problemtype
                case 'regression'
                    ylabel('Score');
                    xlabel('Sample Count');
                    title('Mean Score');
                    
                case  'classification'
                    ylabel('Accuracy');
                    xlabel('Sample Count (per class)');
                    title('Mean Accuracy');
                    
                    
            end
            legend(ax1,E.Algs(1:end))
            
            
            
            ax2=subplot(2,1,2);
            plot(E.SampleLengthVector./size(E.Targetdata,2),E.StdTotal');
            
            switch E.problemtype
                case 'regression'
                    ylabel('Score');
                    xlabel('Sample Count');
                    title('Standard Deviation of Scores');
                    
                case  'classification'
                    ylabel('Standard Deviation');
                    xlabel('Sample Count (per class)');
                    title('Standard Deviation of Accuracy');
                    
                    
            end
            
            legend(ax2,E.Algs(1:end))
            
            
            
            
        end
        
        
        
        
    end
    
    
    
    
    
    
    
end



