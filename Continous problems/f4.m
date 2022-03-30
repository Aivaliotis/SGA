function out=f4(x)
    out=20+exp(1)-20*exp(-0.2*sqrt(sum(x.^2)/length(x)))-exp(sum(2*pi*x)/length(x));
end