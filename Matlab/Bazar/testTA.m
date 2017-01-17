%test findpeak

nu=-10:0.2:10;
L=length(nu);
f=zeros(1,L);
xmin=-50;
xmax=50;



for(i=1:L)
    fun = @(x) exp(-x.^2*nu(i).^-2).*(x);
    f(i)=integral(fun,xmin,xmax);
end
plot(nu,f)