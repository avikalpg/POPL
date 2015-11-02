%%%%%%%%%%%%%%%%%%%%
% Answer 3
%%%%%%%%%%%%%%%%%%%

declare Concat Print

fun lazy {Concat Xs Ys}
   case Xs
   of nil then Ys
   [] H|T then H|{Concat T Ys}
   end
end

proc {Print Ls}
   case Ls   
   of H|T then
      {Browse H}
      {Print T}
   end
end

%%Test case
%Zs = {Concat [1 2 3] [4 5 6]}
%{Print Zs}

%%%%%%%%%%%%%%%%%%%%
% Answer 4
% Reference: http://www.cse.iitk.ac.in/users/satyadev/fall15/
%%%%%%%%%%%%%%%%%%%%

declare Partition LQuickSort

proc {Partition Xs Pivot Left Right}
   case Xs
   of X|Xr then
      if X < Pivot
      then Ln in
         Left = X | Ln
         {Partition Xr Pivot Ln Right}
      else Rn in
         Right = X | Rn
         {Partition Xr Pivot Left Rn}
      end
   [] nil then Left=nil Right=nil
   end
end

fun lazy {LQuickSort Xs}
   case Xs of X|Xr then Left Right SortedLeft SortedRight in
      {Partition Xr X Left Right}
      {Concat {LQuickSort Left} X|{LQuickSort Right}}
   [] nil then nil
   end
end

%{Print {LQuickSort [2 9 8 1 2 0 6 4]}}
%{Print {LQuickSort [~1 0 4 ~7]}}

%%%%%%%%%%%%%%%%%%%%
% Answer 5
%%%%%%%%%%%%%%%%%%%

declare GenerateMultiples Print1 MergeStream Hamming Times

fun {MergeStream Xs Ys Zs}
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

fun {Times K Xs}
   case Xs
   of nil then nil
   [] H|T then K*H |{Times K T}
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

local As Bs Cs Ds in
   Hamming = 1 | Ds
   thread As = 2|{Times 2 Ds} end
   thread Bs = 3|{Times 3 Ds} end
   thread Cs = 5|{Times 5 Ds} end
   thread Ds = {MergeStream As Bs Cs} end
   %{Print1 As 11}
end
{Print1 Hamming 28}