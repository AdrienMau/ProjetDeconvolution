function [b,r]=bytify(v, n, le)
% function [b,r]=bytify(v, n, le)
% --
% b returns a array of n bytes describing the value of v, r is the eventual remainder
% standard is little endian ordering, unless le is set to 0

if nargin<3
   le=1;
end
if nargin<2
   n=2
end
if nargin<1
   help bytify;
   return
end

b=ones(1,n);

for i=1:n
   b(i)=rem(v,256);
   v=fix(v/256);
end

r=v; % is there some rest left over?

if ~le
   b=fliplr(b);
end
