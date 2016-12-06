function toto4()

opt=start;
opt(18)=3;
fit=7;
tt=25;
time=30;

%connectrace('fluo1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo2.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo3.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo4.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo5.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo6.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)

%extractPCS('fluo1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo2.spe','temp2.spe',time,260,fit);
%extractPCS('fluo3.spe','temp2.spe',time,260,fit);
extractPCS('fluo4.spe','temp2.spe',time,260,fit);
extractPCS('fluo5.spe','temp2.spe',time,260,fit);
extractPCS('fluo6.spe','temp2.spe',time,260,fit);
