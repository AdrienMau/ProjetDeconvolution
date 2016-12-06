tmax=1
dt=1000000;
x=0:0.1:tmax;y=[];z=[];
global rho a21 kp kisc kt;
a21=1*dt;kisc=0.01*dt;kt=0.01*dt;kp=1e-5*dt;
for rho=(2:1:3)*dt
[t,v]=ode45('niveau4',0,tmax,[1,0,0],1,0);
ifl=v(:,1)*(1/(2+(a21/rho)));
z=[z,interp1(t,ifl,x,'spline')];
y=[y,rho];
end


mesh(y,x,z)
xlabel ('rho')
ylabel (['t'])
zlabel ('I_f')


