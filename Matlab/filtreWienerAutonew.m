function [REST,mu] = filtreWienerAutonew(Data,RI,D,nbIterations)

%The same as the filtreWiener funcion, operates the deconvolution of the Data matrix (who itself is the result of
%a convolution by the psf RI) by using a regularized Wiener filter.
%The difference is that a loop first automatically determine the mu
%parameter of the filtreWiener function.

% Arguments:
% [in] Data : Convoluted image
% [in] RI : the psf of the system
% [in] D : Regularisation filter
% [in] nbIterations : numbers of iterations of the algorithm
% [out] REST : the result of the deconvolution

%Initializing the alpha and beta parameters
alphab = 0;
betab = inf;

alphax = 0;
betax = inf;

%On passe tout en fourier
fourierpsf = MyFFT2RI(RI,size(Data,1),size(Data,2));
fourierregfilter = MyFFT2RI(D,size(Data,1),size(Data,2));
fourierdata = MyFFT2(Data,size(Data,1),size(Data,2));

%Initialisation de l'estimateur x
samplex = Data;
fourierestimator = MyFFT2(samplex,size(Data,1),size(Data,2));

for k=1:floor(nbIterations)

%Sample de gammab
ymoinsHx = fourierdata - fourierpsf.*fourierestimator;
squarederror = sum(sum(conj(ymoinsHx).*ymoinsHx)); 
    
alpha = alphab + size(Data,1)*size(Data,2)/2;
unsurbeta = 1/betab + squarederror/2;

samplegammab = RNDGamma(alpha,1/unsurbeta);

%Sample de gammax
normePidex = fourierregfilter.*fourierestimator;
squarednormePidex = sum(sum(conj(normePidex).*normePidex));

alpha = alphax + size(Data,1)*size(Data,2)/2;
unsurbeta = 1/betax + squarednormePidex/2;

samplegammax = RNDGamma(alpha,1/unsurbeta);

%Sample the object of interest x
fourierinvcovariance = samplegammab*conj(fourierpsf).*fourierpsf + samplegammax*conj(fourierregfilter).*fourierregfilter;
fouriercovariance = 1./fourierinvcovariance;

fouriermean = samplegammab*fouriercovariance.*conj(fourierpsf).*fourierdata;

fourierestimator = RNDGauss(fouriermean,fouriercovariance);

end
 
mu=abs(samplegammax/samplegammab);
REST = filtreWiener(Data,RI,mu,D);

    
function Res = MyFFT2(Data,N,M)	
% Calcul
	Res = fft2(Data,N,M)/sqrt(N*M);

function Res = MyFFT2RI(RI,N,M)	

% Paramètre de taille
	DemiNRI = floor(size(RI,1)/2);
    DemiMRI = floor(size(RI,2)/2);
    DemiN = floor(N/2);
    DemiM = floor(M/2);
% Calcul
	Tmp = zeros(N,M);
    %The mod elements are adjustments in case size(RI)is pair
	Tmp ( 1+DemiN-DemiNRI:1+DemiN+DemiNRI-mod(size(RI,1)+1,2) , 1+DemiM-DemiMRI:1+DemiM+DemiMRI-mod(size(RI,2)+1,2) ) = RI; 
	Res = fft2(Tmp,N,M);

function Res = MyIFFT2(Data,N,M)	
% Calcul
	Res = fftshift(ifft2(Data,N,M)*sqrt(N*M));
    
function SamplePrecision = RNDGamma(Alpha,Beta)	

% Tirage d'un échantillon Gamma approché par du Gauss
	SamplePrecision = Alpha*Beta + sqrt( Alpha*Beta*Beta ) * randn;  
    
function SampleImage = RNDGauss(MoyGauss,Covariance)	
    
% Tirage d'un bruit blanc avec la bonne symétrie
	BoutGauss = randn(size(MoyGauss,1),size(MoyGauss,2)) + sqrt(-1) * randn(size(MoyGauss,1),size(MoyGauss,2));
	BoutGauss = MyFFT2( real( MyIFFT2(BoutGauss,size(MoyGauss,1),size(MoyGauss,2))) ,size(MoyGauss,1),size(MoyGauss,2));

% Filtrage du bruit blanc
	SampleImage = MoyGauss + BoutGauss .* sqrt(Covariance);