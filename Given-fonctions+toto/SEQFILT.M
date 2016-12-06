function rImage = seqfilt (Image,nX,OutOpt)
%-----------------------------------------------------------------------------
% SEQFILT.M
%
% call: rImage = seqfilt (Image,nX)
%
%
% author:  ts
% version: <01.00> from <970210.0000>
%-------------------------------------------------------------
if nargin<2, help seqfilt, return, end

%internal parameter
global MASCHINE
[fOpt,TLimit] = fitopt ([]);
if nargin<3, OutOpt=fOpt(1); end 
border	  = 1;
gwidth    = fOpt(7);
gsize     = fix(fOpt(8)/2)*2+1;
threshold = fOpt(9)*fOpt(9);
FitOpt    = fOpt(10);
gs2       = fix(gsize/2);
[Ysize,Xsize] = size(Image)
Xsize     = Xsize/nX

%prepare a Gaussian for the correlation-filter
gauss = gaussian([gs2+1,gs2+1,gwidth,1,0],gsize,gsize);

%------------------------------------------------
%loop through the images
for iX=1:nX
  iX
  SubImage = Image(1:Ysize-border,(iX-1)*Xsize+1+border:iX*Xsize);
  if OutOpt==2
    clg, subplot(221), mesh(SubImage)
    title('original')
  end

  %calculate the intensity profile (background)
  [Ytest,Xtest] = find (SubImage==max(max(image)));
  aback(1) = Xsize /2; aback(2) = Ysize / 2;
  aback(3) = (Xsize+Ysize) / 2;
  aback(5) = min(min(SubImage));
  aback(4) = mean(mean(SubImage)) - aback(5);
  aback = marquard ('gaussian',aback,SubImage);
  if aback(3)<4*gwidth
    aback(4) = 0;
    aback(5) = mean(mean(SubImage));
  end
  SubImage = SubImage - gaussian(aback,Xsize-border,Ysize-border);
  if OutOpt>0 aback, end
  if OutOpt==2
    subplot(222), mesh(gaussian(aback,Xsize-border,Ysize-border))
    title('background')
    subplot(223), mesh(SubImage)
    title('corrected')
  end

  %calculate correlation with a Gaussian  
  icorr = xcorr2(SubImage,gauss);
  icorr = icorr(gs2+1:gs2+Ysize-border,gs2+1:gs2+Xsize-border);
  icorr = icorr - mean(mean(icorr(1:5,1:5)));
  if OutOpt==2
    subplot(224), mesh(icorr), title('correlated')
    pause(1)
  end

  %put everything together again
  rImage   = [rImage,100*ones(Ysize-border,1),icorr];
end

