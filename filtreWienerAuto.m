function [REST,mu] = filtreWienerAuto(Data,RI,D,nbIterations)

alphab = 0;
betab = inf;

alphax = 0;
betax = inf;

if (nbIterations<4)
   nbIterations = 10;
end

%On passe tout en fourier
fourierpsf = MyFFT2RI(RI,size(Data,1),size(Data,2));
fourierregfilter = MyFFT2RI(D,size(Data,1),size(Data,2));
fourierdata = MyFFT2(Data,size(Data,1),size(Data,2));

%Initialisation
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

% Quelques tests
	if nargin~=3
	error('Ne sait faire que si 3 arguments en entrée')
	end

% Calcul
	Res = fft2(Data,N,M)/sqrt(N*M);
    
    
function Res = MyFFT2RI(RI,N,M)	

% Paramètre de taille
	DemiN = floor(size(RI,1)/2);
    DemiM = floor(size(RI,2)/2);
% Calcul
	Tmp = zeros(N,M);
	Tmp ( 1+N/2-DemiN:1+N/2+DemiN , 1+M/2-DemiM:1+M/2+DemiM ) = RI; 
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