function result = findpeak (image, fOpt)
%------------------------------------------------------------------------------
% FINDPEAK.M
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
% output:       result - result-matrix [:;X0,Y0,W,I,O,dX0,dY0,dW,dI,dO,chi,test] with
%                        X0, Y0 - peak position
%                        W      - peak width
%                        I      - peak Intensity
%                        O      - constant offset
%                        d...   - variances in each parameter
%                        chi    - reduced chi-squared
%                        test   - [ChiTest,ExpTest,FTest] test for the fit
%                                 see fittest()
%
%
% author: wb & ts
% version: <02.20> from <000330.0000>
% 			  <02.03> from <000807.0000> by WJ & GAB 
%													new Marqogauss to fit
%-----------------------------------------------------------------------------
%set internal variables
if nargin<1, help findpeak, return, end
if nargin<2, fOpt=[]; end

[fOpt,TLimit] = fitopt (fOpt);
OutOpt    = fOpt(1); 
gwidth    = fOpt(7);
gsize     = fix(fOpt(8)/2)*2+1;
threshold = fOpt(9)*fOpt(9);
FitOpt    = fOpt(10);
peak      = 0;
result    = [];
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
aback(3) = (xsize+ysize);
aback(5) = min(image(:));
aback(4) = pi/4/log(2)*(mean(image(:))-aback(5))*aback(3)^2;

%aback = Marqo ('gaussian',aback,image);
%try for a speciall MarqoGauss
aback = marqogauss(aback,image);

if aback(3)<4*gwidth
    aback(4) = 0;
    aback(5) = mean(mean(image));
end
%image = image - gaussian(aback,xsize,ysize);
if OutOpt>0 aback, end
if OutOpt==2
    clf, subplot(222), mesh(gaussian(aback,xsize,ysize))
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

%determine the threshold level
PowSpec = image - gaussian(aback,xsize,ysize);
PowSpec = spectrum (PowSpec(:),min(length(PowSpec(:)),512));
noise   = sqrt(mean(PowSpec(128:min(length(PowSpec(:)),512)/2,1)));
xnoise  = noise * sqrt(4*log(2)*pi/gwidth/gwidth);
if OutOpt>0, noise, end
clear PowSpec

%adjust threshold
IThrAdj = 0;
while sum(sum(icorr>threshold*noise))>MaxNoPk
    IThrAdj = IThrAdj + 1;
    threshold = 1.1 * threshold;
    disp(sprintf(' * threshhold raised (%.2f)',sqrt(threshold)));
    if IThrAdj>MaxThrAdj
        disp ('too many peaks - reduce threshold')
        return
    end
end
%-----------------------------------------------------------
%scan through the diffent peaks, and try to fit a Gaussian
MaxCorr = max(max(icorr));
while MaxCorr>noise*threshold & peak<MaxNoPk
    if OutOpt==2
        subplot (222)
        contour(icorr>noise*threshold,1), title('Threshold')
        pause(2)
    end
    
    peak = peak+1;
    % changes by GAB
    if (OutOpt>0)
        disp(sprintf('peak %d',peak));
    end
    [Ytest,Xtest] = find(icorr==MaxCorr); 
    Ytest = Ytest(1); Xtest = Xtest(1);
    
    
    %create sub-image for the fit
    xfits=max(1,Xtest-gs2); xfite=min(xsize,Xtest+gs2);
    yfits=max(1,Ytest-gs2); yfite=min(ysize,Ytest+gs2);
    xsz=xfite-xfits+1; ysz=yfite-yfits+1;
    
    fisize = xsz*ysz;
    X0=Xtest-xfits+1; Y0=Ytest-yfits+1;
    gXstart=max(gs2+2-X0,1); gXend=min(gs2+1-X0+xsz,gsize);
    gYstart=max(gs2+2-Y0,1); gYend=min(gs2+1-Y0+ysz,gsize);
    fimage = image(yfits:yfite,xfits:xfite);
    fpar = [X0,Y0,gwidth,pi/4/log(2)*(max(fimage(:))-min(fimage(:)))*gwidth^2, ...
            min(fimage(:))];
    if min(min(fimage)) > 0
        sigma = sqrt(fimage);
    else
        sigma = sqrt (abs(fimage)+0.001*max(fimage(:)));
    end
    if OutOpt==2
        subplot (223), mesh(fimage), title('sub-image')
    end
    
    %try to fit gaussian and store found position
    %[p,dp,chi] = Marqo ('gaussian',fpar,fimage);
    %[p,dp,chi] = Marqo ('gaussian',fpar,fimage,sigma,fOpt);
    [p,dp,chi] = marqogauss(fpar,fimage,sigma,fOpt);
    
    if FitOpt==1
        p   = fmins ('chigauss',p,[],[],fimage,sigma,FitOpt);
        chi = chigauss(p,fimage,sigma,FitOpt) / ...
            (prod(size(fimage))-length(p));
        if OutOpt>0, chi, end
    end
    
    %apply tests
    Test = fittest (fimage,gaussian(p,xsz,ysz),noise);
    
    %store and show results
    result(peak,:) = [p,dp,chi,Test];
    result(peak,1:2) = result(peak,1:2) + [xfits-1,yfits-1];
    if OutOpt>0, result(peak,:), end
    if OutOpt==2
        subplot (224), mesh(fimage-gaussian(p,xsz,ysz)),
        title('residuals')
    end
    
    %subtract the found peak from the image icorr and recalc the maximum
    icorr(yfits:yfite,xfits:xfite) = ...
        icorr(yfits:yfite,xfits:xfite) - ...
        MaxCorr*xgauss(gYstart:gYend,gXstart:gXend);
    MaxCorr = max(max(icorr));
end;

%------------------------------------------------------------------------------
%check the tests
result = checktst (image,result,noise,TLimit);

%and show result
if OutOpt==2 & length(result)>0
    PkShow = clearpk([ones(size(result,1),1),result],TLimit,1);
    if length(PkShow)>0
        subplot (222)
        plot (PkShow(:,2), PkShow(:,3), 'o')
        axis([0,size(image,2),0,size(image,1)])
        title ('found peaks')
    end
    pause(2), subplot(111)
end
