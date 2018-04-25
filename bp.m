
%File bp.m
%Outputs the net activtions and error of XOR data for a gicen weight configurtion   
function [out,error]=bp(x,target,W)

if(nargin<3)
W=ones(1,9);
end
l=size(x);
%Simulate and get ouput for each input for the given configuration

for i=1:l(1)
 in=x(i,:);
out(i)=nn(in(1),in(2),W(1),W(2),W(3),W(4),W(5),W(6),W(7),W(8),W(9));
end
out=out';
error=0;
%Compute error as sum of mean squared error between predicted and expected.
for i=1:length(target)
    error=error+(out(i)-target(i))^2;
end


