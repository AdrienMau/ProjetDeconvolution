function Trc = mktrace (Peaks, D, Xmax, Ymax, Opts)
%----------------------------------------------------------
% MKTRACE.M
% generates a trace from image-tracking data
%
% usage : Trc = mktrace (Peaks, D, Xmax, Ymax, Conf, Bleach)
%
% input:     Peaks  -     peak-matrix as output of seqfind().
%            D      -     estimated 2-D diffusion coefficient
%                         in units of the Peak-matrix.
%            Xmax,  -     maximal size of the image
%            Ymax
%            Opts   - (o) fitting options see (fitopt())
%
% output:    Trc - trace of molecules with:
%                  Trc = [#, Image, X-pos, Y-pos]
%
% date: 21.7.1994
% author: ts
% version: <02.11> from <950809.0000>
%------------------------------------------------------------
if nargin<4, help mktrace, return, end
if nargin<5, Opts=[]; end
trace    = [];
Trc      = [];
[Opts,Conf,TOpts] = fitopt(Opts);
OMode    = Opts(1);
DiffProb = Opts(15);

%clear input-data
Peaks = clearpk (Peaks,Conf,3,Opts(18)); %enlève les doubles peaks et les peaks de largeur>Opts(18) pixels et <1 pixels
No_Pk = length(Peaks);
if OMode==1, No_Pk, end
if No_Pk==0, return, end,

%------------------------------------------------------
% loop through the images
ind1 = find(Peaks(:,1)==Peaks(1,1));
Im1  = Peaks(ind1,2:3);
Im0=[]; indb0=[];

for iImage=Peaks(1,1)+1:max(Peaks(:,1))
  if OMode>0, iImage, end  
  ind2 = find(Peaks(:,1)==iImage);
  Im2  = Peaks(ind2,2:3);
  cm   = tracksms (Im1,Im2,D,Xmax,Ymax,TOpts,OMode);

  %traces
  indc = find(cm(:,3)>=DiffProb & ...
	      cm(:,1)<=length(ind1) & cm(:,2)<=length(ind2));
  if (length(indc>0))
    trace = [trace;ind1(cm(indc,1)),ind2(cm(indc,2)),cm(indc,3)];
  end
  indr  = cm(find((cm(:,1)>length(ind1)&cm(:,2)<=length(ind2)) | ...
		  (cm(:,1)<=length(ind1)&cm(:,2)<=length(ind2)& ...
		   cm(:,3)<DiffProb)),2);
  indb1 = cm(find((cm(:,1)<=length(ind1)&cm(:,2)>length(ind2)) | ...
		  (cm(:,1)<=length(ind1)&cm(:,2)<=length(ind2)& ...
		   cm(:,3)<DiffProb)),1);
% indr  = cm(find(cm(:,1)>length(ind1)&cm(:,2)<=length(ind2),2);
% indb1 = cm(find(cm(:,1)<=length(ind1)&cm(:,2)>length(ind2),1);

  %recovering peaks
  cr = tracksms (Im0(indb0,:),Im2(indr,:),4*D,Xmax,Ymax,TOpts,OMode);
  indcr = find(cr(:,3)>DiffProb & ...
	       cr(:,1)<=length(indb0) & cr(:,2)<=length(indr));
  if (length(indcr>0))
    trace = [trace;ind0(indb0(cr(indcr,1))),ind2(indr(cr(indcr,2))), ...
             cr(indcr,3)];
  end

  indb0 = indb1;
  ind0  = ind1;
  ind1  = ind2;
  Im0   = Im1;
  Im1   = Im2;
end

if OMode>0, trace, end
%--------------------------------------------------------
% loop through the traces
ipk=0;

while (length(trace)>0)
  ipk  = ipk+1;
  npos = trace(1,2);
  Trc  = [Trc;ipk,Peaks(trace(1,1),1:3),trace(1,3)];
  Trc  = [Trc;ipk,Peaks(npos,1:3),-1];
  trace(1,:) = [];
  if isempty(trace) break, end
  indx = find(trace(:,1)==npos);
  while ~isempty(indx)
    Trc(size(Trc,1),5) = trace(indx,3);
    npos = trace(indx,2);
    Trc  = [Trc;ipk,Peaks(npos,1:3),-1];
    trace(indx,:) = [];
    if isempty(trace) break, end
    indx = find(trace(:,1)==npos);
  end

  %calculate bleaching probability
  nb = size(Trc,1);
  [tb,zb] = tracksms (Trc(nb,3:4),Trc(nb,3:4),D,Xmax,Ymax,[inf,TOpts(2:4)],OMode);
  if zb(1,2)>DiffProb
    Trc(nb,5) = zb(1,2);
  end

end
