function toto3()

opt=start;
opt(18)=3;
fit=5;
tt=25;
time=30;

%connectrace('cy5_stat_1.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_2.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_3.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_4.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_5.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_6.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_7.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_8.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_9.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)
%connectrace('cy5_stat_10.spe',3,2,tt,1,.1,[1/3 1500 100],opt,1)

extractPCSsansZeros('cy5_stat_1.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_2.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_3.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_4.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_5.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_6.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_7.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_8.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_9.spe','temp2.spe',time,260,fit);
extractPCSsansZeros('cy5_stat_10.spe','temp2.spe',time,260,fit);