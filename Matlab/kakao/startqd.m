function opt = startQD 

global MASCHINE; MASCHINE='PCXX';

global KINETICSBORDERS; KINETICSBORDERS=[0 2];
global opt;
opt=fitopt([]);
opt(7)=1.7;
opt(9)=3;
opt(18)=5;