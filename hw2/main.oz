\insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

declare Interpret Execute

proc{Interpret Input}
   local SemStack in
      SemStack = { NewCell stack( stmt : Input env : env() ) }
      {Execute SemStack}
   end
end

proc{Execute SemStack}
   {Browse @SemStack}
   case @SemStack.stmt
   of nil then {Browse 'Execution completed successfully'}
   [] [nop]|Xs then
      SemStack := stack( stmt:Xs env:@SemStack.env )
      {Execute SemStack}
   else {Browse 'Something went wrong'}
   end
end

{Interpret nil}
{Interpret [ [nop] [nop] [nop] ] }