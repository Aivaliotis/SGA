function out=f3(x)
    sum1=0;
    for i=1:length(x)
       sum1=sum1+x(i)^2-10*cos(2*pi*x(i)); 
    end
    out=10*length(x)+sum1;
end