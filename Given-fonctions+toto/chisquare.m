function c =chisquare(a,y,xmax,ymax)

c=gaussian(a,xmax,ymax)-y;
c=c(:);