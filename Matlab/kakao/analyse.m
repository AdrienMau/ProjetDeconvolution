function result=analyse()

for i=1:18
    file = ['b10nm',num2str(526+4*i),'.dat']
    d=load(file);
    r=findpeak(d);
    save(['b10nm',num2str(526+4*i),'.pk.dat'], 'r', '-ascii');
    t(i,1)=526+4*i;
    t(i,2)=r(1,4);
    t(i,3)=r(2,4);
    t(i,4)=r(3,4);
    t(i,5)=r(4,4);
end

plot(t(:,1), t(:,2));
hold on;
plot(t(:,1), t(:,3))
hold on;
plot(t(:,1), t(:,4))
hold on;
plot(t(:,1), t(:,5))

file = ['b10nm',num2str(606),'.dat']
    d=load(file);
    r=findpeak(d);
    save(['b10nm',num2str(606),'.pk.dat'], 'r', '-ascii');
end