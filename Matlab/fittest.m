function Test = fittest (image,fit,noise)
%---------------------------------------------------------
%     FITTEST.M
%
% Call: Test = fittest (image,fit,noise)
%
%       Test     ... [ChiTst,ExpTst,FTst]
%       ChiTst   ... (1-alpha)-quantile of the fit
%       ExpTst   ... alpha-quantile of the noise
%       FTest    ... F-test of the residues
%       image    ... matrix of subimage to test
%       fit      ... matrix of found fit (size as image)
%       noise    ... noise figure
%
% author :  Baumgartner Werner & ts
% version : <01.11> from <941005.0000>
%----------------------------------------------------------
if nargin<3, help fittest, end

n = prod(size(image));
if n<2
  Test = [0,0,0];
  return
end

% chi^2- test of the fit
  residues = (image - fit);
  residues = residues ./ sqrt(noise^2+fit);
  ChiTst   = (n-1) * std(residues(:))^2;
  ChiTst   = 1 - chipf (n-1,ChiTst);
  
% exponential - test for the noise
  imSpec  = spectrum (image(:));
  ExpTst  = mean (imSpec(:,1)) / noise^2 * n;
  ExpTst  = chipf (n,ExpTst);
  
% F-test for the residues (see Numerical Recipes)
  FTest = std(residues(:))^2;
  if FTest<1, FTest=1/FTest; end
  FTest = (n-1) / (2*(n-1)*FTest);
  FTest = 2 * betainc (FTest,0.5*(n-1),0.5*(n-1));
  if FTest>1, FTest=2-FTest; end

% result
Test = [ChiTst,ExpTst,FTest];
