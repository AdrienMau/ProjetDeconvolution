function f=expf(a,ix,iy);
%
%--------------
% expf(a,ix,iy)
% calculate I*exp(D*i) from 0 to iy-1
% a=(I(1),I(2),...,D)
%--------------
global M delta_t tmax nx ny
le=length(a);


ind=0:delta_t:tmax;
ind=ind*4*pi^2*(M/27)^2/1000;
u=ind'/(nx-1)^2;v=ind'/(ny-1)^2;
q=[u,v,u+v];
b=(ones(1,length(ind)))'*a(1:3);
f=exp(-a(le)*q).*b;


