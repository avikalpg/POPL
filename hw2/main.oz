\insert 'Unify.oz'

declare Interpret Execute

proc{Interpret Input}
   local SemStack in
      SemStack = { NewCell stack( stmt : Input env : env() ) }
      {Execute SemStack}
   end
end

proc{Execute SemStack}
   {Browse @SemStack#{Dictionary.entries SAS} }
   %{Browse {Dictionary.entries SAS}}
   case @SemStack.stmt
   of nil then {Browse 'Execution completed successfully'}
   [] [nop]|Xs then
      SemStack := stack( stmt:Xs env:@SemStack.env )
      {Execute SemStack}
   [] Top | Xs then
      case Top
      of localvar | Ys then
	 local Temp in
	    case Ys
	    of ident(X)|Y then
	       {AdjoinAt @SemStack.env X {AddKeyToSAS} Temp}
	       SemStack := stack( stmt:Y env:Temp )
	       {Execute SemStack}
	    else {Browse 'localvar not used properly'}
	    end
	 end
      else {Browse 'Not yet handled'}
      end
   else {Browse 'Something went wrong'}
   end
end

%{Interpret nil}
%{Interpret [ [nop] [nop] [nop] ] }
%{Interpret [[localvar ident(x) [nop]]]}
{Interpret [[localvar ident(x)
[localvar ident(y)
[localvar ident(x)
[nop]]]]]}