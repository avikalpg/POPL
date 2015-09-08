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

proc{BindValueToKeySAS Key Val}
   case SAS.Key
   of equivalence(_) then {Dictionary.put SAS Key Val}
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

proc{BindRefToKeyInSAS Key RefKey}
   local Entry in
      Entry = {Dictionary.get SAS Key}
      case Entry
      of equivalence(_) then {Dictionary.put SAS Key SAS.RefKey}
      else raise alreadyAssignedException(Key SAS.RefKey Entry) end
      end
   end
end

/* Test cases 
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{BindRefToKeyInSAS 1 2}
{Browse {Dictionary.entries SAS}}
*/