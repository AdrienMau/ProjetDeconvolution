function [ bessel ] = bessel2(l)
%Create a 2D Bessel image, of size l*l
%use besselj of Matlab

%a ameliorer


L2=abs(l/2-0.5);
[X Y] = meshgrid(-L2:1:L2,-L2:1:L2);
R = sqrt(X.^2+Y.^2);
f = (2*besselj(1,2*pi*R(:))./R(:)).^2;
bessel=reshape(f,size(X));

end

