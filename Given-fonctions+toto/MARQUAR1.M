function [a,da,chi] = marquar1 (func,a,y,dy,Mopt)
%----------------------------------------------------------------------
% MARQUAR1.M
% Non-linear least-square fit using the Levenberg/Marquard algorithm.
% see: Bevington, 'Data Reduction and Error Analysis in Physical Sciences'
%
% call: [a,da,chi] = marquar1 (func,a,y<,dy<,options>>)
%
% input:
%	func    - function definition x()=func(a,xmax<,ymax>)
%	a()     - fitting parameter
%	y()     - data array
%	dy()    - <optional> individual error in the y-array
%       options - see fitopt()
% output:
%	chi   - reduced chi-squared
%	a()   - fitted parameter
%       da()  - error in the fitting parameters
%
% date: 13.6.1994
% author: ts
% version: <01.00> from <940617.0000>
% --------------------------------------------------------------------
% check input parameter and prepare internal variables
if nargin<3 , help marquard, chi=-1; da=-1; a=-1; return, end
if nargin<5, Mopt=[]; end
npar = prod(size(a));
npnt = prod(size(y));
if npar>=npnt , disp(['!! try it with nPoints>nParameter !!']), return, end

Mopt=fitopt(Mopt);
delta     = 0.01;
lambda    = 0.0001;
OutOpt    = Mopt(1);
chimin    = Mopt(2);
dchimin   = Mopt(3);
dpmin     = Mopt(4);
maxtry    = Mopt(5)*npar;
maxlambda = Mopt(6);
dpar      = 1;
oldchi    = 1e18;

[ymax,xmax] = size(y);
f = [func,'(par,xmax'];
if ymax > 1
  f = [f,',ymax'];
end
f = [f,')'];

if nargin==3
  dy = ones(ymax,xmax);
end
dy = 1 ./dy;
dyvec = dy(:);
par=a;
chi = sum(sum(((eval(f)-y).*dy).^2)) / (npnt-npar);

% --------------------------------------------------

for try = 1:maxtry+1
  % calculate function and chi squared
  %try
  ytry = eval(f);
  newchi = sum(sum(((ytry-y).*dy).^2)) / (npnt-npar);
  if OutOpt==1, try, newchi, end

  %actualize parameter if chi sqared decreased 
  if newchi<chi 
    oldchi = chi;
    chi = newchi;
    lambda = 0.1*lambda;
    a = par;
  else
    lambda = 10*lambda;
  end


  %check for break condition
  if (try==maxtry) | (chi<chimin) | (lambda>maxlambda) | (min(a./dpar')>1/dpmin) | (oldchi-chi<dchimin)
      lambda = 0;
  end


  %calculate the derivatives
  if chi==newchi
    for i = 1:npar
      par = a;
      if a(i) == 0
        par(i) = a(i)+delta;
        h = (eval(f)-ytry) / delta;
      else
        par(i) = a(i)+delta*a(i);
        h = (eval(f)-ytry)/(delta*a(i));
      end
    h = h(:);
    deriv(:,i) = h .* dyvec;
    end
  %deriv
  end


  %calculate alpha and beta matrices
  h = (y-ytry) .* dy;
  h = h(:);
  alpha = deriv' * deriv;
  alpha = alpha + lambda*diag(diag(alpha));
  beta  = deriv' * h;
  if lambda == 0, break, end

  % solve linear equation and actualize parameter
  %a, alpha, beta 
  if rank(alpha)==length(alpha)
    %alpha = max(alpha,eps); beta = max(beta,eps);
    dpar = alpha \ beta;
    par = a + dpar';
  else
    break
  end
end

% ----------------------------------------------------

chi = newchi;
if rank(alpha)==length(alpha)
  alpha = inv(alpha);
  da    = (sqrt(chi) * sqrt(diag(alpha)))';
else
  da = a;
end
