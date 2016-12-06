function result=sbe(input, test)
% SquareBracketExpander
%
% expands expressions of the form string[a-k], string[%a%k%] or string[dklm] 
% into a structure - _input_ can be a simple string, a cellarray of strings or
% a structure containing a field 'name'; every string will be treated as follows:
% * the dash will expand only single character: 	d[a-c] => da, db, dc
% * the numeral '%' will expand into a numerical: 	d[%9%11%] => d9, d10, d11
%																	d[%09%11%] => d09, d10 d11
% * a list of characters will be expanded as they are d[mtz] => dm, dt, dz
%
% multiple brackets will be expanded left to right; if _test_ is set to 1,
% all strings will be regarded as filemasks and the result will be the 
% output of dir() - therefore wildcards as * will be expanded as well.
% 
%
% 050600 V1.0 by GAB
% 240700 V1.1 by GAB - included % and dir()
% 170800 V1.2 by GAB - will work with cells too (multiple strings)

if nargin<1
   help sbe
   return
end
if nargin<2
   test=0;
end


if isstr(input)
   input=cell2struct({input},'name');
end
if iscell(input)
   input=cell2struct(input,'name');
end

result=struct('name',{});

for i=1:length(input)
   actinput=input(i).name;
   delimleft=find(actinput=='[');
   delimright=find(actinput==']');
   
   if length(delimleft)~=length(delimright)
      error(['Error while expanding expression ',actinput]);
   end
   
   if length(delimleft)>0
      
	   if delimleft(1)>1
   	   left=actinput(1:(delimleft(1)-1));
	   else
   	   left='';
	   end
   	if delimright(1)<length(actinput)
	      right=actinput((delimright(1)+1):end);
   	else
	      right='';
   	end
	   
   	j=delimleft(1)+1;
   	while j<(delimright(1))
      
         if actinput(j+1)=='-'
       	   for k=double(actinput(j)):double(actinput(j+2))
	      	   result=setfield(result,{length(result)+1},'name',[left,char(k),right]);
      	   end
            j=j+3;
         elseif actinput(j)=='%'
            num=find(actinput((j):end)=='%'); % find other numeral signs
            if length(num)>=3 % enough delimiters
               accpos=min(num(2)-num(1),num(3)-num(2))-1;
               formatstr=['%0',num2str(accpos),'d'];
               n1=floor(str2num(actinput(j+(num(1):num(2)-2))));
               n2=floor(str2num(actinput(j+(num(2):num(3)-2))));
               if n1>n2
                  n=n1; n1=n2; n2=n;
               end
               for k=n1:n2
		      	   result=setfield(result,{length(result)+1},'name',[left,num2str(k),right]);
               end
               j=j+num(3);
            else
               warning('Solitary ''%'' encountered, ignoring.');
               j=j+1;
            end
      	else
            result=setfield(result,{length(result)+1},'name',[left,actinput(j),right]);
      	  	j=j+1;
		   end
   	end
      
      if length(delimleft)>1
   	   result=sbe(result);
	   end
   else
      result=input;
   end
   
   if test==1
      result2=struct('name',{});
      for i=1:length(result)   
         files=dir(result(i).name);
         for j=1:length(files)
            result2=setfield(result2,{length(result2)+1},'name',files(j).name);
         end
      end
      result=result2;
   end % if test
   
end

      