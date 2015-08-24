
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
{Browse {Taylor2 0.5235}}

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
{Browse {Taylor3 0.5235 2}}

fun {Find Xs F Epsilon}
   case Xs
   of A|B|C then
      if {Abs A-B} > Epsilon then
	 /*{Browse 'Testing code reachability 1'}
	 {Browse  {Find B|C F+A Epsilon}}
	 {Browse 'Testing code reachability 2'}*/
	 {Find B|C F+A Epsilon}
      else %{Browse F}
	 F+A
      end
   end
end

fun {Taylor4 X Epsilon}
   local Xs in
      Xs = {Taylor2 X}
      {Browse test# Xs}
      {Find Xs 0. Epsilon}
   end
end
{Browse {Taylor4 0.5 0.01}}