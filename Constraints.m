function [c, ceq] = Constraints(x)
y=computeparameters(x);
c=[-y(1) -y(2) -y(3) -y(4) -y(5)];
ceq=[];

end