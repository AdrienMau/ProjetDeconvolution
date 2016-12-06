function h=widthfilter(filename)

A=load(filename);


FName = filename(1:find(filename=='.')-1);

indi = find(A(:,4)<3 );

h = [];
h = [h,A(indi,:)];

DoIt  = ['save ', FName,'.spe.2.pk h -ascii']
eval (DoIt)

FName=[FName,'.spe.2'];
analyze(FName)