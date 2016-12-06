
global MASCHINE
file = 'pol1.000'
Nseq = 14

%---------------------------------------
%evaluate <file>.pk - the output of SEQFIND
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.pk']
else
  DoIt  = ['load pk\',file]
  set (gca,'FontSize',8)
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
A = eval(FName);

%cancel points out of the confidence interval
A = clearpk (A,[],1);

%get the width, and intensity information
W     = A(:,4);
dW    = A(:,9);
Dark  = A(:,6);
dDark = A(:,11);
I     = pi / 4 / log(2) * A(:,5) .* W.^2;
dI    = sqrt((A(:,10)./A(:,5)).^2 + (2*dW./W).^2) .* I;


%-------------------------------------------------------------------
%now <file>.trc  -  output of SEQTRACE
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.trc']
else
  DoIt  = ['load trc\',file]
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
B = eval(FName);
NoTrace = max(B(:,1))
Int=[];

for itrc=1:NoTrace
  ind = find (B(:,1)==itrc);
  tl  = length(A(ind,1));
  int = [];
  i = 1;
  for ii=B(ind(1),2):B(ind(tl),2)
    bpk = find(B(ind,2)==ii);
    if length(bpk)==0
      int = [int;i,0,0];
    else
      apk = find( A(:,1)==ii & ...
                  A(:,2)==B(ind(bpk),3) & ...
                  A(:,3)==B(ind(bpk),4) ); 
      int = [int;i,I(apk),dI(apk)];
    end  
    i=i+1;   
  end
  Int=[Int;itrc*ones(size(int,1),1),int];
  plot(int(:,2))
  hold on
end
hold off
axis ('normal')
xlabel (''), ylabel('intensity')
