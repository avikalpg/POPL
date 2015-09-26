\insert 'Unify.oz'
\insert 'Stack.oz'

declare Interpret Execute

proc{Interpret Input}
   local SemStack in
      SemStack = { NewCell [ element(stmt:Input env:env()) ] }
      {Execute SemStack}
   end
end

proc{Execute SemStack}
   {Browse @SemStack#{Dictionary.entries SAS} }
   case @SemStack
   of nil then {Browse 'Execution completed successfully'}
   [] StackElem|_ then 
      case StackElem.stmt
      of nil then
	 {Browse 'Part exec completed'}
	 SemStack := {PopAux @SemStack}
	 {Execute SemStack}
      [] [nop]|Xs then
	 SemStack := element( stmt:Xs env:StackElem.env ) | {PopAux @SemStack}
	 {Execute SemStack}
      [] Top | Xs then
	 case Top
	 of localvar | Ys then
	    local Temp in
	       case Ys
	       of ident(X)|Y then
		  case Y
		  of nil then
		     {Browse 'localvar has no statements in it'}
		     raise emptyScopeException(X) end
		  else
		     {AdjoinAt StackElem.env X {AddKeyToSAS} Temp}
		     SemStack := element( stmt:Y env:Temp ) | element( stmt:Xs env:StackElem.env) | {PopAux @SemStack}
		     {Execute SemStack}
		  end
	       else
		  {Browse 'localvar not used properly'}
		  raise variableNameMissingInLocalvarException(Ys) end
	       end
	    end
	 [] bind | Ys then
	    case Ys
	    of H|T|nil then
	       {Unify H T StackElem.env}
	       /*{Browse semanticStack#SemStack}
	       {Browse store#{Dictionary.entries SAS}}*/
	       SemStack := element( stmt:Xs env:StackElem.env) | {PopAux @SemStack}
	       {Execute SemStack}
	    else
	       {Browse 'Bind statement not in recognised pattern'}
	       raise bindStmtException(Ys) end
	    end
	 [] conditional | Ys then
	    case Ys
	    of ident(X) | S1 | S2 | nil then
	       local Exp in
		  Exp = {RetrieveFromSAS StackElem.env.X}
		  case Exp
		  of equivalence(_) then raise unboundExpressionInConditional(X) end
		  [] true then
		     SemStack := element( stmt:S1 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux @SemStack}
		     {Execute SemStack}
		  [] false then
		     SemStack := element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux @SemStack}
		     {Execute SemStack}
		  [] nil then
		     {Browse 'WARNING: the expression value in conditional operator '#X#' is not a boolean'}
		     SemStack := element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux @SemStack}
		     {Execute SemStack}		     
		  [] literal(0) then
		     {Browse 'WARNING: the expression value in conditional operator '#X#' is not a boolean'}
		     SemStack := element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux @SemStack}
		     {Execute SemStack}		     
		  else
		     {Browse 'WARNING: the expression value in conditional operator '#X#' is not a boolean'}
		     SemStack := element( stmt:S1 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux @SemStack}
		     {Execute SemStack}		     
		  end
	       end
	    else
	       {Browse 'Conditional statement not written in recognised manner'}
	       raise conditionalStmtException(Ys) end
	    end

	 [] match | Ys then
	    case Ys
	    of ident(X) | P1 | S1 | S2 | nil then
	      local Exp in
		  Exp = {RetrieveFromSAS StackElem.env.X}
		  case Exp
		  of record | L | Pairs then
		     {Browse L}
		     case P1
		     of record | L1 | Pairs1
		     then skip
		     else
			skip
		     end
		  else
		     {Browse 'X is not a record.'}
		     raise patternMatchingException(X) end
		  end
	       end
	    end
	 else {Browse 'Not yet handled'}
	 end
      else {Browse 'Something went wrong'}
      end
   end
end
%{Interpret nil}
%{Interpret [ [nop] [nop] [nop] ] }

%{Interpret [[localvar ident(x) [nop]]]} % localvar basic test
%{Interpret [[localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]] [nop] ] [nop] ] [nop] ]} % check for scoping
%{Interpret [[localvar ident(x) ] [nop] [localvar ident(y) [nop]]]}

%{Interpret [[localvar ident(x) [bind ident(x) literal(avi)] [nop] ]]}
%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)]]]]}
%{Interpret [[localvar ident(z) [bind literal(100) ident(z)]]]}

%{Interpret [[localvar ident(x) [localvar ident(x1) [localvar ident(x2) [bind ident(x) [record literal(a) [[literal(feature1) ident(x1)] [literal(feature2) ident(x2)]]]]]]]]}

% Tests for Unification
%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)] [bind ident(x) literal(5)]] [nop] ] [localvar ident(a) [bind ident(a) 23]]]}
%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)] [localvar ident(z) [bind ident(z) ident(x)]]]]]}
%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)] [localvar ident(z) [bind ident(z) ident(x)]] [bind literal(32) ident(x)] ]]]}

%Testing a complex program
%{Interpret [[localvar ident(x) [localvar ident(y) [bind [record literal(a) [[literal(avi) ident(y)] [literal(son) literal(12)]]] ident(x)] [bind ident(y) literal(10)]]]]}

%Our program fails for this
%{Interpret [[localvar ident(x) [localvar ident(x1) [localvar ident(x2) [bind ident(x) [record literal(a) [[literal(feature1) ident(x1)] [literal(feature2) ident(x2)]]]] [bind ident(x1) literal(10)] [bind ident(x2) [record literal(x2) [[literal(1) ident(x1)]]]]]]]]}

%Our Program works for this
%{Interpret [[localvar ident(x) [localvar ident(y) [bind [record literal(a) [[literal(avi) literal(2)] [literal(son) literal(12)]]] ident(x)] [bind ident(x) ident(y)] [bind ident(y) [record literal(a) [[literal(feature1) literal(9)] [literal(feature2) literal(28)]]]]]]]}

%{Interpret [[localvar ident(x) [localvar ident(y) [bind [record literal(a) [[literal(a) ident(y)] [literal(b) literal(12)]]] ident(x)] [bind ident(y) 1]]]]} 


%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)] [localvar ident(z) [bind ident(z) ident(x)]] [bind literal(32) ident(x)][bind literal(3) ident(x)] ]]]}

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(feature1) literal(3)] [literal(feature2) literal(4)]]]]]]}

%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) [record literal(itself) [[literal(1) ident(y)]]]] [bind ident(y) ident(x)]]]]}

%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(y) literal(10)] [bind ident(x) [record ident(y) [[ident(y) literal(first)] [literal(2) ident(y)]]]]]]]}

%%% NOTE: In the following example, our interpreter behaves exactly like Oz %%%
%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) [record ident(y) [[ident(y) literal(first)] [literal(2) ident(y)]]]] [bind ident(y) literal(10)] ]]]}

%Testing for conditional statement

%{Interpret [[localvar ident(x) [conditional ident(x) [[nop]] [[nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) true] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) false] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) literal(0)] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) literal(1)] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}

% Testing for match statement

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(feature1) literal(3)] [literal(feature2) literal(4)]]]][match ident(x) ident(a) [nop] [nop]]]]}

% Testing for proc

%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [[bind ident(x1) ident(x)] [nop]]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [bind ident(x1) ident(x)] [nop]]]]]}
%{Interpret  [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)]] [bind [pro [ident(x1)] [conditional ident(x1) [[nop]] [[localvar ident(y) [bind ident(y) literal(12)]]]]] ident(x)]]]}