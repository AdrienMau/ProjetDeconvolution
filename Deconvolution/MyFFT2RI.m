function Res = MyFFT2RI(RI,N,M)	


% Quelques tests
	if nargin~=3
	error('Ne sait faire que si 3 arguments en entrée')
	end

% Quelques tests
	if size(RI,1)~=size(RI,2)
	error('Ne sait faire que si matrice carrée')
	end

% Quelques tests
	if N~=M
	error('Ne sait faire que si sortie carrée')
	end

% Quelques tests
	if size(RI,1)>N
	error('Ne sait faire que si on va vers plus de points')
	end

% Paramètre de taille
	Demi = floor(size(RI,1)/2);

% Calcul
	Tmp = zeros(N,N);
	Tmp ( 1+N/2-Demi:1+N/2+Demi , 1+N/2-Demi:1+N/2+Demi ) = RI; 
	Res = fft2(Tmp,N,N);


