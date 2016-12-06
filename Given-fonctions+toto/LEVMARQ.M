function [a,da,chi] = levmarq (func,a,z,x,y,dz,Mopt)
%----------------------------------------------------------------------
% LEVMARQ.M
% Non-linear least-square fit using the Levenberg/Marquard algorithm.
% see: Bevington, 'Data Reduction and Error Analysis in Physical Sciences'
%
% call: [a,da,chi] = levmarq (func,a,z,x[,y[,dz[,options]]])
%
% input:
%       func    - function definition z=func(x,y,a)
%       a()     - fitting parameter
%       z()     - data array, z(M,N)
%       x()     - x-array, x(N)
%       y()     - <optional> y-array (otherwise y=0), y(M)
%       dz()    - <optional> individual error in the y-array, dz(M,N)
%       options - <optional> see fitopt()
% output:
%       chi   - reduced chi-squared
%       a()   - fitted parameter
%       da()  - error in the fitting parameters
%
% date: 13.6.1994
% author: ts
% version: <02.00> from <951201.0000>
% --------------------------------------------------------------------
% check input parameter and prepare internal variables
if nargin<4 , help levmarq, chi=-1; da=-1; a=-1; return, end
if nargin<5, y=0; end
if nargin<6, dz=ones(size(z));end
if nargin<7, Mopt=[]; end

npar=length(a);
npnt=prod(size(z));
if npar>=npnt , disp(['!! try it with nPoints>nParameter !!']), return, end

Mopt=fitopt(Mopt);
delta     = 0.01;
lambda    = 0.0001;
OutOpt    = Mopt(1);
chimin    = Mopt(2);
chimin    = eps;
dchimin   = Mopt(3);
dchimin   = eps;
dpmin     = Mopt(4);
dpmin     = eps;
maxtry    = Mopt(5)*npar;
maxlambda = Mopt(6);
dpar      = 1;
oldchi    = 1e18;

if nargin<5
   f=[func,'(x,par)'];
else
   f=[func,'(x,y,par)'];
end
dz=1./dz;
dzvec=dz(:);
par=a;
chi=sum(sum(((eval(f)-z).*dz).^2)) / (npnt-npar);

% --------------------------------------------------

for versuch = 1:maxtry+1
   % calculate function and chi squared
   %try
   ztry = eval(f);
   newchi = sum(sum(((ztry-z).*dz).^2)) / (npnt-npar);
   if OutOpt==1, versuch, newchi, end
   
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
   if (versuch==maxtry) | (chi<chimin) | (lambda>maxlambda) | (min(a./dpar')>1/dpmin) | (oldchi-chi<dchimin)
      lambda = 0;
   end
   
   
   %calculate the derivatives
   if chi==newchi
      for i = 1:npar
         par = a;
         if a(i) == 0
            par(i) = a(i)+delta;
            h = (eval(f)-ztry) / delta;
         else
            par(i) = a(i)+delta*a(i);
            h = (eval(f)-ztry)/(delta*a(i));
         end
         h = h(:);
         deriv(:,i) = h .* dzvec;
      end
      %deriv
   end
   
   
   %calculate alpha and beta matrices
   h = (z-ztry) .* dz;
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
