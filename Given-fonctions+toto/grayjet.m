function ColorMap = grayjet(lMap)
%
% GRAYJET.M - colormap 'jet' on gray
%
% date : 17-11-1997
% author : ts
% version : <01.00> from <971197.00>
%----------------------------------------------
if nargin<1, lMap=128; end,

mGray  = 0.4;
sBlue  = sqrt(3)*mGray;
if sBlue>0.9
  sBlue = 0.9
end
lMapG  = round(lMap/2.5);
lMapC  = lMap-lMapG;
lMapB  = floor(lMapC/4*(1-sBlue));
lMapC4 = round((lMapC-lMapB)/3);
lMapB  = lMap-lMapG-3*lMapC4

ColorMap = (0:mGray/(lMapG-1):mGray)'*ones(1,3);
ColorMap = [ColorMap;zeros(lMapB,2),(sBlue:(1-sBlue)/(lMapB-1):1)'];
ColorMap = [ColorMap;zeros(lMapC4,1),(0:1/(lMapC4-1):1)',ones(lMapC4,1)];
ColorMap = [ColorMap;(0:1/(lMapC4-1):1)',ones(lMapC4,1),(1:-1/(lMapC4-1):0)'];
ColorMap = [ColorMap;ones(lMapC4,1),(1:-1/(lMapC4-1):0)',zeros(lMapC4,1)];

colormap(ColorMap);
