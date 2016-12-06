% Signal.m
%
% author:gs
% 30.11.94
%
%
% determines the count rate of a 4-level-system
% as a function of laser-intensity,exposure-time
%
% mesh-range from I0(t0) to AnzI*dI(Anzt*dt) with an increment of dI(dt)
% I1,t1 indicate a fixed value of I,t for plot

clear
% plot range
dI=0.04;
I0=0;
AnzI=100;
dt=0.4;
t0=0;
Anzt=100;
t1=5;
I1=0.1;

% some definitions
c=3*10^8;
h=2*pi*10^(-34);
N_A=6*10^23;
NA=1.3;
n=1.518;
epsilon=5*10^6;
lambda=514*10^(-9);

% detection efficiencies
eta_ccd=0.86*0.625;
eta_f=0.53*0.96^10;
eta_coll=0.5*(1-sqrt(1-(NA/n)^2));
E=eta_ccd*eta_f*eta_coll;


% molecular parameters
asg=1/(4*10^(-9));
kisc=0.03*asg;
kt=1/(2*10^(-6));
kp=10^(-10)*asg;
phi=0.23;




% this generates the working-matrices
for i=1:Anzt
I(i,:)=(I0:dI:(AnzI-1)*dI);
end
for i=1:AnzI
t(:,i)=(t0:dt:(Anzt-1)*dt)';
end

texp=t;






% the solution of the 4-level-system
rho=I*10^9*lambda*epsilon*log(10)/(h*c*1000*N_A);
alpha=1./(1+(asg./rho));
%d=phi*asg./(kisc+kt./alpha).*1./(1+kt./(alpha.*kisc));
%plot(I(1,:),d(1,:))
%return
hilf=(alpha*kisc+kt+kp)/2;
s1=hilf+sqrt(hilf.^2-alpha*kisc*kp);
s2=hilf-sqrt(hilf.^2-alpha*kisc*kp);

ns=(alpha./(s1-s2)).*((s1-kt-kp).*exp(-s1.*t*10^(-3))-(s2-kt-kp).*exp(-s2.*t*10^(-3)));

Ifl=E*phi*alpha*asg./(s1-s2).*((1-(kt+kp)./s1).*(1-exp(-s1.*texp*10^(-3)))-(1-(kt+kp)./s2) ...
    .*(1-exp(-s2.*texp*10^(-3))));



% plotting
subplot(221)
mesh(I(1,:),texp(:,1)',Ifl)
xlabel('laser-intensity (mW/æm^2')
ylabel('texp (ms)')
zlabel('fluorescence-intensity (cnts/texp)')

subplot(223)
plot(I(1,:),Ifl(t1/dt,:))
xlabel('laser-intensity (mW/æm^2')
ylabel('fluorescence-intensity (cnts/texp)')
title(['texp = ',num2str(t1),'ms'])

subplot(224)
plot(texp(:,1)',Ifl(:,I1/dI))
xlabel('texp (ms)')
ylabel('fluorescence-intensity (cnts/texp)')
title(['I = ',num2str(I1),'mW/æm^2'])
