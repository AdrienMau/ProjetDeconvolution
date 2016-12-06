function   [image,params] = gentest (SNR, Npk, Nim)
%---------------------------------------------------------------------
% GENTEST.M
% Generate test image(s) with Gaussian peaks
%
% usage:  [image, params] = gentest (SNR, Npk, Nim)
%
% input:   SNR - signal/noise ratio
%          Npk - # of peaks
%	   Nim - # of successive images, with a peak diffusion constant D=1
%
% output:  image  - Nim x (40x40) image(s)
%          params - parameter for the Gaussians
%
% date: 1.8.1994
% author: ts
% version: <02.10> from <940424.0000>
%---------------------------------------------------------------------
if nargin<1, SNR=10,  end
if nargin<2, Npk=10, end
if nargin<3, Nim=1,  end

%system parameter
Isize     = 40;
Border    = 1;
NoiseBack = 14,    		%FWHM of background-noise
width     = 1.5,		%average width of the Gaussian FWHM
offset    = 0,                  %DC-offset of all images
D         = 1,                  %diffusion constant pxl^2/lag

%internal paramter
nb    = NoiseBack / (2*sqrt(2*log(2)));
nphot = SNR * NoiseBack
w     = width / (2*sqrt(2*log(2)));

%---------------------------------------------------------------------
%starting image
image = floor(nb*randn(Isize,Isize)+offset);
for i=1:Npk
  params(i,:) = [1,2+(Isize-4)*rand,2+(Isize-4)*rand, ...
                 width*(0.95+0.1*randn),0,offset];
  params(i,5) = nphot*4*log(2)/pi/params(i,4)^2;
  %for np=1:nphot
  %  hit = round(params(i,2:3)+w*randn(1,2));
  %  if hit(1)>=1 & hit(1)<=Isize & hit(2)>=1 & hit(2)<=Isize
  %    image(hit(2),hit(1)) = image(hit(2),hit(1)) + 1;
  %  end
  %end
  image = image + mcgauss([params(i,2:5),0],Isize,Isize);
  %image = image + gaussian(params(i,2:6),Isize,Isize);
end
mesh(image)

%the sequence images
for ii=2:Nim
  seqi = floor(nb*randn(Isize,Isize)+offset);
  for i=(ii-1)*Npk+1:ii*Npk
    params(i,:) = params(i-Npk,:);
    params(i,1) = ii;
    params(i,2) = params(i-Npk,2)+2*D*randn;
    params(i,3) = params(i-Npk,3)+2*D*randn;
    %for np=1:nphot
    %  hit = round(params(i,2:3)+w*randn(1,2));
    %  if hit(1)>=1 & hit(1)<=Isize & hit(2)>=1 & hit(2)<=Isize
    %    seqi(hit(2),hit(1)) = seqi(hit(2),hit(1)) + 1;
    %  end
    %end
    seqi = seqi + mcgauss([params(i,2:5),0],Isize,Isize);
    %seqi = seqi + gaussian(params(i,2:6),Isize,Isize);
  end
  image = [image; zeros(Border,Isize); seqi];
end

%add border
image = [image; zeros(Border,Isize)];
image = [image, zeros(Nim*(Isize+Border),Border)];
if Nim>1, pcolor(image), end
