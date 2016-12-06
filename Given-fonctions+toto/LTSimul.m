function [image,m,s]=ltimage(n,np,t0,b)
% LTSIMUL.M - Simulation of lifetime imaging
% The signal is localized in a square area in
% the middle of the image. The lifetime is set
% to 1.
%
% date: 16-06-2000
% author: ts
% version: <00.00> from <000616.0000>
%-----------------------------------------------
%parameter of the simulation
if nargin<1
   n  = 20		%image size, the total will be 50% larger
end
if nargin<2
   np = 20		%mean number of photons per position
end
if nargin<3
   t0 = 0.7		%time to sort into 2nd channel
end
if nargin<4
   b  = 5   	%mean background per channel
end

%initialize internal arrays
image = poissrnd(np,n,n);
early = zeros(n,n);
late  = zeros(n,n);

%create the images
for y=1:n
   for x=1:n
      lt = exprnd(1,image(y,x),1);
      late(y,x) = length(find(lt>t0));
   end
end
early = image - late;

%blow up images and add noise
nm = ceil(n*0.25);
%image = b + sqrt(b)*randn(n+2*nm);
%image = round((image+abs(image))/2);
image = poissrnd(b,n+2*nm,n+2*nm);
image(nm+1:nm+n,nm+1:nm+n) = image(nm+1:nm+n,nm+1:nm+n) + early;
early = image;

%image = b + sqrt(b)*randn(n+2*nm);
%image = round((image+abs(image))/2);
image = poissrnd(b,n+2*nm,n+2*nm);
image(nm+1:nm+n,nm+1:nm+n) = image(nm+1:nm+n,nm+1:nm+n) + late;
late  = image;

image = early + late;
tau   = t0 ./ log(early./late+1); 
m=mean(mean(tau(nm+1:nm+n,nm+1:nm+n)))
s=std(std(tau(nm+1:nm+n,nm+1:nm+n)))

%plot the result
ca = [0,max(image(:))];
subplot(2,2,1)
imagesc(image),title(sprintf('Image, np=%d, b=%d',np,b)),caxis(ca)
colorbar

subplot(2,2,2)
imagesc(tau),title(sprintf('tau, t0=%.2f',t0)),caxis([0,3])
colorbar

subplot(2,2,3)
imagesc(early),title('Early'),caxis(ca)

subplot(2,2,4)
imagesc(late),title('Late'),caxis(ca)
