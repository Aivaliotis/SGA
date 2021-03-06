function [y] = f7(x)
F=11.68;
f=sum(x.^2);
if 4*(x(1)-0.5)^2+2*(x(2)-0.2)^2+x(3)^2+0.1*x(1)*x(2)+0.2*x(2)*x(3)-16>0
    sign=1;
elseif 4*(x(1)-0.5)^2+2*(x(2)-0.2)^2+x(3)^2+0.1*x(1)*x(2)+0.2*x(2)*x(3)-16==0
    sign=0;
else
    sign=-1;
end
t1=(4*(x(1)-0.5)^2+2*(x(2)-0.2)^2+x(3)^2+0.1*x(1)*x(2)+0.2*x(2)*x(3)-16)*sign*(sign+1)/2;

if -(2*x(1)^2+x(2)^2-2*x(3)^2-2)>0
    sign=1;
elseif -(2*x(1)^2+x(2)^2-2*x(3)^2-2)==0
    sign=0;
else
    sign=-1;
end
t2=-(2*x(1)^2+x(2)^2-2*x(3)^2-2)*sign*(sign+1)/2;

y=1/(abs(F-f-(1000*t1^2+1000*t2^2))+0.01);

end