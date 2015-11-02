\insert 'Unify.oz'
\insert 'Stack.oz'

declare Interpret Execute BindArgs MulExecute

proc{Interpret Input}
   local MultiStack Flag SusProg in
      MultiStack = { NewCell [ [ element(stmt:Input env:env()) ] ] }
      Flag = {NewCell false}
      SusProg = {NewCell nil}
      {MulExecute MultiStack Flag SusProg}
   end
end

proc{MulExecute MultiStack Flag SusProg}
   try
      {Execute MultiStack}
      Flag := false
      SusProg := nil
   catch unboundExpressionInConditional(X) then
      {Browse 'Caught Exception in Conditional Stmt'}
      if @Flag then
	 if @MultiStack == @SusProg then
	    {Browse 'Only suspended statements left in'#@MultiStack}
	    {Browse 'Program terminated'}
	 else
	    MultiStack := {Append {PopAux @MultiStack} [@MultiStack.1]}
	    {MulExecute MultiStack Flag SusProg}
	 end
      else
	 Flag := true
	 SusProg := @MultiStack
	 MultiStack := {Append {PopAux @MultiStack} [@MultiStack.1]}
	 {MulExecute MultiStack Flag SusProg}
      end
   end
end

% Auxiliary function for handling apply
fun{BindArgs Param Args Env}
   if {List.length Param} \= {List.length Args} then
      {Browse expected#{List.length Args}}

      {Browse found#{List.length Param}}
      raise invalidArguments(Param) end
   else
      case Param
      of nil then nil
      [] ident(H)|T then
	 case Args
	 of ident(F)|B then
	    local SASIndex in
	       SASIndex = Env.F
	       H#SASIndex|{BindArgs T B Env}
	    end
	 else
	    {Browse 'Something went wrong in argument binding'}
	    raise error(Param Args) end
	 end
      else
	 {Browse 'Something went wrong in argument binding'}
	 raise error(Param Args) end
      end
   end
end


proc{Execute MultiStack}
   {Browse multistack#@MultiStack }
   {Browse store#{Dictionary.entries SAS}}
   case @MultiStack
   of nil then {Browse 'Execution completed successfully'}
   [] SemStack|_ then
      % {Browse SemStack#{Dictionary.entries SAS} }
      case SemStack
      of nil then
	 {Browse 'Execution of stack completed'}
	 MultiStack := {PopAux @MultiStack}
	 {Execute MultiStack}
      [] StackElem|_ then 
	 case StackElem.stmt
	 of nil then
	    {Browse 'Part exec completed'}
	    MultiStack := {PopAux SemStack} | {PopAux @MultiStack}
	    {Execute MultiStack}
	 [] nop|Xs then
	    MultiStack := ( element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
	    {Execute MultiStack}
	 [] [nop]|Xs then
	    MultiStack := ( element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
	    {Execute MultiStack}
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
			MultiStack := ( element( stmt:Y env:Temp ) | element( stmt:Xs env:StackElem.env) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}
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
		  MultiStack := ( element( stmt:Xs env:StackElem.env) | {PopAux SemStack} ) | {PopAux @MultiStack}
		  {Execute MultiStack}
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
			MultiStack := ( element( stmt:S1 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}
		     [] false then
			MultiStack := ( element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}
		     [] nil then
			{Browse 'WARNING: the expression value in conditional operator '#X#' is not a boolean'}
			MultiStack := ( element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}		     
		     [] literal(0) then
			{Browse 'WARNING: the expression value in conditional operator '#X#' is not a boolean'}
			MultiStack := ( element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}		     
		     [] literal(t) then
			MultiStack := ( element( stmt:S1 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}
		     [] literal(f) then
			MultiStack := ( element( stmt:S2 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}
		     else
			{Browse 'WARNING: the expression value in conditional operator '#X#' is not a boolean'}
			MultiStack := ( element( stmt:S1 env:StackElem.env ) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			{Execute MultiStack}		     
		     end
		  end
	       else
		  {Browse 'Conditional statement not written in recognised manner'}
		  raise conditionalStmtException(Ys) end
	       end
	       
	    [] match | Ys then
	       case Ys
	       of ident(X) | P | S1 | S2 | nil then
		  local Exp in
		     Exp = {RetrieveFromSAS StackElem.env.X}
		     case Exp
		     of record | L | _ then
			case P
			of record | L1 | Pairs1 then
			   try 
			      local L in
				 L = {NewCell nil}
				 L := StackElem.env
				 for Tuple in Pairs1.1 do
				    case Tuple.2.1
				    of ident(Y)
				    then
				       L := {AdjoinAt @L Y {AddKeyToSAS}}
				    else
				       skip
				    end
				 end
				 {Unify ident(X) P @L}
				 MultiStack := ( element( stmt:S1 env:@L ) | element( stmt:Xs env:StackElem.env) | {PopAux SemStack} ) | {PopAux @MultiStack}
				 {Execute MultiStack}
			      end
			   catch A then
			      {Browse A}
			      MultiStack := ( element( stmt:S2 env:StackElem.env) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			      {Execute MultiStack}
			   end
			else
			   MultiStack := ( element( stmt:S2 env:StackElem.env) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
			   {Execute MultiStack}
			end
		     else
			{Browse 'X is not a record'#X}
			raise caseHandlingException(X) end
		     end
		  end
	       else
		  {Browse 'Case statements not written in a recognized way'}
		  raise caseStmtException(Ys) end
	       end
	    [] apply | ident(F) | Args then
	       local Func Code Env in
		  Func = {RetrieveFromSAS StackElem.env.F}
		  Env = Func.closure
		  case Func.code
		  of pro | Param | Commands then
		     Code = Commands
		  %{Browse boundArgs#{BindArgs Param Args StackElem.env}}
		     MultiStack := ( element( stmt:Code env:{AdjoinList Env {BindArgs Param Args StackElem.env}}) | element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | {PopAux @MultiStack}
		     {Execute MultiStack}
		  else
		     raise notProperProcedure(Func) end
		  end
	       end
	    [] myThread | Code then
	       local NewStack in
		  NewStack = [ element(stmt:Code env:StackElem.env) ]
		  MultiStack := ( element( stmt:Xs env:StackElem.env ) | {PopAux SemStack} ) | NewStack | {PopAux @MultiStack}
		  {Execute MultiStack}
	       end
	    else {Browse 'Not yet handled'#StackElem.stmt}
	    end
	 else {Browse 'Something went wrong'}
	 end
      else {Browse 'Incorrect Structure of SemStack'#SemStack}
      end
   else {Browse 'Incorrect structure of MultiStack'#@MultiStack}
   end
end
   
%{Interpret nil}
%{Interpret [ nop nop nop ] }
%{Interpret [ [nop] [nop] [nop] ] } % this does not work
   
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
/*{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) [record ident(y) [[ident(y) literal(first)] [literal(2) ident(y)]]]] [bind ident(y) literal(10)] ]]]}*/

%Testing for conditional statement

%{Interpret [[localvar ident(x) [conditional ident(x) [[nop]] [[nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) true] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) false] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) literal(0)] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) literal(1)] [conditional ident(x) [[localvar ident(y) [nop]]] [[nop] [nop]]]]]}

%Testing for case statements
%{Interpret [[localvar ident(x) [bind ident(x) literal(3)][match ident(x) literal(3) [[nop]] [[nop] [nop]]]]]}

%{Interpret [[localvar ident(x) [localvar ident(y) [bind ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) literal(second)]]]][bind ident(x) ident(y)][match ident(x) 3 [[nop]] [[nop] [nop]]]]]]}

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) literal(second)]]]] [match ident(x) [record literal(a) [[literal(1) literal(fist)] [literal(2) literal(second)]]] [[nop]] [[nop] [nop]]]]]}

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) literal(second)]]]] [match ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) ident(h)]]] [[nop]] [[nop] [nop]]]]]}

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) literal(second)]]]] [match ident(x) [record literal(a) [[literal(1) ident(t)] [literal(2) ident(h)]]] [[nop]] [[nop] [nop]]]]]}

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) literal(second)]]]] [match ident(x) [record literal(a) [[literal(1) ident(h)] [literal(2) literal(first)]]] [[nop]] [[nop] [nop]]]]]}

%{Interpret [[localvar ident(x) [bind ident(x) [record literal(a) [[literal(1) literal(first)] [literal(2) literal(second)]]]] [match ident(x) [record literal(a) [[literal(2) literal(second)] [literal(1) ident(h)]]] [[localvar ident(z) [bind ident(z) ident(h)]]] [[nop] [nop]]]]]}

% Testing for proc

%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [nop]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [[bind ident(x1) ident(x)] [nop]]]]]]}
%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [bind ident(x1) ident(x)] [nop]]]]]}
%{Interpret  [[localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)]] [bind [pro [ident(x1)] [conditional ident(x1) [[nop]] [[localvar ident(y) [bind ident(y) literal(12)]]]]] ident(x)]]]}

% Testing for apply
%{Interpret [[localvar ident(x) [bind ident(x) [pro [ident(x1) ident(x2)] [conditional ident(x2) [[bind ident(x1) literal(10)]] [[bind ident(x1) literal(3)] [nop]]]]] [localvar ident(a) [localvar ident(b) [bind ident(b) true] [apply ident(x) ident(a) ident(b)]]]]]}

/*{Interpret [[localvar ident(x) [localvar ident(x1) [bind ident(x) [pro [ident(x2)] [conditional ident(x2) [[bind ident(x1) literal(10)]] [[bind ident(x1) literal(3)] [nop]]]]] [localvar ident(b) [bind ident(b) false] [apply ident(x) ident(b)]]]]]}*/


%Examples sent by Sir

%--------------------------
%Case statements
%-------------------------

/*{Interpret [[localvar ident(x)
 [bind ident(x)
   [record literal(label)
    [[literal(f1) literal(1)]
    [literal(f2) literal(2)]]]]
  [match ident(x)
   [record literal(label)
    [[literal(f1) literal(1)]
     [literal(f2) literal(2)]]] [nop] [nop nop]]]]}*/


/*{Interpret [[localvar ident(foo)
 [localvar ident(result)
  [bind ident(foo) [record literal(bar)
		     [[literal(baz) literal(42)]
		     [literal(quux) literal(314)]]]]
   [match ident(foo) [record literal(bar)
		      [[literal(baz) ident(fortytwo)]
		      [literal(quux) ident(pitimes100)]]] [[bind ident(result) ident(fortytwo)]]
    [[bind ident(result) literal(314)]]]
   [bind ident(result) literal(42)]]]]}*/                                     

/*{Interpret [[localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [bind ident(foo) ident(bar)]
     [bind literal(20) ident(bar)]
     [match ident(foo) literal(21) [bind ident(baz) literal(t)]
      [bind ident(baz) literal(f)]]
     %% Check
     [bind ident(baz) literal(f)]
    [nop]]]]]}*/


/*{Interpret [[localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [localvar ident(result)
     [bind ident(foo) literal(person)]
      [bind ident(bar) literal(age)]
      [bind ident(baz) [record literal(person) [[literal(age) literal(25)]]]]
      [match ident(baz) [record ident(foo) [[ident(bar) ident(quux)]]] [[bind ident(result) ident(quux)]]
       [[bind ident(result) literal(f)]]]
      %% Check
     [bind ident(result) literal(25)]]]]]]}*/

%-----------------------------------------
%Record Bind
%----------------------------------------

/*{Interpret [[localvar ident(x)
 [localvar ident(y)
  [localvar ident(z)
   [bind ident(x)
     [record literal(label)
      [[literal(f1) literal(2)]
      [literal(f2) ident(z)]]]]
    [bind ident(x)
     [record literal(label) [[literal(f1) literal(2)] [literal(f2) literal(1)]]]]]]]]}*/

/*{Interpret [[localvar ident(foo)
  [localvar ident(bar)
   [bind ident(foo) [record literal(person) [[literal(name) ident(bar)]]]]
    [bind ident(bar) [record literal(person) [[literal(name) ident(foo)]]]]
   [bind ident(foo) ident(bar)]]]]}
*/

/*{Interpret [[localvar ident(foo)
  [localvar ident(bar)
   [bind ident(foo) [record literal(person) [[literal(name) ident(foo)]]]]
    [bind ident(bar) [record literal(person) [[literal(name) ident(bar)]]]]
   [bind ident(foo) ident(bar)]]]]} */

%--------------------------------------
%Conditional
%------------------------------------

/*{Interpret [[localvar ident(x)
 [localvar ident(y)
   [localvar ident(x)
     [bind ident(x) ident(y)]
      [bind ident(y) true]
      [conditional ident(y) [nop]
       [bind ident(x) true]]]]
	       [bind ident(x) literal(35)]]]}*/

/*{Interpret [[localvar ident(foo)
  [localvar ident(result)
   [bind ident(foo) literal(t)]
    [conditional ident(foo) [[bind ident(result) literal(t)]]
     [[bind ident(result) literal(f)]]]
    %% Check
   [bind ident(result) literal(t)]]]]}*/

/*{Interpret [[localvar ident(foo)
  [localvar ident(result)
   [bind ident(foo) literal(f)]
    [conditional ident(foo) [[bind ident(result) literal(t)]]
     [[bind ident(result) literal(f)]]]
   [bind ident(result) literal(f)]]]]}
*/

/*
Procedure
*/

/*
{Interpret [[localvar ident(x)
 [bind ident(x)
   [pro [ident(y) ident(x)] [nop]]]
 [apply ident(x) literal(1) literal(2)]]]}
*/

%%%%%% This does not work because according to sir's problem statement, apply only takes variables as arguments%%%%%%%%%%
%{Interpret [localvar ident(x) [bind ident(x) [record literal(name) [[literal(1) literal(1)] [literal(2) ident(x)]]]]]}

/****************************************
******** Test cases - threads **********
****************************************/

/*
local X in
   X = 2
   thread
      local Y in
	 Y = 1
      end
   end
   thread
      local Z in
	 Z = 10
      end
   end
end
****
{Interpret [[localvar ident(x) [bind ident(x) literal(2)] [myThread [localvar ident(y) [bind ident(y) literal(1)]]] [myThread [localvar ident(z) [bind ident(z) literal(10)]]]]]}*/

/*
local X Y in
   thread
      if(Y) then
	 X = 10
	 {Browse X}
      else
	 X = 5
	 {Browse X}
      end
   end
   thread
      Y = false
   end
   {Browse X}
end
*/
%{Interpret [[localvar ident(x) [localvar ident(y) [myThread [bind ident(y) literal(f)]] [myThread [conditional ident(y) [[bind ident(x) literal(10)] nop] [nop [bind literal(5) ident(x)]] ]] ]]]}
			   
{Interpret [[localvar ident(x) [myThread [conditional ident(x) [nop] [nop nop [bind ident(x) literal(t)]]]] [myThread [conditional ident(x) [nop nop] [nop nop nop nop]]]]]}