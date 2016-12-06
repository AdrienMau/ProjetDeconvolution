function [I0,dI0,chi]=gs2(file,sl);
%----------------
% FRAP-Analysis -
% without fitting
%----------------
% syntax: gs2(file,sl)
%         sl     ='ln' : semilog plot
%                  else: linear plot
%------------------------------



clf
global M delta_t tmax nx ny 
hold off
M=160;D=1;


[data,par]=pmisread(file);
nx=par(1)/par(3);ny=par(2)/par(4);t1=0;t2=165;
pre=zeros(ny-1,nx-1);
ind=0;
ix=1;
for iy=1:par(4)
   pre=pre+data((iy-1)*ny+1:iy*ny-1,(ix-1)*nx+1:ix*nx-1);
end
pre=pre/par(4);

for ix=2:par(3)
    for iy=1:par(4)
         ind=ind+1;
         sub=data((iy-1)*ny+1:iy*ny-1,(ix-1)*nx+1:ix*nx-1);
         sub=sub-pre;
         fsub=abs(fft2(sub));
         diff(ind,1)=fsub(1,1);
         diff(ind,2)=fsub(1,2);
         diff(ind,3)=fsub(2,1);
         diff(ind,4)=fsub(2,2);
    end
end

delta_t=t2-t1;
tmax=length(diff(:,1))*delta_t-delta_t;
ind=0:delta_t:tmax;
ind=ind*4*pi^2*(M/27)^2/1000;
u=ind/(nx-1)^2;v=ind/(ny-1)^2;



% plot
%-----
if (sl=='lg')
   semilogy(u,diff(:,2),'kx',v,diff(:,3),'co',u+v,diff(:,4),'m+')
else
   plot(u,diff(:,2),'kx',v,diff(:,3),'co',u+v,diff(:,4),'m+')
end



title ([file,'           no bleach'])
xlabel('4 * pi^2 * q^2 * t (s/æm^2)')
ylabel('I')



