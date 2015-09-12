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

proc{BindValueToKeyInSAS Key Val}
   case SAS.Key
   of equivalence(H) then
      for Item in {Dictionary.entries SAS} do
	 if Item.2 == equivalence(H) then
	    case Val
	    of literal(X) then {Dictionary.put SAS Item.1 X}
	    [] record|X then
	       case X of literal(A)|B then
		  local L in
		     L = [record A B]
		     {Dictionary.put SAS Item.1 L}
		  end
	       [] A|B then
		  local L in
		     L = [record A B]
		     {Dictionary.put SAS Item.1 L}
		  end
	       else
		  {Browse 'Record has no name'}
	       end
	    else {Dictionary.put SAS Item.1 Val}
	    end
	 end
      end
   else raise alreadyAssigned(Key Val SAS.Key) end      
   end
end

		    /*Var = {Dictionary.new}
		     %{Browse B.1}
		     for Tuple in B.1 do
			{Browse Tuple}
			case Tuple
			of literal(P)|literal(Q)|nil then {Dictionary.put Var P Q}
			[] literal(P)|Q|nil then {Dictionary.put Var P Q}
			   local Temp in
			      Temp = {Dictionary.condGet SAS Q ~1}
			      if Temp == ~1 then {Browse 'Error - variable not declared'}
			      else {Dictionary.put Var P Temp}
			      end
			   end
			else {Browse 'Record fields should be literals'} 
			end
		     end
		%    {Browse {Dictionary.entries Var}}
		     		
		{Dictionary.put SAS Item.1 {Dictionary.toRecord A Var}}
		  end
	       end
	   
	 % else {Browse 'Something went wrong while binding value'# Val}
	 end
      end
   else raise alreadyAssigned(Key Val SAS.Key) end
   end
end*/

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