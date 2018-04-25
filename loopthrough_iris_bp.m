load fisheriris.mat
irispreprocessing
for n=1:50
save n n
disp('Running:')
disp(n)
indat=[meas(1:n,:);meas(51:50+n,:);meas(101:100+n,:)];
outdat=[out(1:n,:);out(51:50+n,:);out(101:100+n,:)];
trainInd=[1:n,51:50+n,101:100+n];
actfunc='logsig';
[a,ta,net]=iris_bp(meas',out',trainInd,actfunc);
acc_bp_iris_log_sig(n)=a;
disp(a);
save acc_bp_iris_log_sig acc_bp_iris_log_sig;




end
