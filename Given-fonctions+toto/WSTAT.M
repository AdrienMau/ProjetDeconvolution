function [m,s,sm] = wstat (x,dx)
%-----------------------------------------------------------
% WSTAT.M - calculation of weighted statistics
%
% usage: [m,s,sm] = wstat (x,dx)
%
% input: x  - data
%        dx - standard-deviation of the data
%
% output:  m  - weighted mean
%          s  - standard-deviation
%          sm - standard-deviation of the mean
%
% date: 29.5.1995
% author: ts
% version: <01.00> from <950529.0000>
%-------------------------------------------------------------
if nargin<2, help wstat, return, end

[ny,nx] = size(x);
if (ny>1)
  n = ny;
else
  n = nx;
end

m  = sum(x./dx) ./ sum(1./dx);
s  = sqrt (sum((x-ones(ny,1)*m).^2+dx.^2) / (n-1));
sm = s / sqrt(n);