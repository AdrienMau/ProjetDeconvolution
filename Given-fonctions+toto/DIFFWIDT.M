function [result,fitresult] = diffwidt (Mode)
%------------------------------------------------------------
% DIFFWIDTH.M
% simulation of the broadening of the peaks due to diffusion
%
%
% usage: [result,fitresult] = diffwidt (Mode)
%
% input:	Mode - (o) >0 graphical output
%			   <0 no graphical output
%			   +-1,3 behavior with varying till (D=1.43um^2/s)
%			   +-2,3 behavior with varying D (till=5ms)
%
% output:	result    - [till,D,width,dwidth,chi]
%		fitresult - [till,D,[Marquard output]
%
%
% date : 28.1.1995
% author : ts
% version : <01.00> from <950128.000>
%------------------------------------------------------------
if nargin<1, Mode=-1; end

%system parameter
D0  = 1.43	,% standard diffusion constant (um^2/s)
pxl = 0.27	,% pixel width (um)
T   = 5		,% standard illumination time (ms)
nph = 172	,% # photons in time given in T
tpp = T/nph	,% average time between 2 photons (ms)
w   = 1		,% width of Gaussian FWHM (pxl)

%parameter of the simulation
a    = 20	,% size of the image field (pxl)
ntry = 100	,% # of tries per point
ts   = 0.1	;% loop in till
te   = 40 	;%
dt   = 2	;%
Ds   = 0.1      ;% loop in D
De   = 5        ;%
dD   = 0.3      ;%

%internal parameter
p0        = [a/2,a/2];
if Mode>0, OMode=1; else, OMode=0; end
Mode      = abs(Mode);
s         = w/(2*sqrt(2*log(2))); %sigma-width of the Gaussian
result    = [];
fitresult = [];

% ------------------------------------------------------
% variation of till
if Mode==1 | Mode==3
D = D0
l  = sqrt(4*D*1.E-3*tpp) / pxl ,% mean diffusion length between 2 photons

for till=ts:dt:te
  till
  nphot = round(till/tpp)
  for try=1:ntry
    p = p0;
    z = zeros(a,a);
    for np=1:nphot
      hit = p + s*randn(size(p));
      z(hit(1),hit(2)) = z(hit(1),hit(2)) + 1;
      p = p + l*randn(size(p));
    end
    [x,dx,chi] = marquard ('gaussian',[p0,w,max(max(z)),0],z);
    result = [result;till,D,x(3),dx(3),chi];
    fitresult = [fitresult;till,D,x,dx,chi];
    if OMode~=0
      fitresult
      y = gaussian (x,a,a);
      subplot (221), mesh(z)
      subplot (223), mesh(y)
      subplot (224), mesh(z-y)
      pause (1)
    end
  end
  mean(result(find(result(:,1)==till),3))
end
end

% ------------------------------------------------------
% variation of D
if Mode==2 | Mode==3
till  = T
nphot = round(till/tpp)

for D=Ds:dD:De
  D
  l = sqrt(4*D*1.E-3*tpp) / pxl ,% mean diffusion length between 2 photons
  for try=1:ntry
    p = p0;
    z = zeros(a,a);
    for np=1:nphot
      hit = p + s*randn(size(p));
      z(hit(1),hit(2)) = z(hit(1),hit(2)) + 1;
      p = p + l*randn(size(p));
    end
    [x,dx,chi] = marquard ('gaussian',[p0,w,max(max(z)),0],z);
    result = [result;till,D,x(3),dx(3),chi];
    fitresult = [fitresult;till,D,x,dx,chi];
    if OMode~=0
      fitresult
      y = gaussian (x,a,a);
      subplot (221), mesh(z)
      subplot (223), mesh(y)
      subplot (224), mesh(z-y)
      pause (1)
    end
  end
  mean(result(find(result(:,2)==D),3))
end
end
%---------------------------------------------------------------------
%that's it    
