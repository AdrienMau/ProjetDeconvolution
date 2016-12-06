function n = niveau4(t,x)
global kt a21 kisc kp rho

n(1)=-kisc*x(1)+kt*x(2)
n(2)=kisc*(1/(2+(a21/rho)))*x(1)-(kp+kt)*x(2)
n(3)=kp*x(2)

