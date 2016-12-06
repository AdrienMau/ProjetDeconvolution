function toto5()

opt=start;
opt(18)=3;
fit=7;
tt=25;
time=30;

connectrace('fluo2_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo3_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo4_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
connectrace('fluo5_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo6_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo7_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo8_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo9_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
connectrace('fluo11_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
connectrace('fluo12_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo13_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('fluo14_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)


extractPCS('fluo2_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo3_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo4_1.spe','temp2.spe',time,260,fit);
extractPCS('fluo5_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo6_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo7_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo8_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo9_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo11_1.spe','temp2.spe',time,260,fit);
extractPCS('fluo12_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo13_1.spe','temp2.spe',time,260,fit);
%extractPCS('fluo14_1.spe','temp2.spe',time,260,fit);
