declare Concat Print %PartialSums GenOnes Append Xs Zs

fun lazy {Concat Xs Ys}
   case Xs
   of nil then Ys
   [] H|T then H|{Concat T Ys}
   end
end
% {Browse {Concat [1 2 3] [4 5 6]}}

%Zs = {Concat [1 2 3] [4 5 6]}

proc {Print Ls}
   case Ls   
   of H|T then
      {Browse H}
      {Print T}
   end
end

%{Print Zs}
 

fun {Append Xs P}
   case Xs
   of H|T then H|{Append T P}
   else [P]
   end      
end

% L = nil
% fun {PartialSum Xs}
%    local PartialSumAux in
%       fun {PartialSumAux Xs Ls TempSum}
% 	 case Xs
% 	 of nil then Ls
% 	 [] H|T then {PartialSumAux T {Append Ls H+TempSum} H+TempSum}
% 	 end
%       end
%       {PartialSumAux Xs L 0}
%    end
% end

% %{Browse {PartialSum [1 2 3]}

% fun {GenOnes}
%    1|{GenOnes}
% end

% thread Xs = {GenOnes} end
% thread Zs = {PartialSum Xs} end

% {Browse Zs}

/*declare MergeStream ScaleStream Hamming % As Bs Cs Ds

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

fun lazy {ScaleStream Xs K}
   case Xs
   of nil then nil
   else
      K * Xs.1 | {ScaleStream Xs.2 K}
   end
end

Ds = nil
local As Bs Cs Ds in
   Hamming = 1|Ds
   thread As = {ScaleStream Hamming 2} end
   thread Bs = {ScaleStream Hamming 3} end
   thread Cs = {ScaleStream Hamming 5} end
   thread Ds = {MergeStream As Bs Cs} end
   %{Print Hamming}
end
*/
proc {Print1 Ls N}
   local Aux in
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


declare FindMin Filter IsMultiple Hamming

fun {FindMin A B C}
   if {And A<B A<C}
   then A
   else
      if {And B<A B<C}
      then B
      else C
      end
   end
end

/*fun {Check X T}
   case T
   of nil then true
   [] T|T1 then
      if (X mod T == 0} then false
      else {Check X T1}
      end
   end
end

fun lazy {GenerateMultiples H T}
   local Aux in
      fun {Aux I H}
	 if {Check I*H T} then
	    I*H | {Aux I+1 H}
	 else
	    {Aux I+1 H}
	 end
      end
      {Aux 1 H}
   end
end

fun {Hamming Xs}
   case Xs
   of H|T then
      thread {GenerateMultiples H T} end
      {Hamming T}
   end
end
*/

fun lazy {GenerateMultiples H}
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

Hamming = 1 | nil
local As Bs Cs A B C X X1 X2 X3 in
   A = 0
   B = 0
   C = 0
   X = {NewCell 0}
   
   thread
      As = {GenerateMultiples 2}
      A = 1
   end
   thread
      Bs = {GenerateMultiples 3}
      B = 1
   end
   thread
      Cs = {GenerateMultiples 5}
      C = 1
   end
   thread
      if {And A==1 {And B==1 C==1}} then
	 X1 = {List.last As}
	 X2 = {List.last Bs}
	 X3 = {List.last Cs}
	 X = {FindMin X1 X2 X3}
	 Hamming = {Append Hamming X}
	 if X == X1 then A = 0
	 else
	    if X == X2 then B = 0
	    else C = 0
	    end
	 end
      end
   end
end

	       
	    
	    

%Hamming = {GenerateMultiples 2}

   
	 


{Print1 Hamming 11}
