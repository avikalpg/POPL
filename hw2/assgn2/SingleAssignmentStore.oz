declare SAS BindValueToKeyInSAS AddKeyToSAS StoreCounter RetrieveFromSAS BindRefToKeyInSAS

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
      Val = {Dictionary.condGet SAS Key ~1}
      if Val == ~1 then raise missingKeyException(Key) end
      else Val
      end
   end
end

/*{Browse {RetrieveFromSAS 2}}
{Browse {RetrieveFromSAS 1}}
{Browse {RetrieveFromSAS 10}}*/

%% Auxiliary function to Assign
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
end

%% Auxiliary function to BindValueToKeyInSAS
proc{Assign VarList H Val CurrentList}
   for Item in VarList do
      {Browse assignitem2#Item.2}
      case Item.2
      of equivalence(New)|nil then 
	 if New == H then
	       %Item.2.1 = Val %{ValueToBeAssigned Val}}
	    CurrentList := {Append @CurrentList [Item.1 Val]}
	 else
	    CurrentList := {Append @CurrentList Item}
	 end
      [] literal(New)|nil then
	 CurrentList := {Append @CurrentList Item}
      [] record | L | Pairs then
	 local NewList in
	    {Browse Pairs}
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

proc{BindValueToKeyInSAS Key Val}
   case SAS.Key
   of equivalence(H) then
      {Browse mainnnnnnnnnnn#{Dictionary.entries SAS}}
      for Item in {Dictionary.entries SAS} do
	 {Browse item2#Item.2}
	 case Item.2
	 of equivalence(New) then
	    {Browse 'I reached here'}
	    if New == H then
	       {Browse 'here as well'}
	       {Dictionary.put SAS Item.1 Val} %{ValueToBeAssigned Val}}
	    else skip
	    end
	    {Browse 'Finally here as well'}
	 [] literal(New) then
	    skip
	 [] record | L | Pairs then
	    local NewList in
	       {Browse Pairs}
	       NewList = {NewCell nil}
	       {Assign Pairs.1 H Val NewList}
	       {Dictionary.put SAS Item.1 record|L|[@NewList]}
	    end
	 else skip
	 end
      end
   else raise alreadyAssigned(Key Val SAS.Key) end      
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