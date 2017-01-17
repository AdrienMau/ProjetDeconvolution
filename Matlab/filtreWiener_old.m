function REST = filtreWiener_old(Data,RI,mu,D)

%Operates the deconvolution of the Data matrix (who itself is the result of
%a convolution by the psf RI) by using a regularized Wiener filter.

% Arguments:
% [in] Data : Convoluted image
% [in] RI : the psf of the system
% [in] D : Regularisation filter
% [in] nbIterations : numbers of iterations of the algorithm
% [out] REST : the result of the deconvolution


%Calculate the N*N-points FFT2 of the impulse response
fourierpsf = MyFFT2RI(RI,size(Data,1),size(Data,2));

%Calculate the FFT2 of the regularisationFilter
fourierregfilter = MyFFT2RI(D,size(Data,1),size(Data,2));

%Construct the deconvolution filter
gpls = conj(fourierpsf)./(conj(fourierpsf).*fourierpsf+mu*conj(fourierregfilter).*fourierregfilter);

%Construction of the FFT of the observation matrix
fourierimage = MyFFT2(Data,size(Data,1),size(Data,2));

%Calculate the product between gpls and fourierimage
estimator = gpls .* fourierimage;

%Doing the inverse fourier transformation of the result
REST = MyIFFT2(estimator,size(estimator, 1), size(estimator, 2));

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
    1+DemiN-DemiNRI:1+DemiN+DemiNRI-mod(size(RI,1)+1,2)
	Tmp ( 1+DemiN-DemiNRI:1+DemiN+DemiNRI-mod(size(RI,1)+1,2) , 1+DemiM-DemiMRI:1+DemiM+DemiMRI-mod(size(RI,2)+1,2) ) = RI; 
	Res = fft2(Tmp,N,M);

function Res = MyIFFT2(Data,N,M)	
% Calcul
	Res = fftshift(ifft2(Data,N,M)*sqrt(N*M));
    