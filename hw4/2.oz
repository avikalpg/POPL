declare Sequence Summation Average Random_number 
   
fun {Sequence N Lim}
   if N<Lim then
      N|{Sequence N+1 Lim}
   else
      nil
   end   
end

fun {Summation Zs A}
   case Zs
   of X|Xr then  A+X|{Summation Xr A+X}
   [] nil then A
   end
end

fun {Average S Xs}
  case S
  of X|Xr then
     case Xs
     of Z|Zr then
	X*Z|{Average Xr Zr}
     [] nil then nil
     end	 
  [] nil then nil
  end	       
end      

  
fun {Random_number X Lim N}
   if N<Lim then
      local Y in
	 {OS.rand X}
	 X|{Random_number Y Lim N+1}
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
end

