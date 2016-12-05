function REST = filtreWiener(Data,RI,D,mu)

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
fourierimage = MyFFT2(Data,size(Data,1),size(Data,2));

%Calculate the product between gpls and fourierimage
estimator = gpls .* fourierimage;

%Doing the inverse fourier transformation of the result
REST = MyIFFT2(estimator,size(estimator, 1), size(estimator, 2));


end