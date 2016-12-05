function [r,x,y,phi]=calcR(d)

if ~rem(size(d,2),2) % this might be a x/y image
    x=d(:,1:(end/2)); y=d(:,(end/2+1):end);
    r=sqrt( x.^2 + y.^2 );
    phi=atan2(y,x);
else
    r=d;
end