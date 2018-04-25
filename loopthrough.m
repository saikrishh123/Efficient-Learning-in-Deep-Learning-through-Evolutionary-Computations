load fisheriris.mat
load R_GA_ir_simple
load acc_iris_simple
for n=45:50
save n n
disp('Running:')
disp(n)
indat=[meas(1:n,:);meas(51:50+n,:);meas(101:100+n,:)];
outdat=[out(1:n,:);out(51:50+n,:);out(101:100+n,:)];

G=GAWrapper(10,indat,outdat,0,'irisSimple');
[O,a,c]=G.testIris(meas,out);

R_GA_ir_simple(n)=G;
save R_GA_ir_simple R_GA_ir_simple
acc_iris_simple(n)=a;
save acc_iris_simple acc_iris_simple;




end
