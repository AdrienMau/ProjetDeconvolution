function  [OptOut,ConfOut,TrackOut] = fitopt (OptIn,ConfIn,TrackIn)
%------------------------------------------------------------------
% FITOPT.M
% Determines the otions given and sets the rest
% to a default value.
%
% usage: [OptOut,ConfOut,TrackOut] = fitopt (OptIn,ConfIn,Trackin)
%
% input:  OptIn  -    row-vector with:
%                     OptIn(1) : control-output out (0) or in (1)
%                     OptIn(2) : minimal chi
%                     OptIn(3) : minimal delta chi
%                     OptIn(4) : minimal parameter variance
%                     OptIn(5) : maximal # of loops in fitting procedure
%                     OptIn(6) : maximal lambda allowed (see Marquard algorithm)
%                     OptIn(7) : width of Gaussian correlation function
%                     OptIn(8) : width of image around peak which is fitted
%                     OptIn(9) : threshold for locating a peak
%                     OptIn(10): fit-mode chisqared (0), abs.deviation (1)
%                     OptIn(11): confidence limit exponential test
%                     OptIn(12): confidence limit for chi-test
%                     OptIn(13): confidence limit for F-test
%                     OptIn(14): bleaching time (images)
%                     OptIn(15): limit for the diffusion probability
%                     OptIn(16): average # molecules per image
%                     OptIn(17): time for recovery
%         ConfIn -(o) vector of the confidence limits
%         TrackIn -(o)vector of tracking parameter
%
% output:  OptOut - row-vector which is the input vector filled up
%                   with the default values
%
%
% date: 25.7.1994
% author: ts
% version: <02.02> from <000330.0000>
% modif Laurent ligne58 le 03/02/01
%------------------------------------------------------------------------
if nargin<1, help fitopt, return, end
if nargin<2, ConfIn=[]; end
if nargin<3, TrackIn=[]; end

% default for fit-options
output  = 0;
chimin  = 1.E-4;
mindchi = 1.E-3;
mindpar = 1.E-3;
maxloop = 100;
maxlamb = 1E8;
gwidth  = 2.0;
gsize   = 9;
thres   = 2.5;
FitMode = 0;
DefOpt  = [output,chimin,mindchi,mindpar,maxloop,maxlamb,gwidth,...
           gsize,thres,FitMode];

% default for confidence limits
%ChiTest = 0.01;
ChiTest = 0.00000000000001;
ExpTest = 0.9;
FTest   = 0;
DefConf = [ChiTest, ExpTest, FTest];

% default for tracking
Bleach   = inf;
DifProb  = 0.01;
Concentr = 0;
Recover  = inf;
DefTrack = [Bleach,DifProb,Concentr,Recover];

% set output
Conf     = [ConfIn,DefConf(length(ConfIn)+1:3)];
Trc      = [TrackIn,DefTrack(length(TrackIn)+1:4)];
DefOpt   = [DefOpt,Conf,Trc];
maxOpt   = length(DefOpt);
maxIn    = length(OptIn);
OptOut   = [OptIn,DefOpt(maxIn+1:maxOpt)];
ConfOut  = OptOut(11:13);
TrackOut = OptOut(14:17);
