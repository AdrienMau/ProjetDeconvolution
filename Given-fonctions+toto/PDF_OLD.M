function [t,f] = pdf_old (x, sig, Xmin, Xmax);
%--------------------------------------------------------------------
% PDF_OLD.M
% Generates the probability-density function for the given data
%
% usage:    [t,f] = pdf_old (data, sigma, Xmin, Xmax)
%
% input:    data  - data vector
%           sigma - standard deviations of the data (y+-dy)
%           Xmin  - user defined minimum value
%           Xmax  - user define maximum value
%
% output:   t     - value
%           f     - probability
%
%
% date: 21.6.1994
% author: wb & ts
% version: <01.02> from <950706.0000>
%-------------------------------------------------------------------
if nargin<2, help pdf_old, return, end

%check data fields
if (length(x)==0) | (length(sig)==0)
  t=0; f=0;
  return
end

%calculate region
nData = 250;
dSig  = 3;
il = find(x==min(x));
iu = find(x==max(x));
lb = x(il(1))-dSig*sig(il(1));
ub = x(iu(1))+dSig*sig(iu(1));
Mn = mean(x);
Sd = min(std(x),sqrt(Mn));
if nargin>2, lb = Xmin; end
if nargin>3, ub = Xmax; end

%X-values
t = lb:(ub-lb)/nData:ub;
f = zeros(1,nData+1);

%calculate the probabilities
for i=1:length(x)
  f = f + 1/sqrt(2*pi)/sig(i)*exp(-(t-x(i)).^2/2/sig(i)^2);
end;

%scale the complete area to 1
f = f / length(x) ;
