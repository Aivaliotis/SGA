function out=f2(x)
    paragodiko = 1;
    for i=1:length(x)
        paragodiko = paragodiko * cos(x(i)/sqrt(i));
    end
    out=1+1.4000*(sum(x.^2))-paragodiko;
end