% Konz.m
%
% author:gs
% date:  2.12.94
%
% evaluation of the probability to detect "i" dyes 
% in an area "l^2" at the concentration "concentr"
% 4 subplots are generated
% the range of the x-axe is limited by "limit"


% concerning the subplots
clear
l=1*2700;
A=70;
concentr=[5*10^(-9),1*10^(-8),5*10^(-8),1*10^(-7)]
limit=[6,10,20,40]



% some specifications
var=l^2/A;
var1(1)=1;
for a=1:200;
var1(a+1)=var1(a)*a;
end;


% subplot 1
c=concentr(1);
for i=0:limit(1)
k=1;
for a=1:i
k=k*(var-a+1);
end
k=k/var1(i+1);
x(i+1)=i;
p(i+1)=c^i*(1-c)^(var-i)*k;
end
subplot(221)
stairs(x,p)
title(['c=',num2str(c)])
xlabel ('dyes in area')
ylabel ('probability')


% subplot 2
c=concentr(2);
for i=0:limit(2)
k=1;
for a=1:i
k=k*(var-a+1);
end
k=k/var1(i+1);
x(i+1)=i;
p(i+1)=c^i*(1-c)^(var-i)*k;
end
subplot(222)
stairs(x,p)
title(['c=',num2str(c)])
xlabel ('dyes in area')
ylabel ('probability')


% subplot 3
c=concentr(3);
for i=0:limit(3)
k=1;
for a=1:i
k=k*(var-a+1);
end
k=k/var1(i+1);
x(i+1)=i;
p(i+1)=c^i*(1-c)^(var-i)*k;
end
subplot(223)
stairs(x,p)
title(['c=',num2str(c)])
xlabel ('dyes in area')
ylabel ('probability')


% subplot 4
c=concentr(4);
for i=0:limit(4)
k=1;
for a=1:i
k=k*(var-a+1);
end
k=k/var1(i+1);
x(i+1)=i;
p(i+1)=c^i*(1-c)^(var-i)*k;
end
subplot(224)
stairs(x,p)
title(['c=',num2str(c)])
xlabel ('dyes in area')
ylabel ('probability')

