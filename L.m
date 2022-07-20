function [ret]=L(l,p,x)

ret=0;
for m=0:p
    ret=ret+(-1)^m * factorial(p+l)/(factorial(p-m)*factorial(l+m)*factorial(m))*x.^m;
end
