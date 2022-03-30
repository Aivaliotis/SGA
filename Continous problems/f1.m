function out=f1(x)
    sum=0;
    for i=1:length(x)-1
        sum = sum + 100*(x(i+1)-x(i)^2)^2+(x(i)-1)^2;
    end
    out=sum;
end