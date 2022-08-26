function [y] = f8(x)
F=-1.3777;
f=-(x(1)-2)^2-(x(2)-1)^2;
if x(1)-2*x(2)+1>0
    sign=1;
elseif x(1)-2*x(2)+1==0
    sign=0;
else
    sign=-1;
end
t1=(x(1)-2*x(2)+1)*sign*(sign+1)/2;

if -(-(x(1)^2/4)-x(2)^2+1)>0
    sign=1;
elseif -(-(x(1)^2/4)-x(2)^2+1)==0
    sign=0;
else
    sign=-1;
end
t2=(-(-(x(1)^2/4)-x(2)^2+1))*sign*(sign+1)/2;

y=1/(abs(F-f-(1000*t1^2+1000*t2^2))+0.01);

end