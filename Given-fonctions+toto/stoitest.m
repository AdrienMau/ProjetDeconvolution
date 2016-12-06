
function [t, y, h, pdef] = stiotest(tau, init, t, p, hin)

if nargin<6
   hin=[1 2];
end

if nargin<5
   p=[0.1 0.05];
end

if length(p)==1
   p= [p, p/2];
end

if p(1)<p(2)
   p= [p(2) p(1)];
end

if nargin<4
   t=linspace(0,1,1000);
end

n=length(init)-1;
matr=(-diag(0:n)+diag(1:n,1))./tau;

[t,y]=ode45('oligomer',t, init, [], matr);
h(1)=figure(hin(1));
plot(t,y);

par = sum(y.*(ones(size(y,1),1)*(0:n)),2);
par=par./par(1); par2=find(par<p(1) & par>p(2));

y2=[];

for i=2:n
   y2=[y2,(y(:,i)./(1-y(:,1)))];
end

h(2)=figure(hin(2));
%bar3(t(par2), y(par2,2:end), 'stacked');
bar(par(par2), y2(par2,:),'stacked');
set(get(get(h(2),'Children'),'Children'),'EdgeColor', 'none');

pdef=y2(par2(1),:);