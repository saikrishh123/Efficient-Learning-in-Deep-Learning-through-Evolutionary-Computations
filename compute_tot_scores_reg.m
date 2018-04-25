function A=compute_tot_scores_reg(A,dat)
Ax=A;
for i=1:size(A.ResultsWrapper,1)
for j=1:size(A.ResultsWrapper,2)
    disp(i)
    disp(j);
    Ax.ResultsWrapper{i,j}.xbest=get_best_validation_genome(Ax.ResultsWrapper{i,j});
     MegaNode(Ax.ResultsWrapper{i,j}.NumberOfNodes)=NodeSimple;
    Ax.ResultsWrapper{i,j}.MegaNode=MegaNode;
    score(i,j)=Ax.ResultsWrapper{i,j}.testComplex(dat.inputs,dat.targets)/size(dat.inputs,1);
    save score score
    disp(score(i,j));
end
end
    A.TotalScores=score;
    A.MeanTotal=mean(A.TotalScores);
    A.BestTotal=min(A.TotalScores);
end