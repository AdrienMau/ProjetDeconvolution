function h=errorfilter(filename)

A=load(filename);


FName = filename(1:find(filename=='.')-1);

indi = find(A(:,10)<0.2*A(:,5) & A(:,4)<2 & A(:,4)>0.5);

h = [];
h = [h,A(indi,:)];

DoIt  = ['save ', FName,'.spe.3.pk h -ascii']
eval (DoIt)

FName=[FName,'.spe.3'];
analyze(FName)