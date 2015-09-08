%-----Environment---------
%jaiganeshaynamah

\insert 'SingleAssignmentStore.oz'
\insert 'Stack.oz'

declare Env AddToEnv

Env={Dictionary.new}
%={Dictionary.clone Env}
%Dictionary.put Env Stack

fun{AddToEnv X}
   local Store_Id in
      Store_Id = {AddKeyToSAS}
      {Dictionary.put Env X Store_Id}
   end
end

local Envir in
  {Browse Envi( X:3 Y:4)}
  % {Browse Envir}
end
