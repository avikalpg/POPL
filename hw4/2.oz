declare Sequence Summation Average Random_number 
   
fun {Sequence N Lim}
   if N =< Lim then
      N|{Sequence N+1 Lim}
   else
      nil
   end   
end

fun {Summation Zs A}
   case Zs
   of X|Xr then  A+X|{Summation Xr A+X}
   [] nil then nil
   end
end

fun {Average S Xs}
  case S
  of X|Xr then
     case Xs
     of Z|Zr then
     {IntToFloat X}/{IntToFloat Z}|{Average Xr Zr}
     [] nil then nil
     end	 
  [] nil then nil
   end
end      

  
fun {Random_number X Lim N}
   if N =< Lim then
      local Y T in
	 {OS.rand X}
	 T= X mod 2
	 T|{Random_number Y Lim N+1}
      end	 
   else
      nil
   end
end

 
local Xs S R X A in 
   thread R={Random_number X 10 1} end 
   thread Xs={Sequence 1 10} end
   thread S={Summation R 0}   end
   thread A={Average S Xs} end
  
   
  % {Browse R.1}
  % {Browse R.2.1}
  % {Browse R.2.2.1}
  % {Browse R.2.2.2.1}
  % {Browse Xs.1}
  % {Browse Xs.2.1}
  % {Browse Xs.2.2.1}
  % {Browse Xs.2.2.2.1}
  % {Browse S.1}
  % {Browse S.2.1}
  % {Browse S.2.2.1}
  % {Browse S.2.2.2.1}
  % {Browse {IntToFloat S.2.2.1}}
   {Browse S}
   {Browse Xs}
   {Browse R}
   {Browse A}
end




