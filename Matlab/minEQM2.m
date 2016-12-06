function [ lambda ] = minEQM2( h,s,r )
%Cherche un lambda qui minimise l'EQM, suppose que EQM(lambda) n'a qu'un
%minimum local.
%h : le truc pour déconvoluer
%s : signal à traiter
%r : reference

%evite de recalculer:
fft2h=fft2(h);
absfft2h_P2=abs(fft2h).^2 ;
conjfft2h=conj(fft2h);
fft2s=fft2(s);


itermax=12; %nombre d'iteration max autorise dans les while
precisionlambda=0.01

lambda=1;
min=0;
max=Inf;
pas=2; %pas de multiplication de lambda
k=0;

%On fait un premier calcul
%Filtre de Wiener et cakcul EQM
fw=conjfft2h./(absfft2h_P2+min);
imgW=ifft2(fw.*fft2s);
EQMmin=mean(mean(abs(imgW-r).^2+0)); %EQM en 0

EQMtemp=mean(mean(abs(ifft2(conjfft2h./(absfft2h_P2+lambda).*fft2s)-r).^2)); %EQM en 1

%On multiplie lambda par pas jusqua atteindre un changement dans
%l'evolution de l'EQM, on a alors un intervalle contenant lambdaopt
while(EQMtemp<EQMmin)&(k<itermax) %tant que la courbe ne remonte pas
    EQMmin=EQMtemp;
    lambda=lambda*pas;
    k=k+1;
    EQMtemp=mean(mean(abs(ifft2(conjfft2h./(absfft2h_P2+lambda).*fft2s)-r).^2));
end 

%on construit cet intervalle
if(k==0)
    min=0;
    max=1;
elseif EQMtemp==EQMmin %on gagne un peu de temps, on peut toujours rever..
    min=2^(k-1);
    max=2^k;
else
    min=2^(k-2)*(~(k==1)); % si k=1 on doit mettre 0
    max=2^k;
end

%Ici on est sur que lambdaopt est entre min et max (si il n'y a qu'un min
%local)

k=1; %pour compter
min
max
% while(max-min>precisionlambda)&(k<itermax)
%     %on compare les EQM entre min+(min+max)/3 et min+2*(min+max)/3
%     pos1=(4*min+max)/3;
%     pos2=(5*min+2*max)/3;
%         if(mean(mean(abs(ifft2(conjfft2h./(absfft2h_P2+pos1).*fft2s)-r).^2))>mean(mean(abs(ifft2(conjfft2h./(absfft2h_P2+pos2).*fft2s)-r).^2)))
%             min=pos1;
%         else
%             max=pos2;
%         end 
%     k=k+1; %compteur pour eviter un while trop long
% end
'start'
while((max-min)>precisionlambda)&(k<itermax)
    %on compare les EQM entre min+(min+max)/3 et min+2*(min+max)/3
    pos1=min+(max-min)/3;
    pos2=min+2*(max-min)/3
    if(mean(mean(abs(ifft2(conj(fft2(h))./(abs(fft2(h)).^2+pos1).*fft2(s))-r).^2))>mean(mean(abs(ifft2(conj(fft2(h))./(abs(fft2(h)).^2+pos2).*fft2(s))-r).^2)))
%         if(mean(mean(abs(ifft2(conjfft2h./(absfft2h_P2+pos1).*fft2s)-r).^2))>mean(mean(abs(ifft2(conjfft2h./(absfft2h_P2+pos2).*fft2s)-r).^2)))
            min=pos1
        else
            max=pos2
        end 
    k=k+1; %compteur pour eviter un while trop long
end

min;
max;
lambda=(min+max)/2
end 


