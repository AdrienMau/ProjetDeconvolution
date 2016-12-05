function [d,p,t,c,p2]=trackread(filename, convertimage)
% *****
% function [d,p,t,c,p2]=trackread(filename, convertimage)
% *****
% reads tracking data files (and images) saved in open-source BLAB-format.
%
% outputs [d,p,t,c] are the same as for speread and derivatives, if the data
% file contains an image; otherwise  the matrix d is of size (5+c)*N, where c is 
% the number of channels and N the number of datapoints:
%
%   status  timestamp   xposition   yposition   zposition    C1 ... Cc
%
% The currently recognized status values are 0-7 for timestamp, searching, 
% tracking, subtrack, image data, angle, time trace, and spectrum, respectively.
%
% If you wish to extract only the tracking data from the data matrix, use 
% septrack.
%
% If you do not understand the above, or if you need further information, 
% ask Gerhard (gerhard@blab.at, € 0.00 pm TTC).

% TRACKREAD
% version 1.0 by GAB 01/02/2004
% version 1.1 by GAB 08/10/2004
% version 1.1 by GAB 06/04/2005 - handle multi-images correctly
% version 1.2 by GAB 30/05/2005 - implement ascii data
% version 1.3 by GAB 06/09/2005 - recognize 'number of data channels' to set nodet
% version 2.0 by GAB 16/12/2005 - recognize active measurement device for TrackingMX 2.0


% *******************************************
% no user-serviceable code beyond this point!
% *******************************************

% *******************************************
% removal of this notice will void warranty!
% *******************************************

global QUIET

if (nargin==0)
    [file,path] = uigetfile('*.*','Load Data-File');
    filename = [path,file];
end

if (nargin<2)
    convertimage=1;
end

if isempty(QUIET)
    QUIET=0;    % serious errors will still be displayed; standard stuff will not
    % QUIET=0 actually means: tell me everything, including standard warnings
end

d=[]; p=[]; t=''; c='';
fid=fopen(filename,'r','b');

if (fid<0)
    error(['file ',filename,' could not be opened! Aborting.']);
end

t=filename; % file exists

% define complete (?) parameter set
p2.title=t;
p2.version=-1;
p2.measurementdevice.name='undefined';
p2.measurementdevice.noc=-1;
%p2.measurementdevice.nidaq=-1;
%p2.measurementdevice.channels=[];
% OK, at some point I have to implement that; at the moment I only need the pseudomovement
p2.pseudomovement.type='none';
p2.pseudomovement.radius=-1;
p2.pseudomovement.speed=-1;
p2.type='track';
p2.stepsize=0;
p2.dwelltime=0;

nodet=0;
actmeasdevice=-1;
currmeasdevice=-2;

l=fgetl(fid);
% if ~strcmp(l,'NANOPHOTONIQUE_CPMOH_DATAFILE')   % all my datafiles have to start with this line
%     error(['file ',filename,' does not start with a valid header! Aborting.']);
% end

done=0;
while (~done) % I'm waiting for a "*** START DATA" line
    l=fgetl(fid);
    if feof(fid)
        error(['file ',filename,' ended before data could be read! Aborting.']);
    end
    if ((length(l)>3))
        if strcmp(l(1:3),'***') % we've found *** START DATA ***
            done=1;
        elseif (l(1)=='*') % start of a block found
            switch lower(l(3:end))
            case 'end'
                disp(['extra end-of-block found in header of file ',filename,'. procede with caution!']);
            case 'comment'
                l=fgetl(fid);
                while ~(strcmpi(l,'*end') | strcmpi(l,'* end'))  % bug in SaveDataFile.vi before version 1.03; bugger!
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    c=[c,l,10,13];
                    l=fgetl(fid);
                end
            case 'piezocorrection'
                l=fgetl(fid);
                while ~strcmpi(l,'* end')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    
                    % I should do something with the piezocorrection
                    
                    l=fgetl(fid);
                end
            case 'pseudomovement'
                l=fgetl(fid);
                while ~strcmpi(l,'* end')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    sep=find(l==':');                    
                    if isempty(sep)
                        disp(['ignoring malformed header statement ',l,' in block "pseudomovement" in ',filename,'.']);
                    else
                        token=lower(l(1:(sep(1)-1)));
                        posttoken=l((sep(1)+2):end);
                        switch token
                        case 'type'
                            p2.pseudomovement.type=posttoken;
                        case 'radius'
                            p2.pseudomovement.radius=str2num(posttoken);
                        case 'speed'
                            p2.pseudomovement.speed=str2num(posttoken);
                        otherwise
                            disp(['Pseudomovement: ',l]);
                        end % switch
                    end % if sep
                    l=fgetl(fid);
                end
            case 'measurement device analog'    % version before 2.0
                l=fgetl(fid);
                while (l(1)~='*')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    sep=find(l==':');                    
                    if isempty(sep)
                        disp(['ignoring malformed header statement ',l,' in block "measurement device" in ',filename,'.']);
                    else
                        token=lower(l(1:(sep(1)-1)));
                        posttoken=l((sep(1)+2):end);
                        switch token
                        case 'name'
                            p2.measurementdevice.name=posttoken;
                        case 'number of channels'
                            if (nodet==0)
                                nodet=eval(posttoken);
                            end
                            p2.measurementdevice.noc=nodet;
                            l=fgetl(fid);
                        end % switch
                    end % if sep
                    l=fgetl(fid);
                end % while l(1)~='*'
            case 'measurement device digital'
                l=fgetl(fid);
                while (l(1)~='*')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    sep=find(l==':');                    
                    if isempty(sep)
                        disp(['ignoring malformed header statement ',l,' in block "measurement device" in ',filename,'.']);
                    else
                        token=lower(l(1:(sep(1)-1)));
                        posttoken=l((sep(1)+2):end);
                        switch token
                        case 'name'
                            p2.measurementdevice.name=posttoken;
                        case 'number of channels'
                            if (nodet==0)
                                nodet=eval(posttoken);
                            end
                            p2.measurementdevice.noc=nodet;
                            l=fgetl(fid);
                        end % switch
                    end % if sep
                    l=fgetl(fid);
                end % while l(1)~='*'
            case 'measurement device'
                l=fgetl(fid);
                while (l(1)~='*')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    sep=find(l==':');                    
                    if isempty(sep)
                        disp(['ignoring malformed header statement ',l,' in block "measurement device" in ',filename,'.']);
                    else
                        token=lower(l(1:(sep(1)-1)));
                        posttoken=l((sep(1)+2):end);
                        switch token
                        case 'name'
                            p2.measurementdevice.name=posttoken;
                        case 'number of channels'
                            if (nodet==0)
                                nodet=eval(posttoken);
                            end
                            p2.measurementdevice.noc=nodet;
                            l=fgetl(fid);
                        end % switch
                    end % if sep
                    l=fgetl(fid);
                end % while l(1)~='*'
            case 'measurement devices'  % new after version 2.0
                l=fgetl(fid);
                while (l(1)~='*')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    sep=find(l==':');                    
                    if isempty(sep)
                        disp(['ignoring malformed header statement ',l,' in block "measurement device" in ',filename,'.']);
                    else
                        token=lower(l(1:(sep(1)-1)));
                        posttoken=l((sep(1)+2):end);
                        switch token
                        case 'device number'
                            curmeasdevice=eval(posttoken);
                            
                        case 'name'
                            p2.measurementdevice.name=posttoken;
                        case 'number of channels'
                            if (actmeasdevice==curmeasdevice)
                                nodet=eval(posttoken);
                            end
                            
                            p2.measurementdevice.noc=nodet;
                            l=fgetl(fid);
                        end % switch
                    end % if sep
                    l=fgetl(fid);
                end % while l(1)~='*'
            case 'movement device'
                l=fgetl(fid);
                while (l(1)~='*')
                    if feof(fid)
                        error(['file ',filename,' ended inside header block. Aborting.']);
                    end
                    sep=find(l==':');                    
                    if isempty(sep)
                        disp(['ignoring malformed header statement ',l,' in block "movement device" in ',filename,'.']);
                    else
                        token=lower(l(1:(sep(1)-1)));
                        posttoken=l((sep(1)+2):end);
                        switch token
                        case 'number of channels'
                            %                            nodet=eval(posttoken);
                            l=fgetl(fid);
                        end % switch
                    end % if sep
                    l=fgetl(fid);
                end % while l(1)~='*'
            otherwise
                error (['unknown block_type "',lower(l(3:end)),'" found in header of ',filename,'. aborting!']);
            end % switch
        else % if ***, elseif
            sep=find(l==':');
            if isempty(sep)
                error(['ignoring malformed header statement ',l,' in ',filename,'.']);
            else
                token=lower(l(1:(sep(1)-1)));
                posttoken=l((sep(1)+2):end);
                switch token
                case 'data saved as'
                    binary=strcmpi(posttoken,'binary');
                case 'number of channels'
                    nodet=eval(posttoken);
                case 'stepsize'
                    p2.stepsize=eval(posttoken);
                case 'data file version'
                    if ~QUIET
                        disp(['data file version: ',posttoken,'.']);
                    end
                    p2.version=posttoken;
                case 'number of data channels'
                    nodet=eval(posttoken);
                case 'active measurement device'
                    actmeasdevice=eval(posttoken);
                case 'dwelltime'
                    p2.dwelltime=eval(posttoken);
                otherwise
                    if ~QUIET
                        disp(['ignored parameter ',token,' (value: ',posttoken,') in header of ',filename,'.']);
                    end
                end % switch
            end % if isempty
        end % else of if block
        % more parameters should be read in here!
    end % if length>3 and not starting with '***'
end % while not done

% binary=1;   % data mode binary/ascii/compressed(to be programmed) should be 
% read in from the header
% nodet=1;    % number of detectors should be read in from header!

if binary
    datastart=ftell(fid);       % position of first data
    fseek(fid,-100,'eof');      % search for 'end of data' marker
    dataend=ftell(fid);         % estimate for last data
    l=fread(fid,100,'uint8')';   %   
    k=findstr('***',char(l));   % there should be two '***' in the end-of-data string
    if isempty(k)
        warning(['file ',filename,' ends without expected marker - incomplete file suspected!']);
    else
        dataend=dataend+k(end-1);   % data marker, so let's take the last-but-one
    end
    ndata=floor((dataend-datastart-1)/8);   % find number of doubles fitting in there
    
    fseek(fid,datastart,'bof'); % back to where the data is
    [d,nread]=fread(fid,ndata,'double');
    
    nocol=5+nodet;  % number of colums expected in a line of data
    if rem(nread,nocol)   % number of doubles not a multiple of nocol
        warning(['extra/missing data in file ',filename,', please check! continue.']);
        N=nocol*floor(nread/nocol);
        d=d(1:N);
    end
    
    ndata=floor(nread/nocol);
    d=reshape(d,nocol,ndata)';

else % if (binary)
    ndata=0; maxdata=100;
    nocol=5+nodet;
    d=zeros(maxdata,nocol);    
    done=0;
    
    while ~(feof(fid) | done)
        l=fgetl(fid);
        if length(l)>0
            if l(1)=='*' % we found the end-of-data string
                done=1;
            else
                [a,count]=sscanf(l,'%f');
                if (count ~= nocol)
                    warning(['incomplete line in file ',filename,', please check! continue.']);
                    done=1;
                else
                    ndata=ndata+1;
                    if (ndata>maxdata)
                        d=[d;zeros(100,nocol)];
                        maxdata=maxdata+100;
                    end
                    d(ndata,:)=a;
                end % if (count ...
            end % if l(1)
        end %if length
    end % while ~(feof ...
    d((ndata+1):end,:)=[];
end % if (binary)

p2.x.min=min(d(:,3));p2.x.max=max(d(:,3));
p2.y.min=min(d(:,4));p2.y.max=max(d(:,4));

if all(d(:,1)==4) 
    if (convertimage)  % its an image & we want it converted into an imagematrix
        p2.type='image';
        if ~QUIET
            disp('image data found, converting to matrix.')
        end
        %    nocol=sum(d(:,4)==d(1,4));  % all point in first line
        %        nocol=floor((p2.x.max-p2.x.min)/p2.stepsize)+1;  
        % if this is not an integer, something is wrong
        % there is an error associated with the floating points in Matlab
        % (~1e-14) which nevertheless causes problems with floor() ...
        
        nocol=round((p2.x.max-p2.x.min)/p2.stepsize)+1;  
        
        dd=[];
        
        pll=mod(ndata,nocol);   % should be zero for full image, otherwise the number of 'extra' pixels in last line
        
        if (pll ~=0)    % images has been aborted - extra pixel ...
            nextra=nocol-pll;   % that's how many extra pixel we need
            d=[d;zeros(nextra,5+nodet)];
            ndata=ndata+nextra;
            warning(sprintf('last line in image incomplete; %d zero-pixel added',nextra));
        end
        
        norow=floor(ndata/nocol);
        % if this is not an integer, something is wrong
        for i=1:nodet
            dd=[dd;reshape(d(:,5+i),nocol,norow)];
        end
        
        d=dd';
        
        if (p2.stepsize==0) % shouldn't be ...
            p=[nodet*nocol, norow, 1, 1, nodet];
        else
            xpxl=round((p2.x.max-p2.x.min)/p2.stepsize)+1; % image should be xplx x ypxl
            ypxl=round((p2.y.max-p2.y.min)/p2.stepsize)+1; % ** there are some weird effects of rounding ...
            p=[nodet*nocol, norow, ceil(nocol/nodet/xpxl), ceil(norow/ypxl), nodet];        
        end
    else
        p2.type='imagedata';
    end
else
    p=[ndata,nocol,1,1,nodet];
end
% p=[ndata,nocol,nodet,0,0];
fclose(fid);

% EOF
