function [I0,dI0,chi]=jacob(file,sl,offset);
%----------------
% FRAP-Analysis -
%----------------
% syntax: gs2(file,sl,offset)
%         sl     ='ln' : semilog plot
%                  else: linear plot
%         offset = 0   : no offset fitting
%                  1   : offset fitting
%------------------------------



clf
global M delta_t tmax nx ny 
hold off
M=160;D=1;

if (offset ~=0 & offset~=1)
    ['offset value invalid']
     return
end 
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


% fitting
%--------
if (offset==0)
   init=[diff(1,2),diff(1,3),diff(1,4),D];
   func='expf';
else
   le=length(diff(:,2));
   init=[diff(1,2),diff(1,3),diff(1,4),diff(le,2),diff(le,3),diff(le,4),D];
   func='expf_o';
end
[I0,dI0,chi]=marquard(func,init,diff(:,2:4),ones(size(diff,1),3),1);

% plot
%-----
if (sl=='lg')
   semilogy(u,diff(:,2)/I0(1),'kx',v,diff(:,3)/I0(2),'co',u+v,diff(:,4)/I0(3),'m+')
else
   plot(u,diff(:,2)/I0(1),'kx',v,diff(:,3)/I0(2),'co',u+v,diff(:,4)/I0(3),'m+')
end



% overlay fit
%------------
if (offset==0)
   I0=[I0(1:3),0,0,0,I0(4)];
   dI0=[dI0(1:3),0,0,0,dI0(4)];
end    
max_x=max(u+v);
ind=0:0.1:max_x;
hold on
me_i=mean(I0(4:6)./I0(1:3))
co=['k','c','m'];
for i=1:3
   hold on
   if (sl=='lg')
      semilogy (ind,exp(-I0(7)*ind)+I0(i+3)/I0(i),co(i))
   else
      plot(ind,exp(-I0(7)*ind)+I0(i+3)/I0(i),co(i))
   end   
end
text (1,1,['D = ',num2str(I0(7)),' +- ',num2str(dI0(7)),' µm^2/s'])
title (file)
xlabel('4 * pi^2 * q^2 * t (s/µm^2)')
ylabel('I / I0')
