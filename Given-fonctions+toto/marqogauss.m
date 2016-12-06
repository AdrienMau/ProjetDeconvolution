function [a,da,chi] = marqogauss(a,y,dy,Mopt)
%----------------------------------------------------------------------
% MARQOgauss.M
% Non-linear least-square fit using the Levenberg/Marquard algorithm.
% see: Bevington, 'Data Reduction and Error Analysis in Physical Sciences'
%
% call: [a,da,chi]=marquo(a,y<,dy<,options>>)
%
% input:
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
% version: <01.01> from <000804.0000> by WJ & GAB 
% 			  <02.00> from <000807.0000> by WJ & GAB
%					turn the routine upside down
% modifié par lc pour éviter pb de division par zéro ligne 53
% --------------------------------------------------------------------
% check input parameter and prepare internal variables
if nargin<2 , help marqo, chi=-1; da=-1; a=-1; return, end
if nargin<4, Mopt=[]; end

npar = prod(size(a));
[ymax,xmax] = size(y);
npnt = xmax*ymax;

if npar>=npnt , disp(['!! try it with nPoints>nParameter !!']), return, end

Mopt=fitopt(Mopt);
delta     = 0.01;
lambda    = 0.0001;
OutOpt    = Mopt(1);
chimin    = Mopt(2)*(npnt-npar);
dchimin   = Mopt(3)*(npnt-npar);
dpmin     = Mopt(4);
maxtry    = Mopt(5)*npar;
maxlambda = Mopt(6);
dpar      = 1;
oldchi    = 1e18;


if nargin==2
   dy = ones(ymax,xmax);
   issigma=0;
else
   dy = 1 ./dy;
   for i=1:ymax                 %evite pb de division par 0
       for j=1:xmax
           if dy(i,j)>100
              dy(i,j)=100;
           else
           end
       end
   end
   issigma=1;
end

dyvec = dy(:);
par=a;
deriv=zeros(npnt,npar);

if issigma
	b=(gaussian(par,xmax,ymax)-y).*dy;
	b=b(:); chi = b'*b;				% vectorized sum(sum(y^2))
else
	b=(gaussian(par,xmax,ymax)-y);
	b=b(:); chi = b'*b;
end

% --------------------------------------------------

tries=1; docontinue=1;
   
while docontinue
	% calculate function and chi squared
  
	ytry = gaussian(par,xmax,ymax);   
      
	if issigma
      b=(ytry-y).*dy; b=b(:); 
      newchi = b'*b;
	else
      b=(ytry-y); b=b(:); 
      newchi = b'*b;
	end
   
	if OutOpt==1, tries, newchi/(npnt-npar), end

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
	if (tries>=maxtry) | (chi<chimin) | (lambda>maxlambda) | (min(a./dpar')>1/dpmin) | (oldchi-chi<dchimin)
      lambda = 0;
      docontinue = 0;
  	else
      tries=tries+1;
   end
     


	%calculate the derivatives
	if chi==newchi
   	for i = 1:npar
	      par = a;
	      if a(i) == 0
   			par(i) = delta;
        		h = (gaussian(par, xmax, ymax)-ytry) / delta;
			else
				par(i) = a(i)*(1+delta);
				h = (gaussian(par, xmax, ymax)-ytry) / (delta*a(i));
		   end
         h = h(:);
         if issigma
            deriv(:,i) = h .* dyvec;
         else
            deriv(:,i) = h;
         end
		end
	end


	%calculate alpha and beta matrices
   if issigma
      h = (y-ytry) .* dy;
   else
      h = (y-ytry);
   end
     
	h = h(:);
	alpha = deriv' * deriv;
	alpha = alpha + lambda*diag(diag(alpha));
	beta  = deriv' * h;
   
   if lambda ~= 0
		% solve linear equation and actualize parameter
		%a, alpha, beta 
		if rank(alpha)==length(alpha)
   		%alpha = max(alpha,eps); beta = max(beta,eps);
			dpar = alpha \ beta;
			par = a + dpar';
		else
   		docontinue=0;
      end
   end
end

% ----------------------------------------------------

chi = newchi/(npnt-npar);
if rank(alpha)==length(alpha)
  alpha = inv(alpha);
  da    = (sqrt(chi) * sqrt(diag(alpha)))';
else
  da = a;
end
