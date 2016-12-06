function opt = start 

global MASCHINE; MASCHINE='PCXX';

global KINETICSBORDERS; KINETICSBORDERS=[0 2];
global opt;
opt=fitopt([]);
opt(7)=1.7;
opt(9)=1.9;
opt(18)=4;