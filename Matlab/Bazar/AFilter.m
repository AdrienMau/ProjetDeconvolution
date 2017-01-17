function [ img2 ] = AFilter( img,fsize,ftype,lambda,s)
%AFILTER
%Filter an image with usual filter: Inverse (s=0), Wiener (s=1), Cannon (s=0.5)...

% IN :
%     img: image to filter
%     fsize: size of the filtering element
%     ftype:    
%         'horizontal'
%         'vertical'
%         'square'
%         'circle' / 'disk'
%         'gaussian'
%         'bessel'  --TO ADD
%     lambda: parameter for Wiener (usually 0 to 1)
%     s : parameter for switching from Inverse (0) to Wiener (1)
% OUT :
%     img2: filtered image

%FILTER
switch ftype
    case 'horizontal'
        f(1,1:fsize) = 1;
    case 'vertical'
        f(1:fsize,1) = 1;
    case 'square'
        f(1:fsize,1:fsize) = 1;
    case 'circle'
        f = fspecial('disk',fsize);
    case 'disk'
        f = fspecial('disk',fsize);
    case 'gaussian'
        f = fspecial('gaussian',fsize,round(fsize/2));
end
f= f / sum(f(:)); %normalisation

Ff = fft2(f);
H = fft2(f,m,n);
Cc = Ff.*Hh;
c = real(ifft2(Cc));

%....



end

