function doseq (file, D, SeqLen, Opts)
%--------------------------------------------------------
% DOSEQ.M
% Complete evaluation of the image-file <file>:
% (i)   the particles are recognized (seqfind())
% (ii)  traces are generated (seqtrace())
% (iii) the msd is calculated for each trace (msd())
%
%
% call: doseq (file, D, SeqLen, Opts)
%
% input: file   -    path of the image-file
%        D      -(o) estimated diffusion coefficient
%        SeqLen -(o) length of a sequence
%        Opts   -(o) fitting and output options
%
% output:   the output is stored in the files
%         <file>.pk - result of the fitting procedure
%         <file>.trc - traces of the particles
%         <file>.msd - mean-square displacement for each trace
%
% see also: seqtrc, seqfind, findpeak, clearpk, msd, fitopt, trace
%
%
% date:    25.7.1994
% author:  ts
% version: <01.20> from <000330.0000>
%--------------------------------------------------------
if nargin<1, help doseq, return, end
if nargin<2, D=1; end
if nargin<4, Opts=fitopt([]); end
Conf = Opts(11:13);

%recognize peaks 
[PeaksFound, YSeq, Xsize, Ysize] = seqfind (file, Opts);
if PeaksFound==0, return, end
if nargin<3, SeqLen=YSeq; end

%generate traces and index file
if seqtrace(file,SeqLen,D,Xsize,Ysize,Opts,file)==0
  return
end
traceind (file,1);

%generate msd's
seqmsd (file);

