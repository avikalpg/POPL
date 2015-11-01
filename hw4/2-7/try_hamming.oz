declare Hamming MergeStream GenerateMultiples Print1

fun lazy {MergeStream Xs Ys Zs}
   if Xs.1 < Ys.1
   then
      if Xs.1 < Zs.1
      then Xs.1|{MergeStream Xs.2 Ys Zs}
      else
	 if Xs.1 == Zs.1
	 then Xs.1|{MergeStream Xs.2 Ys Zs.2}
	 else Zs.1|{MergeStream Xs Ys Zs.2}
	 end
      end
   else
      if Ys.1 < Zs.1 then
	 if Xs.1 == Ys.1
	 then Xs.1|{MergeStream Xs.2 Ys.2 Zs}
	 else Ys.1|{MergeStream Xs Ys.2 Zs}
	 end
      else
	 if Ys.1 == Zs.1
	 then
	    if Xs.1 == Ys.1
	    then Xs.1|{MergeStream Xs.2 Ys.2 Zs.2}
	    else Ys.1|{MergeStream Xs Ys.2 Zs.2}
	    end
	 else Zs.1|{MergeStream Xs Ys Zs.2}
	 end
      end
   end
end


proc {Print1 Ls N}
   local Aux X in
      proc {Aux Ls X}
	 if X < N
	 then
	    case Ls
	    of H|T then
	       {Browse H}
	       {Aux T X+1}
	    end
	 end
      end
      {Aux Ls 0}
   end
end

fun {GenerateMultiples H}
   local Aux in
      fun {Aux I H}
	 if H==2 then
	    if {And (I mod 3 \= 0) (I mod 5 \= 0)} then
	       I*H | {Aux I+1 H}
	    else
	       {Aux I+1 H}
	    end
	 else
	    if H == 3 then
	       if (I mod 5 \= 0) then
		   I*H | {Aux I+1 H}
	       else
		  {Aux I+1 H}
	       end
	    else
	       I*H | {Aux I+1 H}
	    end
	 end
      end
      {Aux 1 H}
   end
end

fun {Merge As Bs Cs}
   if {And (As.1 < Bs.1) (As.1 < Cs.1)} then
      As.1 | {Merge As.2 Bs Cs}
   else
      if {And (Bs.1 < Cs.1) (Bs.1 < As.1)} then
	 Bs.1 | {Merge As Bs.2 Cs}
      else
	 Cs.1 | {Merge As Bs Cs.2}
      end
   end
end

%Hamming = 1 | nil

local As Bs Cs Ds in
   thread As = {GenerateMultiples 2} end
   thread Bs = {GenerateMultiples 3} end
   thread Cs = {GenerateMultiples 5} end
   thread Hamming = 1 | {Merge As Bs Cs} end
   %{Print1 As 11}
end
{Print1 Hamming 11}