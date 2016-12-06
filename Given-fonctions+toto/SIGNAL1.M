% gemitteltes Signal bei verschiedenen
% Belichtungszeiten

clear
t=0:1:100;
sigma_k=5;
sigma_b=5;
k0=7;
x=2;
kmin=x*sigma_b./t;
for i=1:1:100
tm(i,:)=t;
k(i,:)=kmin+i-1;
end
f=exp(-(k-k0).^2/sigma_k^2);
signal=sum(f.*k.*tm)./sum(f);
plot(t(1,:),4*signal)
axis([0 10 0 300])
