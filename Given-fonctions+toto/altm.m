function [peaks, rate]=altm(data, timebase, estnpeaks, resrate)

if nargin<2
   timebase = 0.1;
end

if nargin<4
	resrate=4;
end

data=resample(data,resrate,1);
xdata=xcorr(data);

le = length(xdata); le2=le/2;

if nargin<3
   estnpeaks = floor(le*timebase/12.3/resrate)-1;
end

peaks=zeros(2,estnpeaks+1);
estpeakspread = floor(12.3/timebase)*resrate;
estpeakwidth = floor(5/timebase)*resrate;

for i=0:estnpeaks
   ps = floor(le2+estpeakspread*i-estpeakwidth);
   pe = ceil(le2+estpeakspread*i+estpeakwidth);
   ar = xdata(ps:pe);
%   plot(ar)
   peaks(1,i+1) = find(ar == max(ar))+ps;
end

estpeakwidth=2*estpeakwidth;

for i=0:estnpeaks
   ps = floor(estpeakspread*i)+1;
   pe = ceil(ps+estpeakwidth);
   ar = data(ps:pe);
%   plot(ar)
   peaks(2,i+1) = find(ar == max(ar))+ps;
end

peaks=peaks./resrate;
p2 = (peaks(1,2:end)-peaks(1,1))./(1:estnpeaks);
p3 = peaks(2,:)-(0:estnpeaks)*mean(p2);

rate=[ [mean(p2), std(p2)]; [mean(p3), std(p3)] ]*timebase;
