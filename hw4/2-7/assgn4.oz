declare Concat PartialSums GenOnes Append Xs Zs

fun lazy {Concat Xs Ys}
   case Xs
   of nil then Ys
   [] H|T then H|{Concat T Ys}
   end
end
% {Browse {Concat [1 2 3] [4 5 6]}}

Zs = {Concat [1 2 3] [4 5 6]}
proc {Print Ls}
   case Ls   
   of H|T then
      {Browse H}
      {Print T}
   end
end

{Print Zs}
 


% fun {Append Xs P}
%    case Xs
%    of H|T then H|{Append T P}
%    else [P]
%    end      
% end

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