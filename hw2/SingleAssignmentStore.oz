\insert 'Stack.oz'

declare SAS BindValueToKeyInSAS AddKeyToSAS StoreCounter RetrieveFromSAS BindRefToKeyInSAS

SAS = {Dictionary.new}
StoreCounter = {NewCell 0}

fun{AddKeyToSAS}
   StoreCounter := @StoreCounter + 1 % Check if this works
   local Value in
      Value = {Dictionary.new}
      {Dictionary.put Value value nil}
      {Dictionary.put Value bound false}
      {Dictionary.put Value equi [ @StoreCounter ]} % This should actually be a set, not List
      {Dictionary.put SAS @StoreCounter Value}
   end
   @StoreCounter
end

/* Testing AddKeyToSAS
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{Browse {AddKeyToSAS}}
{Browse {Dictionary.entries SAS}}
local X in
   for X in {Dictionary.keys SAS} do
      {Browse [ X {Dictionary.entries {Dictionary.get SAS X} } ] }
   end
end
*/

fun{RetrieveFromSAS Key}
   local Val in
      Val = {Dictionary.condGet SAS Key ~1}
      if Val == ~1 then raise missingKeyException(Key) end
      else if {Dictionary.get Val bound} == false then
	      {Dictionary.get Val equi}
	   else
	      {Dictionary.get Val value}
	   end
      end
   end
end

/*{Browse {RetrieveFromSAS 2}}
{Browse {RetrieveFromSAS 1}}
{Browse {RetrieveFromSAS 10}}*/

proc{BindValueToKeySAS Key Val}
   local Entry in
      Entry = {Dictionary.get SAS Key}
      if {Dictionary.get Entry bound} == false then
	 {Dictionary.put Entry value Val}
	 {Dictionary.put Entry bound true}
      else raise alreadyAssigned(Key Val {Dictionary.get Entry value}) end
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

%% INCOMPLETE
proc{BindRefToKeyInSAS Key RefKey}
   local Entry in
      Entry = {Dictionary.get SAS Key}
      if {Dictionary.get Entry bound} == false then
	 {Dictionary.put Entry bound true}
%      else raise alreadyAssigned(Key Val {Dictionary.get Entry value}) end
      end
   end
end