function z = test
z=zeros(100,100);
p=[50,50];
w=20
for np=1:10000
  hit = p + w/(2*sqrt(2*log(2)))*randn(size(p));
  z(hit(1),hit(2)) = z(hit(1),hit(2)) + 1;
end


