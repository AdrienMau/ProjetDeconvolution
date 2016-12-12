function REST = filtreWiener(Data,RI,D,mu)

if nargin<2
n=3;
x = -20:20; x=exp(-x.*x/n);
RI=transpose(x)*x;
D = [0.01,0.2,0.01;0.2,4,0.2;0.01,0.2,0.01];
mu=0.05;
end

%Calculate the N*N-points FFT2 of the impulse response
fourierpsf = MyFFT2RI(RI,size(Data,1),size(Data,2));
%Calculate the FFT2 of the regularisationFilter
fourierregfilter = MyFFT2RI(D,size(Data,1),size(Data,2));
%Construct the gpls array
gpls= ones(size(Data, 1), size(Data, 2));
for i=1:size(Data,1)
    for j=1:size(Data, 2)
     gpls(i,j) = conj(fourierpsf(i,j))/((abs(fourierpsf(i,j)))*(abs(fourierpsf(i,j))) + mu*(abs(fourierregfilter(i,j)))*(abs(fourierregfilter(i,j))));
    end
end
%Construction of the FFT of the observation matrix
%fourierimage = MyFFT2(Data,size(Data,1),size(Data,2));
fourierimage = fft2(Data)/sqrt(size(Data,1)*size(Data,2));
%Calculate the product between gpls and fourierimage
estimator = gpls .* fourierimage;
%Doing the inverse fourier transformation of the result
%REST = MyIFFT2(estimator,size(estimator, 1), size(estimator, 2));
REST = fftshift(ifft2(estimator))*sqrt(size(Data,1)*size(Data,2));
REST = (REST-mean(mean(REST)))/(max(max(REST))-mean(mean(REST)));


function Res = MyFFT2RI(RI,N,M)
% Paramètre de taille
DemiN = floor(size(RI,1)/2);
DemiM = floor(size(RI,2)/2);
% Calcul
Tmp = zeros(N,M);
Tmp ( 1+N/2-DemiM:1+N/2+DemiM , 1+M/2-DemiM:1+M/2+DemiM ) = RI;
Res = fft2(Tmp,N,M);