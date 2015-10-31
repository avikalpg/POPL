declare SAS BindValueToKeyInSAS AddKeyToSAS StoreCounter RetrieveFromSAS BindRefToKeyInSAS TupleForRecord FreeVars

SAS = {Dictionary.new}
StoreCounter = {NewCell 0}

fun{AddKeyToSAS}
   StoreCounter := @StoreCounter + 1 % Check if this works
   {Dictionary.put SAS @StoreCounter equivalence(@StoreCounter)}
   @StoreCounter
end

/* Testing AddKeyToSAS 
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{Browse {Dictionary.entries SAS}}
*/

fun{RetrieveFromSAS Key}
   local Val in
      Val = {Dictionary.condGet SAS Key thisKeyWasNotFoundThrowException}
      if Val == thisKeyWasNotFoundThrowException then raise missingKeyException(Key) end
      else Val
      end
   end
end

/*{Browse {RetrieveFromSAS 2}}
{Browse {RetrieveFromSAS 1}}
{Browse {RetrieveFromSAS 10}}*/


/*%% Auxiliary function to Assign
fun{ValueToBeAssigned Val}
   case Val
   of literal(X) then literal(X)
   [] record|X then
      case X of literal(A)|B then
	 local L in
	    L = [record A B]
	    L
	 end
      [] A|B then
	 local L in
	      L = [record A B]
	    L
	 end
      else
	 {Browse 'Record has no name'}
	 raise namelessRecordException(Val) end
      end
   else Val
   end
end*/

% returns a list with unique elements
fun{Uniq Xs}
   case Xs
   of nil then nil
   [] H|T then H|{Filter T fun{$ X} X \= H end}
   else 'ERROR: Uniq: Input is not a proper List'
   end
end

% Auxiliary function for bind statements in FreeVars function
fun{FreeVarsBindAux Exps}
   case Exps
   of pro|Args|S then {FreeVars S Args} % code changed for proc
   [] H|T then  
      {Uniq {Append {FreeVarsBindAux H} {FreeVarsBindAux T}}}
   [] ident(X) then [Exps]
   else nil end
end

% This is to find out the free variables in a statement
fun{FreeVars Stmt Args}
   local Final SemiFinal Dummy in
      {Browse statementsLeft#Stmt}
      {Browse freevars#Args}
      case Stmt
      of nil then SemiFinal = nil
      [] [nop] then SemiFinal = nil
      [] localvar|ident(X)|S then
	 SemiFinal = {FreeVars S {Uniq {Append Args [ident(X)]}}}
      [] bind|Exps then
	 SemiFinal = {FreeVarsBindAux Exps}
      [] conditional | X | S1 | S2 | nil then
	 SemiFinal = {Uniq {Append {Append {FreeVars S1 Args} {FreeVars S2 Args}} {FreeVarsBindAux X}}}
      [] match | X | P | S1 | S2 | nil then
	 SemiFinal = {Uniq {Append {Append {FreeVars S1 {Uniq {Append Args {FreeVarsBindAux P}}}} {FreeVars S2 Args}} {FreeVarsBindAux X}}}
      [] apply | _ then
	 {Browse 'FREEVARS: APPLY: Not Yet Handled'}
      [] S1|S2 then
	 SemiFinal = {Uniq {Append {FreeVars S1 Args} {FreeVars S2 Args}}}
      else
	 {Browse 'PROC: statements have unrecognised form'#Stmt}
	 SemiFinal = nil
      end
      {List.partition SemiFinal fun{$ X} {List.member X Args} end Dummy Final}
      Final
   end
end
% Changing the definition of ValueToBeAssigned
fun{ValueToBeAssigned Val Env}
   /*fun{TupleForRecord Element}
      case Element
      of ident(X) then X#Env.X
      else 'ERROR: TupleForRecord '#Element
      end
   end*/
   local ListVersion in
      case Val
      of pro | Args | Stmt then
	 {List.map {FreeVars Stmt Args} fun{$ Element} case Element of ident(X) then X#Env.X else 'ERROR' end end  ListVersion} %this should return a list of free variables
	 pro(code:Val closure:{AdjoinList env() ListVersion})
      else Val
      end
   end
end

%% Auxiliary function to BindValueToKeyInSAS
proc{Assign VarList H Val CurrentList}
   for Item in VarList do
      %{Browse assignitem2#Item.2}
      case Item.2
      of equivalence(!H)|nil then 
	 CurrentList := {Append @CurrentList [Item.1 Val]}
      [] literal(New)|nil then
	 CurrentList := {Append @CurrentList Item}
      [] record | L | Pairs then
	 local NewList in
	    %{Browse Pairs}
	    NewList = nil
	    {Assign Pairs.1 H Val NewList}
	    CurrentList := {Append @CurrentList NewList}
	 end
      else
	 CurrentList := {Append @CurrentList Item}
      end
   end
end
/***************************
proc{BindValueToKeyInSAS Key Val}
   case SAS.Key
   of equivalence(H) then
      {Dictionary.put SAS Key Val}
   else raise alreadyAssigned(Key Val SAS.Key) end      
   end
end
*****************************/

proc{BindValueToKeyInSAS Key Val Env}
   local FinalVal in
      FinalVal = {ValueToBeAssigned Val Env}
      case SAS.Key
      of equivalence(H) then
	 for Item in {Dictionary.entries SAS} do
	    {Browse item2#Item.2}
	    case Item.2
	    of equivalence(!H) then
		  {Dictionary.put SAS Item.1 FinalVal}
	    [] literal(New) then
	       skip
	    [] record | L | Pairs | nil then
	       local NewList in
		  %{Browse Pairs}
		  NewList = {NewCell nil}
		  {Assign Pairs H FinalVal NewList}
		  {Dictionary.put SAS Item.1 record|L|[@NewList]}
	       end
	    else skip
	    end
	 end
      else raise alreadyAssigned(Key Val SAS.Key) end      
      end
   end
end

/* Testing 
{Browse {RetrieveFromSAS 1}}
{BindValueToKeySAS 1 5}
{Browse {RetrieveFromSAS 1}}
{BindValueToKeySAS 1 3}
{Browse {RetrieveFromSAS 1}}
*/

/**************************
proc{BindRefToKeyInSAS Key RefKey}
   case SAS.Key
   of equivalence(H) then {Dictionary.put SAS Key SAS.RefKey}
   else raise alreadyAssignedException(Key SAS.RefKey Entry) end
   end
end
*****************************/

proc{BindRefToKeyInSAS Key RefKey}
   local Entry in
      Entry = {Dictionary.get SAS Key}
      case Entry
      of equivalence(H) then
	 for Item in {Dictionary.entries SAS} do
	    if Item.2 == equivalence(H) then {Dictionary.put SAS Item.1 SAS.RefKey}
	    end
	 end
      else raise alreadyAssignedException(Key SAS.RefKey Entry) end
      end
   end
end


/* Test cases 
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{BindRefToKeyInSAS 1 3}
{Browse {Dictionary.entries SAS}}

{BindValueToKeyInSAS 1 34}

{Browse {Dictionary.entries SAS}}
{Browse {Dictionary.toRecord avik SAS}}*/