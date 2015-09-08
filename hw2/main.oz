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
		  {AdjoinAt StackElem.env X {AddKeyToSAS} Temp}
		  SemStack := element( stmt:Y env:Temp ) | element( stmt:Xs env:StackElem.env) | {PopAux @SemStack}
		  {Execute SemStack}
	       else {Browse 'localvar not used properly'}
	       end
	    end
	 [] bind | Ys then
	    case Ys
	    of H|T|nil then
	       {Unify H T @SemStack.env}
	       
	    else {Browse 'idk'}
	    end
	 else {Browse 'Not yet handled'}
	 end
      else {Browse 'Something went wrong'}
      end
   end
end
%{Interpret nil}
%{Interpret [ [nop] [nop] [nop] ] }
%{Interpret [[localvar ident(x) [nop]]]}
%{Interpret [[localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]]]] [nop] [localvar ident(x) [nop]]]}
{Interpret [[localvar ident(x) ] [nop] [localvar ident(y) [nop]]]}
%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)]]]]}