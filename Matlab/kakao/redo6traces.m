
function res = redo6traces (file, D, cutoffs,Opts)
% function tdat = redo6traces (file, D, cutoffs, Opts)
% - 
% diffusion analysis using different D (pxl/timelag) values
% read-in peakdata of selected peakfiles
% generate new trace data using input D, 2D, 5D, 10D, D/2, D/5, D/10 value
% generate new msd data using these new trace data
% save new trace file and msd file
% save file 'msd_data' which is a matrix [msd (pxl), error (pxl)]


if nargin<3
   cutoffs=[1/3 1000];
end

figure;
p=[1/10 1/5 1/2 1 2 5 10];
res=[];

for i=1:7
	subplot(4,2,i)
   tempD=D*p(i);
   [tempt tempD]=redotracePCS(file, tempD, cutoffs,Opts);
   res=[res;tempD];
end

p=D.*p;
subplot(4,2,8)
plot(p,res,'b*');
xlabel('D (estimated)'); ylabel('D (from fit)');
set(gcf,'PaperType','A4','PaperOrientation','Portrait','PaperUnits','normalized','PaperPosition',[0.05 0.05 0.95 0.95]);

