function icorr = ifilter (image)
%------------------------------------------------------------------------------
% FIlter.M
% Tries to find peaks in the image given. Method: the peaks are pre-selected
% using a matched gaussian filter and than each peak is fitted to a Gaussian
% by means of a least-square fitting procedure.
%
%
% call: result = findpeak (image,option)
%
% input:        image  -    array of data points in which peaks should be found
%               option -(o) see fitopt()
%
% output:       result - result-matrix [:;X0,Y0,W,H,O,dX0,dY0,dW,dH,dO,chi,test] with
%                        X0, Y0 - peak position
%                        W      - peak width
%                        H      - peak heigth
%                        O      - constant offset
%                        d...   - variances in each parameter
%                        chi    - reduced chi-squared
%                        test   - [ChiTest,ExpTest,FTest] test for the fit
%                                 see fittest()
%
%
% author: wb & ts
% version: <02.12> from <940410.0000>
%-----------------------------------------------------------------------------
%set internal variables
fOpt=[];

[fOpt,TLimit] = fitopt (fOpt);
fOpt(1)   = 2;
OutOpt    = fOpt(1); 
gwidth    = fOpt(7);
gsize     = fix(fOpt(8)/2)*2+1;
threshold = fOpt(9)*fOpt(9);
FitOpt    = fOpt(10);
peak      = 0;
gs2       = fix(gsize/2);
[ysize,xsize] = size(image);
MaxThrAdj = 10;
MaxNoPk   = 4 * xsize*ysize / gwidth^2;

%prepare a Gaussian for the correlation-filter
gauss = gaussian([gs2+1,gs2+1,gwidth,1,0],gsize,gsize);

%and a crosscorrelated one for the subtraction
xgauss = xcorr2 (gauss,gauss);
xgauss = xgauss(gs2+1:gs2+gsize+1,gs2+1:gs2+gsize+1);
xgauss = xgauss / max(max(xgauss));

%calculate the intensity profile (background)
[Ytest,Xtest] = find (image==max(max(image)));
aback(1) = xsize /2;
aback(2) = ysize / 2;
aback(3) = (xsize+ysize) / 2;
aback(5) = min(min(image));
aback(4) = mean(mean(image)) - aback(5);
% aback = marquard ('gaussian',aback,image);
% if aback(3)<4*gwidth
if 0==0
  aback(4) = 0;
  aback(5) = mean(mean(image));
end
%image = image - gaussian(aback,xsize,ysize);
if OutOpt>0 aback, end
if OutOpt==2
  clg, subplot(222), mesh(gaussian(aback,xsize,ysize))
  title('Background')
end

%calculate correlation with a Gaussian  
%icorr = image;
icorr = image - gaussian(aback,xsize,ysize);
icorr = xcorr2(icorr,gauss);
icorr = icorr(gs2+1:gs2+ysize,gs2+1:gs2+xsize);
icorr = icorr - mean(mean(icorr(1:5,1:5)));
if OutOpt==2
  subplot(221), mesh(icorr), title('Correlation')
  pause(1)
end

