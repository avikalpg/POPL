 case B
			of Tuple1|Tuple2
			%{Browse Tuple.1}
			case Tuple1
			of literal(P)|literal(Q)|nil then
			   {Dictionary.put Var P Q}

%local X in
%end

declare Func
proc {Func L}
   case L
   of A|B then {Browse A}
      for Tuple in B do
	 {Browse Tuple.1#Tuple.2}
      end
   else
      {Browse 'No'}
   end
end

{Func [1 [2 3][3 4][1 5]]}

declare Check
proc {Check L}
   case L
   of H|T|nil then {Browse 'First case'}
   [] H|T then {Browse 'second case'}
   else {Browse 'NO'}
   end
end

{Check [1 2 3]}
{Check [1 2]}


   