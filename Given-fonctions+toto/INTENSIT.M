function [I,dI] = intensity (A);
%---------------------------------------------------
% INTENSITY.M  -  calculates the intensity from a
%		  peak-file
%
% usage: [I,dI] = intensity (A)
%
%		A - matrix read from a .pk-file
%
%
% date: 2.6.1995
% author: ts
% version: <01.00> from <950602.0000>
%----------------------------------------------------

I  = pi / 4 / log(2) * A(:,5) .* A(:,4).^2;
dI = sqrt((A(:,10)./A(:,5)).^2 + (2*A(:,9)./A(:,4)).^2) .* I;
dI = dI / sqrt(5);
