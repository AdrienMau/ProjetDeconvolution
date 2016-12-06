function ChiProbFun = chipf(n,z)
%---------------------------------------------------------------
%
% CHIPF.M  -  chisquare probability function
%
% usage: ChiProbFun = chipf (n,z)
%
% date: 22.8.1994
% author: wb
% version: <00.00> from <940822.0000>
%---------------------------------------------------------------
if nargin<2, help chipf, end

nt = 1000;
t = 0:z/nt:z;
ChiProbFun=1/2^(n/2)/gamma(n/2)*sum(t.^(n/2-1).*exp(-t/2))*z/nt;

