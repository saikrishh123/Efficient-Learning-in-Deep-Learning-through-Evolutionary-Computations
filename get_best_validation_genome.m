function xbest=get_best_validation_genome(G)
for i=1:size(G.GenerationStateInfo,1)
    
    valAcc(i)=G.GenerationStateInfo{i}.valAcc;
end

[v,idx]=min(valAcc);
xbest=G.GenerationStateInfo{i}.BestGenome;
end