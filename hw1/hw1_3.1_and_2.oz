declare Factorial Power Taylor2 Taylor3 Find Sum

fun {Factorial N}
   local FactorialAux in
      fun {FactorialAux N Product}
	if N == 0 then Product
	else
	   {FactorialAux N-1 Product*N}
	end
      end
      {FactorialAux N 1}
   end
end

fun {Power X I}
   local PowerAux in
      fun {PowerAux I Answer}
	 if I == 0 then Answer
	 else
	    {PowerAux I-1 Answer*X}
	 end
      end
      {PowerAux I 1.}
   end
end


fun lazy{Taylor2 X}
   local TaylorAux in
      fun {TaylorAux X I Count}
	 ({Power ~1.0 Count}*({Power X I}/{IntToFloat{Factorial I}}))|{TaylorAux X I+2 Count+1}
      end
      {TaylorAux X 1 0}
   end
end

% Test cases for 3.1
%{Browse {Taylor2 0.5235}}

% Ref: http://home.agh.edu.pl/~balis/dydakt/kimp/lab3/
fun {Sum Xs A N}
   if N > 0 then
      case Xs of X|Xr then
	 {Sum Xr A+X N-1}
      end
   else
      A
   end
end

fun {Taylor3 X N}
   local Xs in
      Xs = {Taylor2 X}
      {Sum Xs 0. N}
   end
end
% Testing 3.2.1
/*{Browse {Taylor3 0.5235 10}}
{Browse {Taylor3 0.5235 2}}*/

fun {Find Xs F Epsilon}
   case Xs
   of A|B|C then
      if {Abs A-B} > Epsilon then
	 {Find B|C F+A Epsilon}
      else F+A
      end
   end
end

fun {Taylor4 X Epsilon}
   local Xs in
      Xs = {Taylor2 X}
      {Find Xs 0. Epsilon}
   end
end
/*{Browse 'Testing for 3.2.2'}
{Browse {Taylor4 0.5235 0.001}}
{Browse {Taylor4 0.5235 0.1}}
{Browse {Taylor4 0.5235 0.00001}}*/